import os
import lkml
import copy
import re
import json
import pandas as pd
import looker_sdk
import logging, sys
import time


from dotenv import load_dotenv
from .helpers import render_liquid, has_liquid_template
from .enums import (LOOKER_REPO_PATH,
                   LOOKER_PROJECT_MAPPING_PATH,
                   FOLDERS_TO_SKIP,
                   IGNORE_FILES,
                   JOINS_KEYS,
                   DEFAULT_TIMEFRAMES,
                   DEFAULT_INTERVALS)

# turn off pd.DataFrame SettingWithCopyWarning warnings
pd.options.mode.chained_assignment = None  # default='warn'

# Set variables
load_dotenv()
# function runtime env
LOOKER_REPO_PATH = os.environ.get('LOOKER_REPO_PATH', LOOKER_REPO_PATH)
LOOKER_PROJECT_MAPPING_PATH = os.environ.get('LOOKER_PROJECT_MAPPING_PATH', LOOKER_PROJECT_MAPPING_PATH)

# logging level
logging.basicConfig(stream=sys.stderr, level=logging.INFO)
logger = logging.getLogger(__name__)
logger.setLevel(level=logging.INFO)



class LookerRepo():
    def __init__(self, path, project_mapping):
        logger.info(f"Initiating LookerRepo object from {path}")
        self.path = path
        self.project_mapping = project_mapping
        self.constants = {}
        self.files = self._list_lkml_files()
        self.explores = {}
        self.views = {}
        self.fields = {}
        self.dependencies = {}
        self._load_explores_and_views()

    def _load_lookml(self, path):
        """
        Load a LookML file.

        Args:
            path (str): The path to the LookML file.

        Returns:
            dict: The parsed LookML content.
        """
        with open(path, "r") as f:
            lookml = lkml.load(f)
        return lookml

    def _is_under_skipped_folder(self, path):
        """
        Check if path is or is under one of the to-be-skippped folders (Eg: 99_Tests)

        Args:
            path (str): The path to the LookML file.

        Returns:
            bool: Whether or not the path of LookML file is under a skipped folder.
        """
        for folder_name in FOLDERS_TO_SKIP:
            if folder_name in path:
                return True
        return False

    def _list_lkml_files(self):
        """
        List all LookML files in the repository.

        Returns:
            list: A list of paths to LookML files.
        """
        lkml_files = []
        for dirpath, _, filenames in os.walk(self.path):
            for file in filenames:
                if (file.endswith('.lkml')
                    and file not in IGNORE_FILES
                    and not self._is_under_skipped_folder(dirpath)
                ):
                    lkml_files.append(os.path.join(dirpath, file))
        logger.info(f"Listed {len( [s for s in lkml_files if 'view.lkml' in s])} view files.")
        logger.info(f"Listed {len( [s for s in lkml_files if 'explore.lkml' in s])} explore files.")
        logger.info(f"Listed {len( [s for s in lkml_files if 'model.lkml' in s])} model files.")
        logger.info(f"Listed {len( [s for s in lkml_files if 'manifest.lkml' in s])} manifest files.")
        logger.info(f"Listed total of {len(lkml_files)} lookml files.")
        return lkml_files

    def _has_extend(self, object):
        """
        Check if a view/explore is an extension of another view/explore.

        Args:
            object (dict): The view or explore object to check.

        Returns:
            bool: True if the object is an extension, False otherwise.
        """
        return (object['extends__all'] is not None) if object is not None else False

    def _has_constant(self, string):
        """
        Checks if a string contains the @{...} pattern.

        Args:
            string: The input string to check.

        Returns:
            True if the string contains the pattern in the correct order, False otherwise.
        """
        if not string:
            return False
        pattern = r'@\{.*\}'
        return re.search(pattern, string) is not None

    def _has_liquid_template(self, string):
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

    def _constant_replacement_for_view(self, view: dict):
        """
        Replaces constant patterns in a Looker view dictionary with values from self.constants.

        This function iterates through the `dimension`, `measure`, and `dimension_group` keys
        of the provided view dictionary. For each key, it checks if the corresponding value
        contains any constant patterns (e.g., `@{{constant_name}}`). If a constant pattern is found,
        it replaces it with the corresponding value from the `self.constants` dictionary.

        Args:
            view: A dictionary representing a Looker view.

        Returns:
            A modified view dictionary with constant patterns replaced.
        """
        for measure in view['measures']:
            # group_item_label
            group_item_label = measure['group_item_label']
            if self._has_constant(group_item_label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in group_item_label:
                        group_item_label = group_item_label.replace(f"@{{{constant_key}}}", constant_value)
                        measure['group_item_label'] = group_item_label
                        logger.debug(f"Replaced constant values for {view['name']}.{measure['name']} measure.")
            # if there is still constant in group_item_label after replacement, log as error.
            if self._has_constant(group_item_label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{measure['name']} measure.
                             String: "{group_item_label}" """)

            # group_label
            group_label = measure['group_label']
            if self._has_constant(group_label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in group_label:
                        group_label = group_label.replace(f"@{{{constant_key}}}", constant_value)
                        measure['group_label'] = group_label
                        logger.debug(f"Replaced constant values for {view['name']}.{measure['name']} measure.")
            # if there is still constant in group_label after replacement, log as error.
            if self._has_constant(group_label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{measure['name']} measure.
                             String: "{group_label}" """)

            # label
            label = measure['label']
            if self._has_constant(label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in label:
                        label = label.replace(f"@{{{constant_key}}}", constant_value)
                        measure['label'] = label
                        logger.debug(f"Replaced constant values for {view['name']}.{measure['name']} measure.")
            # if there is still constant in label after replacement, log as error.
            if self._has_constant(label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{measure['name']} measure.
                             String: "{label}" """)

        # dimension
        for dimension in view['dimensions']:
            # group_item_label
            group_item_label = dimension['group_item_label']
            if self._has_constant(group_item_label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in group_item_label:
                        group_item_label = group_item_label.replace(f"@{{{constant_key}}}", constant_value)
                        dimension['group_item_label'] = group_item_label
                        logger.debug(f"Replaced constant values for {view['name']}.{dimension['name']} dimension.")
            # if there is still constant in group_item_label after replacement, log as error.
            if self._has_constant(group_item_label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{dimension['name']} dimension.
                             String: "{group_item_label}"
                             """)

            # group_label
            group_label = dimension['group_label']
            if self._has_constant(group_label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in group_label:
                        group_label = group_label.replace(f"@{{{constant_key}}}", constant_value)
                        dimension['group_label'] = group_label
                        logger.debug(f"Replaced constant values for {view['name']}.{dimension['name']} dimension.")
            # if there is still constant in group_label after replacement, log as error.
            if self._has_constant(group_label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{dimension['name']} dimension.
                             String: "{group_label}" """)

            # label
            label = dimension['label']
            if self._has_constant(label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in label:
                        label = label.replace(f"@{{{constant_key}}}", constant_value)
                        dimension['label'] = label
                        logger.debug(f"Replaced constant values for {view['name']}.{dimension['name']} dimension.")
            # if there is still constant in label after replacement, log as error.
            if self._has_constant(label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{dimension['name']} dimension.
                             String: "{label}" """)

        # dimension_group
        for dimension_group in view['dimension_groups']:
            # group_item_label
            group_item_label = dimension_group['group_item_label']
            if self._has_constant(group_item_label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in group_item_label:
                        group_item_label = group_item_label.replace(f"@{{{constant_key}}}", constant_value)
                        dimension_group['group_item_label'] = group_item_label
                        logger.debug(f"Replaced constant values for {view['name']}.{dimension_group['name']} dimension_group.")
            # if there is still constant in group_item_label after replacement, log as error.
            if self._has_constant(group_item_label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{dimension_group['name']} dimension_group.
                             String: "{group_item_label}"
                             """)

            # group_label
            group_label = dimension_group['group_label']
            if self._has_constant(group_label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in group_label:
                        group_label = group_label.replace(f"@{{{constant_key}}}", constant_value)
                        dimension_group['group_label'] = group_label
                        logger.debug(f"Replaced constant values for {view['name']}.{dimension_group['name']} dimension_group.")
            # if there is still constant in group_label after replacement, log as error.
            if self._has_constant(group_label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{dimension_group['name']} dimension_group.
                             String: "{group_label}" """)

            # label
            label = dimension_group['label']
            if self._has_constant(label):
                for constant_key, constant_value  in self.constants[view['project']].items():
                    if f"@{{{constant_key}}}" in label:
                        label = label.replace(f"@{{{constant_key}}}", constant_value)
                        dimension_group['label'] = label
                        logger.debug(f"Replaced constant values for {view['name']}.{dimension_group['name']} dimension_group.")
            # if there is still constant in label after replacement, log as error.
            if self._has_constant(label):
                logger.error(f"""Couldn't replace all constant value for {view['name']}.{dimension_group['name']} dimension_group.
                             String: "{label}" """)

    def _render_liquid_for_view(self, view: dict):
        """
        Renders liquid in a Looker view dictionary.

        This function iterates through the `dimension`, `measure`, and `dimension_group` keys
        of the provided view dictionary. For each key, it checks if the corresponding value
        contains any liquid block (e.g., `{% liquid_syntax %}`) or liquid variable (e.g., `{{ liquid_variable }}`).
        If a such pattern is found, it renders the liquid and replace it.

        Args:
            view: A dictionary representing a Looker view.

        Returns:
            A modified view dictionary with liquid template rendered.
        """
        # set up liquid context for view variable
        context = {'_view': {'_name': view['name']}}

        # measure
        for measure in view['measures']:
            # set up liquid context for field variable
            context['_field'] = {"_name": f"{view['name']}.{measure['name']}"}

            # group_item_label
            group_item_label = measure['group_item_label']
            if has_liquid_template(group_item_label):
                group_item_label = render_liquid(group_item_label,view['name'],measure['name'])
                measure['group_item_label'] = group_item_label

            # group_label
            group_label = measure['group_label']
            if has_liquid_template(group_label):
                group_label = render_liquid(group_label,view['name'],measure['name'])
                measure['group_label'] = group_label

            # label
            label = measure['label']
            if has_liquid_template(label):
                label = render_liquid(label,view['name'],measure['name'])
                measure['label'] = label

        # dimension
        for dimension in view['dimensions']:
            # set up liquid context for field variable
            context['_field'] = {"_name": f"{view['name']}.{dimension['name']}"}

            # group_item_label
            group_item_label = dimension['group_item_label']
            if has_liquid_template(group_item_label):
                group_item_label = render_liquid(group_item_label,view['name'],dimension['name'])
                dimension['group_item_label'] = group_item_label

            # group_label
            group_label = dimension['group_label']
            if has_liquid_template(group_label):
                group_label = render_liquid(group_label,view['name'],dimension['name'])
                dimension['group_label'] = group_label

            # label
            label = dimension['label']
            if has_liquid_template(label):
                label = render_liquid(label,view['name'],dimension['name'])
                dimension['label'] = label

        ## dimension_group needs to unnest all of its timeframes/intervals component first
        # before rendering for the liquid logic to apply correctly.
        # This is because the liquid template uses `_field._name` as its input context.
        # Refer to `get_field_df()` function for the liquid rendering of dim_groups.

    def _load_explores_and_views(self):
        """
        Load all explores and views from the LookML files.

        This method populates the explores and views dictionaries.
        """
        for file in self.files:
            try:
                project = file.split(self.path)[1].split('/')[0]
                for key, value in self.project_mapping.items():
                    project = project.replace(key, value)

                lookml = self._load_lookml(file)
                if 'explores' in lookml:
                    for explore in lookml['explores']:
                        explore['path'] = file
                        explore['file_name'] = os.path.basename(file)
                        explore['project'] = project
                        explore['is_refined'] = False

                        # set default value for keys that isn't explicitly defined in Lookml
                        explore.setdefault('joins', [])
                        for join in explore['joins']:
                            join.setdefault('sql_where', '')
                            join.setdefault('fields', '')
                            join.setdefault('from', None)
                        explore.setdefault('from', None)
                        explore.setdefault('view_name', None)
                        explore.setdefault('extends__all', None)
                        explore.setdefault('imported_project', None)

                        for join in explore['joins']:
                            # ['type', 'sql_on', 'relationship', 'required_joins', 'name', 'view_label']
                            for key in JOINS_KEYS:
                                join.setdefault(key, '')
                            join.setdefault('view_label', None)

                        self.explores.setdefault(explore['project'], {})[explore['name']] = explore

                if 'views' in lookml:
                    for view in lookml['views']:
                        view['path'] = file
                        view['project'] = project
                        view['is_refined'] = False
                        view['is_extended'] = False

                        # set default value for keys that isn't explicitly defined in Lookml
                        view.setdefault('extends__all', None)
                        view.setdefault('view_label', None)
                        view.setdefault('measures', [])
                        view.setdefault('dimensions', [])
                        view.setdefault('dimension_groups', [])
                        view.setdefault('imported_project', None)
                        # set default value for dimensions
                        for dimension in view['dimensions']:
                            dimension.setdefault('name',None)
                            dimension.setdefault('label',None)
                            dimension.setdefault('description',None)
                            dimension.setdefault('group_label',None)
                            dimension.setdefault('group_item_label',None)
                            dimension.setdefault('type',None)
                            dimension.setdefault('view_label',None)
                            dimension.setdefault('filters__all',None)
                            dimension.setdefault('drill_fields',None)
                            dimension.setdefault('hidden','no')
                        # set default value for measures
                        for measure in view['measures']:
                            measure.setdefault('name',None)
                            measure.setdefault('label',None)
                            measure.setdefault('description',None)
                            measure.setdefault('group_label',None)
                            measure.setdefault('group_item_label',None)
                            measure.setdefault('type',None)
                            measure.setdefault('view_label',None)
                            measure.setdefault('filters__all',None)
                            dimension.setdefault('drill_fields',None)
                            measure.setdefault('hidden','no')
                        # set default value for dimension_groups
                        for dimension_group in view['dimension_groups']:
                            dimension_group.setdefault('name',None)
                            dimension_group.setdefault('label',None)
                            dimension_group.setdefault('description',None)
                            dimension_group.setdefault('group_label',None)
                            dimension_group.setdefault('group_item_label',None)
                            dimension_group.setdefault('timeframes',None)
                            dimension_group.setdefault('intervals',None)
                            dimension_group.setdefault('type',None)
                            if dimension_group['timeframes'] is not None:
                                dimension_group.setdefault('type','time')
                            if dimension_group['intervals'] is not None:
                                dimension_group.setdefault('type','duration')
                            if dimension_group['timeframes'] is None and dimension_group['type'] == 'time':
                                dimension_group['timeframes'] = DEFAULT_TIMEFRAMES
                            if dimension_group['intervals'] is None and dimension_group['type'] == 'duration':
                                dimension_group['intervals'] = DEFAULT_INTERVALS
                            dimension_group.setdefault('view_label',None)
                            dimension_group.setdefault('filters__all',None)
                            dimension.setdefault('drill_fields',None)
                            dimension_group.setdefault('hidden','no')

                        self.views.setdefault(view['project'], {})[view['name']] = view

                if 'remote_dependency' in lookml:
                    self.dependencies[project] = lookml['remote_dependency']['name']

                # parse constants to store their values per project
                if 'constants' in lookml:
                    logger.info(f"Found {len(lookml['constants'])} constant(s) in {project} project.")
                    for constant in lookml['constants']:
                        self.constants.setdefault(project, {})[constant['name']] = constant['value']

            except Exception as e:
                logging.error(f"Error loading. Please check LookML definition {file}: {e}")
                continue
        logger.info(f"Extracted {sum(len(views) for views in self.views.values())} raw views")
        logger.info(f"Extracted {sum(len(explores) for explores in self.explores.values())} raw explores")
        logger.info(f"Extracted {len(self.dependencies)} project dependencies")

        ## handling project importation _NOTE_ no branch/commit specific importation.
        ### explores importation
        for child, parent in self.dependencies.items():
            # Check if both child and parent exist in the projects dictionary
            if not (child in self.explores and parent in self.explores):
                logging.error(f"Either {child} or {parent} project exist or have any explore in the path."
                               "Please check both repos.")
            else:
                for explore, details in self.explores[parent].items():
                    # Only add if the explore does not exist in the child (to prevent overwriting)
                    if explore not in self.explores[child]:
                        self.explores[child][explore] = copy.deepcopy(details)
                        self.explores[child][explore]['project'] = child
                        self.explores[child][explore]['imported_project'] = parent

            ### views importation
            # Check if both child and parent exist in the projects dictionary
            if not (child in self.views and parent in self.views):
                logging.error(f"Either {child} or {parent} project exist or have any view in the path."
                               "Please check both repos.")
            else:
                for view, details in self.views[parent].items():
                    # Only add if the explore does not exist in the child (to prevent overwriting)
                    if view not in self.views[child]:
                        self.views[child][view] = copy.deepcopy(details)
                        self.views[child][view]['project'] = child
                        self.views[child][view]['imported_project'] = parent

            ### constant importation
            # Check if both child and parent exist in the projects dictionary
            if not (child in self.constants and parent in self.constants):
                logging.error(f"Either {child} or {parent} project exist or have any constant in the path."
                               "Please check both repos.")
            else:
                if child not in self.constants: # child project has 0 constant
                    self.constants.setdefault(child, {})
                for constant, details in self.constants[parent].items():
                    # Only add if the explore does not exist in the child (to prevent overwriting)
                    if constant not in self.constants[child]:
                        self.constants[child][constant] = copy.deepcopy(details)


        ## enrich explore level extensions and refinements --> update the list of `joins` for the extending explore
        for project in self.explores.values():
            for explore in project.values():
                if self._has_extend(explore):
                    extend = self.get_explore_by_name(explore['project'], explore['extends__all'][0][0])
                    if extend is None:
                        continue
                    explore['joins'] += extend['joins']
                    if self._has_extend(extend):
                        explore.setdefault('from', extend['from'])
                        explore.setdefault('view_name', extend['view_name'])
                    while self._has_extend(extend):
                        extend = self.get_explore_by_name(explore['project'], extend['extends__all'][0][0])
                        if extend is None:
                            continue
                        explore['joins'] += extend['joins']
                        if self._has_extend(extend):
                            explore.setdefault('from', extend['from'])
                            explore.setdefault('view_name', extend['view_name'])

                if '+' in explore['name']:
                    refinement = self.get_explore_by_name(explore['project'], explore['name'].strip('+'))
                    if refinement is not None:
                        explore['joins'] += refinement['joins']
                        refinement['is_refined'] = True


        ## enrich view level
        #### 1. replace constants
        for project in self.views.values():
            for view in project.values():
                logger.debug(f"Updating constant for view {view['name']}")
                self._constant_replacement_for_view(view)

        #### 2. extensions enrichment
        for project in self.views.values():
            for view in project.values():
                logger.debug(f"Checking extension for view {view['name']}")
                # view is an extend
                if self._has_extend(view):
                    logger.debug(f"Extending view {view['name']}")
                    self._extend_child_view(view, ignore_refine=False)

        #### 3. refinement enrichment has to be done separately after all extensions are enriched.
        for project in self.views.values():
            for view in project.values():
                if '+' in view['name']:
                    logger.debug(f"Refining view {view['name']}")
                    refinement = self.get_view_by_name(view['project'], view['name'].strip('+'))
                    if refinement is not None:
                        parent = len(refinement['dimensions'])
                        child= len(view['dimensions'])
                        self._enrich_child_view(refinement, view)
                        refinement['is_refined'] = True

        #### 4. extensions enrichment again
        for project in self.views.values():
            for view in project.values():
                logger.debug(f"Checking extension for view {view['name']}")
                # view is an extend but not yet get extension enriched with parent data yet
                if self._has_extend(view) and not view['is_extended']:
                    logger.debug(f"Extending view {view['name']}")
                    self._extend_child_view(view, ignore_refine=True)

        #### 5. refinement enrichment again
        for project in self.views.values():
            for view in project.values():
                if '+' in view['name']:
                    logger.debug(f"Refining view {view['name']}")
                    refinement = self.get_view_by_name(view['project'], view['name'].strip('+'))
                    if refinement is not None:
                        parent = len(refinement['dimensions'])
                        child= len(view['dimensions'])
                        self._enrich_child_view(refinement, view)
                        refinement['is_refined'] = True

        #### 6. extensions enrichment again
        for project in self.views.values():
            for view in project.values():
                logger.debug(f"Checking extension for view {view['name']}")
                # view is an extend but not yet get extension enriched with parent data yet
                if self._has_extend(view):
                    logger.debug(f"Extending view {view['name']}")
                    self._extend_child_view(view, ignore_refine=True)

        #### 7. render liquid
        for project in self.views.values():
            for view in project.values():
                logger.debug(f"Rendering liquid for view {view['name']}")
                self._render_liquid_for_view(view)

        logger.debug(f"Finish loading explores and views")

    def _extend_child_view(self, child_view_dict, ignore_refine=False):
        if child_view_dict['is_extended']: # view has already been extended --> False
            return False

        logger.debug(f"Extending {child_view_dict['name']} view.")
        # get parent of input child view
        extend = self.get_view_by_name(child_view_dict['project'], child_view_dict['extends__all'][0][0])
        # get refined parent of input child view
        refine = self.get_view_by_name(child_view_dict['project'],f"+{extend['name']}")

        # can't find parent view --> False
        if extend is None:
            return False

        # parent view is a refine
        if refine is not None:
            # not running in ignore refine mode --> return when encounter the first refine in the extension lineage,
            # due to refines aren't enriched yet --> False
            if not ignore_refine:
                return False

            # running in ignore refine mode --> enrich the child view using the refined version of its parent
            # --> True
            self._enrich_child_view(refine, child_view_dict)
            child_view_dict['is_extended'] = True
            refine['is_extended'] = True
            return True

        # parent is not an extend --> final extension depth reached
        elif self._has_extend(extend): # parent is also an extend --> recursively extend parent first
            logger.debug(f"{child_view_dict['name']} view's parent ({extend['name']} view) needs to be extended first.")
            is_parent_enriched = self._extend_child_view(extend)
            if is_parent_enriched: # if parent isn't enrich --> no child enrichment
                self._enrich_child_view(extend, child_view_dict)
                child_view_dict['is_extended'] = True
                extend['is_extended'] = True
            return is_parent_enriched
        else:
            self._enrich_child_view(extend, child_view_dict)
            child_view_dict['is_extended'] = True
            extend['is_extended'] = True
            return True

    def _enrich_child_view(self, parent_view_dict, child_view_dict):
        # Create deep copies of the parent view to avoid modifying original data
        parent_view_dict = copy.deepcopy(parent_view_dict)
        # extending view level keys
        temp_view_dict = {**parent_view_dict,  **child_view_dict}
        child_view_dict.clear()
        child_view_dict.update(temp_view_dict)

        # extending dimensions key for child view
        ## Extract dimensions from both views
        parent_dimensions = {dimension['name']: dimension for dimension in parent_view_dict['dimensions']}
        child_dimensions = {dimension['name']: dimension for dimension in child_view_dict['dimensions']}

        ## Merge dimensions, prioritizing child dimensions and combining dictionaries
        merged_dimensions = {}
        for name, child_dimension in child_dimensions.items():
            if name in parent_dimensions:
                # rewritten_found
                merged_dimension = {**parent_dimensions[name], **child_dimension}
                merged_dimensions[name] = {k: v if v is not None else parent_dimensions[name][k] for k, v in merged_dimension.items()}
            else:
                merged_dimensions[name] = child_dimension

        ## Add any missing parent dimensions
        for name, parent_dimension in parent_dimensions.items():
            if name not in merged_dimensions:
                merged_dimensions[name] = parent_dimension

        ## Update child view with merged dimensions
        child_view_dict['dimensions'] = list(merged_dimensions.values())

        # extending measures key for child view
        ## Extract measures from both views
        parent_measures = {measure['name']: measure for measure in parent_view_dict['measures']}
        child_measures = {measure['name']: measure for measure in child_view_dict['measures']}

        ## Merge measures, prioritizing child measures and combining dictionaries
        merged_measures = {}
        for name, child_measure in child_measures.items():
            if name in parent_measures:
                # rewritten_found
                merged_measure = {**parent_measures[name], **child_measure}
                merged_measures[name] = {k: v if v is not None else parent_measures[name][k] for k, v in merged_measure.items()}
            else:
                merged_measures[name] = child_measure

        ## Add any missing parent measures
        for name, parent_measure in parent_measures.items():
            if name not in merged_measures:
                merged_measures[name] = parent_measure

        ## Update child view with merged measures
        child_view_dict['measures'] = list(merged_measures.values())

        # extending dimension_groups key for child view
        ## Extract dimension_groups from both views
        parent_dimension_groups = {dimension_group['name']: dimension_group for dimension_group in parent_view_dict['dimension_groups']}
        child_dimension_groups = {dimension_group['name']: dimension_group for dimension_group in child_view_dict['dimension_groups']}

        ## Merge dimension_groups, prioritizing child dimension_groups and combining dictionaries
        merged_dimension_groups = {}
        for name, child_dimension_group in child_dimension_groups.items():
            if name in parent_dimension_groups:
                # rewritten_found
                merged_dimension_group = {**parent_dimension_groups[name], **child_dimension_group}
                merged_dimension_groups[name] = {k: v if v is not None else parent_dimension_groups[name][k] for k, v in merged_dimension_group.items()}
            else:
                merged_dimension_groups[name] = child_dimension_group

        ## Add any missing parent dimension_groups
        for name, parent_dimension_group in parent_dimension_groups.items():
            if name not in merged_dimension_groups:
                merged_dimension_groups[name] = parent_dimension_group

        ## Update child view with merged dimension_groups
        child_view_dict['dimension_groups'] = list(merged_dimension_groups.values())
        return child_view_dict

    def _flatten_dict(self, object):
        """
        Flatten a 2 level nested dict into a single level dict.
        """
        flattened_dict = {}
        for outer_key, inner_dict in object.items():
            for inner_key, value in inner_dict.items():
                new_key = f"{outer_key}|{inner_key}"
                flattened_dict[new_key] = value
        return flattened_dict

    def get_flattened_explores(self):
        """
        Get a single level dict object from a self.explores to be used to turn into pd.DataFrame.

        Returns:
            dict: The explores object but with the project and explore_name combined key.
        """
        return self._flatten_dict(self.explores)

    def get_flattened_views(self):
        """
        Get a single level dict object from a self.views to be used to turn into pd.DataFrame.

        Returns:
            dict: The explores object but with the project and view_name combined key.
        """
        return self._flatten_dict(self.views)


    def get_explore_by_name(self, project, name):
        """
        Get an explore by its name.

        Args:
            name (str): The name of the explore.

        Returns:
            dict: The explore object, or None if not found.
        """
        if not (project in self.explores and name in self.explores[project]):
            logger.error(f"Couldn't get_explore_by_name for {project}.{name}")
            return None
        return self.explores[project][name]

    def get_view_by_name(self, project, name):
        """
        Get a view by its name.

        Args:
            name (str): The name of the view.

        Returns:
            dict: The view object, or None if not found.
        """
        if not (project in self.views and name in self.views[project]):
            logger.error(f"Couldn't get_view_by_name for {project}.{name}")
            return None
        return self.views[project][name]

    def get_explore_df(self):
        """
        Get a DataFrame of all explores.

        Returns:
            pandas.DataFrame: A DataFrame containing information about all explores.
        """
        explores_df = pd.DataFrame(self.get_flattened_explores()).T
        explores_df.rename({'name': 'explore_name'}, axis=1, inplace=True)
        # add another new col `first_view_name` that follow the logic of
        ## coalesct(from, view_name, explore_name)
        explores_df['first_view_name'] = explores_df['from'].combine_first(explores_df['view_name']).combine_first(explores_df['explore_name'])
        explores_df.rename({'first_view_name': 'view_name',
                            'from': 'view_name_from_param',
                            'view_name': 'view_name_param'
                            }, axis=1, inplace=True)

        explores_df = explores_df[explores_df['view_name'].apply(lambda x: not isinstance(x, dict))]
        return explores_df

    def get_all_view_df(self):
        """
        Get a DataFrame of all views extracted from raw lookml code.

        Returns:
            pandas.DataFrame: A DataFrame containing information about all views,
            including explore name, project, join type, relationship, SQL conditions,
            view name, joined view name, view label, fields, required joins,
            extensions, SQL where clauses, and source tables.
        """

        views_df = pd.DataFrame(self.get_flattened_views()).T
        # drop refined views
        views_df = views_df[views_df['is_refined'] == False]
        views_df.rename({
            'name': 'view_name'
            }, axis=1, inplace=True)
        views_df['view_label'] = views_df['label'].combine_first(views_df['view_label'])
        views_df.drop(['label'], axis=1, inplace=True)
        return views_df

    def get_field_df(self):
        """
        Get a DataFrame of all fields, including extended and refined fields.

        Returns:
            pandas.DataFrame: A DataFrame containing information about all fields.
        """
        views_df = self.get_all_view_df()
        logger.info(f"Got {len(views_df)} view in `get_all_view_df`.")

        views_df = views_df.explode('extends__all').explode('extends__all')


        # exploding measures for all views
        not_empty_measures = [x != [] for x in views_df['measures']]
        measure_exploded = views_df[not_empty_measures].explode('measures')
        measure_exploded['field_type'] = 'measure'
        measure_expanded = measure_exploded['measures'].apply(pd.Series)
        measure_expanded.rename({
            'name': 'field_name',
            'label': 'field_label',
            'description': 'field_description',
            'group_label': 'field_group_label',
            'group_item_label': 'field_group_item_label',
            'type': 'field_data_type',
            'view_label': 'field_view_label',
            'filters__all': 'field_filters',
            'drill_fields': 'field_drill_fields',
            'hidden': 'is_field_hidden'
            }, axis=1, inplace=True)
        measure_exploded = pd.concat([measure_exploded, measure_expanded], axis=1)


        # exploding dimensions for all views
        not_empty_dimensions = [x != [] for x in views_df['dimensions']]
        dimension_exploded = views_df[not_empty_dimensions].explode('dimensions')
        dimension_exploded['field_type'] = 'dimension'
        dimension_expanded = dimension_exploded['dimensions'].apply(pd.Series)
        dimension_expanded.rename({
            'name': 'field_name',
            'label': 'field_label',
            'description': 'field_description',
            'group_label': 'field_group_label',
            'group_item_label': 'field_group_item_label',
            'type': 'field_data_type',
            'view_label': 'field_view_label',
            'filters__all': 'field_filters',
            'drill_fields': 'field_drill_fields',
            'hidden': 'is_field_hidden'
            }, axis=1, inplace=True)
        dimension_exploded = pd.concat([dimension_exploded, dimension_expanded], axis=1)


        # exploding dimension groups for all views
        not_empty_dimension_groups = [x != [] for x in views_df['dimension_groups']]
        dimension_group_exploded = views_df[not_empty_dimension_groups].explode('dimension_groups')
        dimension_group_exploded['field_type'] = 'dimension_group'
        dimension_group_expanded = dimension_group_exploded['dimension_groups'].apply(pd.Series)
        dimension_group_expanded.rename({
            'name': 'field_name',
            'label': 'field_label',
            'description': 'field_description',
            'group_label': 'field_group_label',
            'group_item_label': 'field_group_item_label',
            'type': 'field_data_type',
            'view_label': 'field_view_label',
            'filters__all': 'field_filters',
            'drill_fields': 'field_drill_fields',
            'hidden': 'is_field_hidden'
            }, axis=1, inplace=True)
        dimension_group_exploded = pd.concat([dimension_group_exploded, dimension_group_expanded], axis=1)

        # further explode dimension_group type time
        dimension_group_time_exploded = dimension_group_exploded[dimension_group_exploded['field_data_type'] == 'time']
        dimension_group_time_exploded = dimension_group_time_exploded.explode('timeframes')
        dimension_group_time_exploded['field_name'] = dimension_group_time_exploded.apply(lambda x: f"{x['field_name']}_{x['timeframes']}", axis=1)
        # further explode dimension_group type duration
        dimension_group_duration_exploded = dimension_group_exploded[dimension_group_exploded['field_data_type'] == 'duration']
        dimension_group_duration_exploded = dimension_group_duration_exploded.explode('intervals')
        dimension_group_duration_exploded['field_name'] = dimension_group_duration_exploded.apply(lambda x: f"{x['intervals']}s_{x['field_name']}", axis=1)

        dimension_group_exploded = pd.concat([dimension_group_time_exploded, dimension_group_duration_exploded], axis=0)



        # render liquid for
        # field_group_item_label
        dimension_group_exploded['field_group_item_label'] = dimension_group_exploded.apply(
            lambda x: render_liquid(
                x['field_group_item_label'],
                x['view_name'],
                x['field_name']
            ), axis=1)
        # field_group_label
        dimension_group_exploded['field_group_label'] = dimension_group_exploded.apply(
            lambda x: render_liquid(
                x['field_group_label'],
                x['view_name'],
                x['field_name']
            ), axis=1)
        # field_label
        dimension_group_exploded['field_label'] = dimension_group_exploded.apply(
            lambda x: render_liquid(
                x['field_label'],
                x['view_name'],
                x['field_name']
            ), axis=1)
        # column filter
        columns = ['view_name', 'project', 'imported_project', 'view_label', 'field_type',
                   'field_name', 'field_label', 'field_group_label',  'field_data_type',
                   'is_field_hidden', 'field_group_item_label', 'field_filters', 'extends__all',
                   'field_view_label', 'field_description'
                   ]

        self.fields = pd.concat([
            dimension_exploded.reset_index()[columns],
            measure_exploded.reset_index()[columns],
            dimension_group_exploded.reset_index()[columns],
            ], ignore_index=True)
        self.fields = self.fields.replace({float('nan'): None})
        return self.fields




    def get_view_df(self):
        """
        Get a DataFrame of all views that are used as the base view or belong to a join of all explores.

        Returns:
            pandas.DataFrame: A DataFrame containing information about all views,
            including explore name, project, join type, relationship, SQL conditions,
            view name, joined view name, view label, fields, required joins,
            extensions, SQL where clauses, and source tables.
        """
        explores = self.get_explore_df()
        # drop refined explores
        explores = explores[explores['is_refined'] == False]
        # explode all explore that has joins values and
        # and then concatenate with explores that dont have any joins
        not_empty_joins = [x != [] for x in explores['joins']]
        views = pd.concat([explores[not_empty_joins], explores.explode('joins')])
        columns = ['explore_name', 'project', 'view_name', 'view_name_from_param', 'view_name_param', 'joins', 'extends__all']
        views = views[columns]
        views_expanded = views['joins'].apply(pd.Series).rename({
            'name': 'join_param', 'from': 'join_from_param',
            'view_label': 'join_view_label'
            }, axis=1)
        # coalesce(from, join_name)
        views_expanded['joined_view_name'] = views_expanded['join_from_param'].combine_first(views_expanded['join_param'])
        views = pd.concat([views, views_expanded], axis=1)
        columns = ['explore_name', 'project', 'type', 'relationship', 'sql_on',
                   'view_name', 'joined_view_name', 'join_param', 'join_from_param',
                   'view_name_param', 'view_name_from_param', 'join_view_label', 'fields',
                   'required_joins', 'extends__all', 'sql_where'
                   ]
        views = views[columns]
        views['joined_view_name'] = views['joined_view_name'].fillna(views['view_name'])
        views.drop(columns=['view_name'], inplace=True)
        views.rename({'joined_view_name': 'view_name'}, axis=1, inplace=True)

        return views[['view_name', 'explore_name', 'project', 'join_param',
                      'join_from_param', 'view_name_param', 'view_name_from_param',
                      'join_view_label'
                      ]].drop_duplicates(subset=['view_name', 'explore_name', 'project', 'join_param',
                                                'join_from_param', 'view_name_param', 'view_name_from_param',
                                                'join_view_label'
                                                 ])


    def get_lookml_models_api_df(self):
        """
        Get a DataFrame of all modelsdirectly from Looker API.
        Link to API method used: https://developers.looker.com/api/explorer/4.0/methods/LookmlModel/all_lookml_models

        Returns:
            pandas.DataFrame: A DataFrame containing information about all explores,
            including explore name, project, explore label, model name,...
        """
        sdk = looker_sdk.init40()
        models = sdk.all_lookml_models()

        # convert looker_sdk class -> dict
        models = list(map(dict,models))
        for model in models:
            model['explores'] = list(map(dict, model['explores']))

        models_df = pd.DataFrame(models)
        models_df.drop(columns=['can'])
        models_df.rename({'name': 'model_name', 'project_name': 'project'}, axis=1, inplace=True)

        return models_df

    def get_explore_model_df(self):
        """
        Get a DataFrame of all explores and their respective models directly from `self.get_lookml_models_api_df()`.

        Returns:
            pandas.DataFrame: A DataFrame containing information about all explores,
            including explore name, project, explore label, model name,...
        """
        models_df = self.get_lookml_models_api_df()
        explores_df = models_df.explode('explores')
        explores_expanded = explores_df['explores'].apply(pd.Series).rename({'name': 'explore_name'}, axis=1)
        explores_df = pd.concat([explores_df,explores_expanded], axis=1)

        return explores_df[['model_name', 'project', 'explore_name']]

    def run(self):
        # get explore-model relation per model via Looker API `sdk.all_lookml_models()` endpoint
        explores = self.get_explore_model_df()

        logger.info(f"Got {len(explores)} lookml explore-model.")

        # get view-explore relation per explore via parsing lookml code
        views = self.get_view_df()
        logger.info(f"Got {len(views)} lookml view-explore.")

        # merge to get view-explore-model relation
        view_model = pd.merge(views, explores, on=['explore_name', 'project'], how='left')
        logger.info(f"Merged and got {len(view_model)} lookml view-explore-model.")


        field_df = self.get_field_df()
        logger.info(f"Got {len(field_df)} lookml field.")
        # reserve refinements (ex: `view: +user`)
        field_df['view_name_orig'] = field_df['view_name']

        # strip the prefix + of refining view for joining with `view_model`
        field_df['view_name'] = field_df['view_name'].str.lstrip('+')

        final_df =  pd.merge(field_df, view_model, on=['view_name', 'project'], how='left')

        # restore refinement view_name
        final_df['view_name'] = final_df['view_name_orig']
        final_df.drop(columns=['view_name_orig'], inplace=True)
        # filter out imported but not used rows
        #    CONDITION: imported_project is null or model_name is not null
        final_df = final_df[final_df['imported_project'].isna() | (final_df['model_name'].notna())]
        final_df['view_label'] = final_df['field_view_label'].combine_first(final_df['join_view_label'].combine_first(final_df['view_label']))
        # bulk liquid rendering
        ## for `view_label`
        final_df['view_label'] = final_df.apply(
            lambda x: render_liquid(
                x['view_label'],
                x['view_name'],
                x['field_name']
            ), axis=1)
        ## for the remaining `field_label` due to some liquid
        ## require _explore._name context which has to be done here,
        ## after mapping the views to the explores
        final_df.loc[final_df['field_label'].apply(has_liquid_template), 'field_label'] = final_df[final_df['field_label'].apply(has_liquid_template)].apply(
            lambda x: render_liquid(
                x['field_label'],
                x['view_name'],
                x['field_name'],
                _explore={'_name': x['explore_name']}
            ), axis=1
        )
        final_df.drop(['field_view_label', 'join_view_label'], axis=1, inplace=True)
        logger.info(f"Got {len(final_df)} lookml fields after merging with explore-model and filtering unused importations.")
        return final_df

# For running locally
if __name__ == '__main__':
    start_time = time.perf_counter()
    with open(LOOKER_PROJECT_MAPPING_PATH, "r") as f:
        project_mapping = json.load(f)

    lr = LookerRepo(LOOKER_REPO_PATH, project_mapping)
    lr.run().to_csv('./test_final.csv', index=False)
    end_time = time.perf_counter()

    # Calculate the elapsed time
    elapsed_time = end_time - start_time
    print(f"Execution time: {elapsed_time} seconds")