import json
import re
import liquid
import yaml
import hashlib
import logging
import sys
from google.cloud.storage import Client

# logging level
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

def read_json(file_path):
    with open(file_path) as file:
        return json.load(file)

def read_yaml(file_path):
    with open(file_path) as file:
        return yaml.safe_load(file)

def get_object(
        storage_client: Client,
        bucket_name: str,
        object_full_path: str,
    ):
    """
    Download object content to memory
    """
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(object_full_path)
    print(f"Getting content for file [{object_full_path}] from bucket [{bucket_name}]")
    return blob.download_as_string()

def get_schema(
        storage_client: Client,
        bucket_name: str,
        object_full_path: str,
    ):
    """
    Download schema file and parse
    """
    content = get_object(
        storage_client,
        bucket_name,
        object_full_path,
    )
    return yaml.safe_load(content)

def parse_input(
        storage_client: Client,
        bucket_name: str,
        object_full_path: str,
        table_name: str,
    ):
    """
    Parse table input configuration
    """
    data: dict = get_schema(
        storage_client,
        bucket_name,
        object_full_path,
    )
    return data.get(table_name)


def transform_api_output(output):
    # turn each output record in to a dictionary
    output = list(map(dict,output))
    for model in output:
        # Remove 'can'
        model.pop('can')

        # turn each explore record in to a dictionary
        model['explores'] = list(map(dict, model['explores']))

        # set default value for key 'explore_label' for each explore
        for explore in model['explores']:
            explore.setdefault('label', None)
            explore.setdefault('description', None)

    # unnest explores fields
    transformed_data = [
        {
            **{
                'id': hashlib.sha256((model['name'] + '-' + explore['name']).encode()).hexdigest(),
                'model_name': model['name'],
                'model_label': model['label'],
                'model_allowed_db_connection_names': model['allowed_db_connection_names'],
                'model_has_content': model['has_content'],
                'project_name': model['project_name'],
                'model_unlimited_db_connections': model['unlimited_db_connections']
            },
            **{
                'explore_name': explore['name'],
                'explore_label': explore['label'],
                'is_explore_hidden': explore['hidden'],
                'explore_description': explore['description'],
                'explore_group_label': explore['group_label']
            }
        }
        for model in output
        for explore in model['explores']
    ]

    return transformed_data

def contains_unique_element(list1, list2):
    """
    Checks if list1 contains at least one element that doesn't exist in list2.

    Args:
        list1: The first list.
        list2: The second list.

    Returns:
        True if list1 contains at least 1 element that doesn't exist in list2, False otherwise.
    """

    for element in list1:
        if element not in list2:
            return True
    return False

def has_liquid_template(string):
    """
    Checks if a string is a Liquid template.

    Args:
        string: The input string to check.

    Returns:
        True if the string contains a Liquid template block, False otherwise.
    """

    if not string:
        return False
    liquid_block_pattern = r'{%.*%}'
    liquid_variable_pattern = r'\{\{.*\}\}'

    return (re.search(liquid_block_pattern, string) is not None) or (re.search(liquid_variable_pattern, string) is not None)


def extract_all_liquid_context_variables(data):
    """
    Extracts nested keys from a liquid context, and flattens them into a periods separated string.
    Output is a list of the flattened nested keys strings.

    Example:
        Input: {'_field':{'_name':'field_name'}, '_view': {'_name':'view_name'}}
        Output: ['_field._name','_view._name']

    Args:
        data: The input dictionary.

    Returns:
        A list of nested keys.
    """

    keys = []
    for key, value in data.items():
        if isinstance(value, dict):
            for nested_key in value.keys():
                keys.append(f"{key}.{nested_key}")
        else:
            keys.append(key)
    return keys

def render_liquid(template_string, view_name, field_name, **kwargs):
    context = {
        '_view': {'_name': view_name},
        '_field': {'_name': f'{view_name}.{field_name}'}
    }

    # Update the context with any additional keyword arguments
    context.update(kwargs)

    if not has_liquid_template(template_string):
        return template_string

    # clean lkml extraction of special characters
    ## \\ --> \
    ## \' --> '
    clean_template_string = re.sub(r'\\(.)', r'\1',template_string)
    try:
        template = liquid.Template(clean_template_string)
    except Exception as e:
        logging.error(f"Error rendering liquid template. Please check:\n\t- LookML definition in field {view_name}.{field_name}\n\t- Template: \"{template_string}\"\nError: {e}")
        return template_string

    ## check if the liquid template only uses default context of view and field or not.
    ## The purpose for this check is to catch additional more complex lookml-liquid logic.
    undefined_variables = [key for key in template.analyze().global_variables.keys()]
    context_variables = extract_all_liquid_context_variables(context)

    # if the template have variables that doesn't specified in the context --> skip rendering
    if contains_unique_element(undefined_variables, context_variables):
        logging.error(f"""Error when rendering liquid for {view_name}.{field_name} dimension_group,
                        due to missing context:\n\t[{undefined_variables}]
                        """)
        return template_string
    else:
        return template.render(context).strip('\n ')
