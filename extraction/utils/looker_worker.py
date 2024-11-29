
import looker_sdk
from datetime import datetime
from looker_sdk.sdk.api40 import methods as methods40
from looker_sdk import models40 as models 
import time
import os
from utils.worker import Worker
import pandas as pd
from io import StringIO
import csv
from utils.enums import (ROW_LIMIT,
                         QUERY_TIMEZONE,
                         QUERY_TIMEOUT,
                         DATETIME_FORMAT,
                         START_TIME,
                         ID_CURSOR_FIELD,
                         NULL_CURSOR_FIELD
                         )
import hashlib




class LookerWorker(Worker):
    def __init__(
            self,
            explore_name: str,
            table_name: str,

            **kwargs

            # start_time: str,
            # row_limit: int,
            # query_timezone: str,
            # datetime_format: str,
            # is_incremental: bool = True,

            # gcs_bucket_name: str,
            # looker_sdk: methods40.Looker40SDK,
            # bq_project_id: str,
            # bq_dataset_id: str,
            # bq_table_name: str,
            # file_num: int,
            # run_time: str,
            # is_backfill_with_offset: bool = False,
            # bigquery_client: bigquery.Client,
            # storage_client: storage.Client,
            # gcs_path_prefix: str = None,
            # temp_bq_dataset_id: str = None,
            ) -> None:
        super().__init__(explore_name,table_name)  
        self.sdk = looker_sdk.init40()
        self.start_time = kwargs.get('start_time',START_TIME)
        self.row_limit = ROW_LIMIT
        self.query_timezone= QUERY_TIMEZONE
        self.datetime_format= DATETIME_FORMAT




        # self.gcs_bucket_name = gcs_bucket_name
        # self.bq_project_id = bq_project_id
        # self.bq_dataset_id = bq_dataset_id
        # self.bq_table_name = bq_table_name
        # self.file_num = file_num

        # self.bq_full_table_id = f"{self.bq_project_id}.{self.bq_dataset_id}.{self.bq_table_name}"
        # self.temp_bq_dataset_id = temp_bq_dataset_id if temp_bq_dataset_id else bq_dataset_id
        # self.schema = [
        #     bigquery.SchemaField(name=field["name"], field_type=field["type"], description=field["description"])
        #     for field in self.table_data["schema"]
        #     ]
        self.is_id_cursor_field = False
        if not self._dependent_yaml:
            self.cursor_field: str = self.table_data["cursor_field"] or (self.table_data["primary_key"] if not isinstance(self.table_data["primary_key"], list) else self.table_data["batch_cursor_field"])  # Cursor field in Looker query
            if self.cursor_field and (self.cursor_field == ID_CURSOR_FIELD or self.cursor_field.split(".")[1] == ID_CURSOR_FIELD):
                print(f"Cursor field is {self.cursor_field}.")
                self.is_id_cursor_field = True            


        # Cursor field in BigQuery table
        self.bq_cursor_field = self.get_bq_cursor_field(self.cursor_field)
        # Primary key in BigQuery table
        self.bq_primary_key = ""
        if isinstance(self.table_data["primary_key"], str):
            self.bq_primary_key = self.table_data["primary_key"].split('.')[-1]
        elif isinstance(self.table_data["primary_key"], list):
            self.bq_primary_key = self.table_data["primary_key"]   



        self.run_query(self.fetch_rowcount())


    def fetch_rowcount(self):
        model = self.table_data["model"]
        view = self.table_data["view"]
        fields = ['user.count']
        body = models.WriteQuery(
                        model = model,
                        view = view,
                        fields = fields,
                        limit = str(self.row_limit),
                        query_timezone = self.query_timezone,
                        )
        query = self.sdk.create_query(
            body = body
        )
        query_id = query.id
        if not query_id:
            raise ValueError(f"Failed to create query for view [{view}]")
        print(f"Successfully created query, query_id is [{query_id}]"
            f"query url: {query.share_url}"
            )
        return query_id        


    def create_query(
            self,
            table_data,
            start_time: str,
            ) -> str:
        """
        Create Looker Query
        Ref: https://developers.looker.com/api/explorer/4.0/methods/Query/create_query?sdk=py
        """
        model = table_data["model"]
        view = table_data["view"]
        fields = table_data["fields"]
        


        cursor_field = self.cursor_field

        sorts = []
        print(f"Extracting in incremental mode for view [{view}].")
        sorts = [cursor_field] if cursor_field else []
        if not self.is_id_cursor_field:
            filters = {cursor_field: f"after {start_time}"} if cursor_field else {}
        else:
            filters = {cursor_field: f">= {start_time}"} if cursor_field else {}
        # filters.update(self.table_data['filters'] if self.table_data['filters'] else {})
        filters = {}
        print(
            f"Creating query on view [{view}], filters {filters}, cursor_field {cursor_field},"
            f" timezone [{self.query_timezone}]"
            f" fields [{fields}]"
            )
        
        body = models.WriteQuery(
                model = model,
                view = view,
                fields = fields,
                filters = filters,
                sorts = sorts,
                limit = str(self.row_limit),
                query_timezone = self.query_timezone,
                )
        query = self.sdk.create_query(
            body = body
        )
        query_id = query.id
        if not query_id:
            raise ValueError(f"Failed to create query for view [{view}]")
        print(f"Successfully created query, query_id is [{query_id}]"
            f"query url: {query.share_url}"
            )
        return query_id




    def run_query(self,query_id: str):
        """
        Run query and save data to GCS
        """
        create_query_task = models.WriteCreateQueryTask(
            query_id=query_id, result_format=models.ResultFormat.csv
        )
        print("Creating async query")
        task = self.sdk.create_query_task(body=create_query_task)
        if not task.id:
            raise ValueError(f"Failed to create query task for query id [{query_id}]")
        query_task_id = task.id

        print(f"Created async query task id [{query_task_id}] for query id [{query_id}]"
              )

        elapsed = 0.0
        delay = 5.0  # waiting seconds
        while True:
            poll = self.sdk.query_task(query_task_id = query_task_id)
            if poll.status == "failure" or poll.status == "error":
                raise Exception(f"Query failed. Response: {poll}")
            elif poll.status == "complete":
                break
            time.sleep(delay)
            elapsed += delay
            if elapsed >= QUERY_TIMEOUT:
                raise Exception(
                    f"Waited for [{elapsed}] seconds, which exceeded timeout"
                    )
        print(f"Query task completed in {poll.runtime:.2f} seconds")
        print(f"Waited {elapsed} seconds")

        task_result = self.sdk.query_task_results(task.id)

        return task_result


    def fetch(self, **kwargs):
        if not self._dependent_yaml:
            query_id = self.create_query(self.table_data, 
                                self.start_time,
                                )
            
            query_results = self.run_query(query_id)
            self.query_results = query_results
        elif self._dependent_yaml: 
            self.get_explore_label()
            self.df = self.get_explore_label()
            

    def map_fields_name_with_config(self):
        """
        uses the field name specified in the schema file instead 
        of fields returned from the api.
        plus, this maps 1-1 with explore's view.
        """
        schema_info = self.schema_info
        columns = [schema_info[i]['name'] for i,_ in enumerate(schema_info)]
        self.df.columns = columns

    def dump(self, **kwargs) -> None:
            if not self._dependent_yaml:
                query_results = self.query_results
                self.df = pd.read_csv(StringIO(query_results)) 
            
            self.map_fields_name_with_config()

            explore = self.explore_name
            table = self.table_name
            

            # create the dir
            if not os.path.exists(self.csv_target_path):
                os.mkdir(self.csv_target_path)

            self.df.to_csv(self.csv_name, 
                    index=False,
                    quotechar='"',
                    quoting=csv.QUOTE_MINIMAL,
                    )
            print(f"sucessfully extracted explore '{explore}' table '{table}'. \n"
                f"total rows extracted: {len(self.df)}. \n"
                f"output file: '{self.csv_name}' \n"
                )
    def transform_api_output(self,output):
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
    
    def get_explore_label(self):
        output = self.sdk.all_lookml_models()
        transformed_data = self.transform_api_output(output)

        header = list(transformed_data[0].keys())
        values = [i.values() for i in transformed_data]
        df = pd.DataFrame(values,columns=header)

        return df

    def get_table_rowcount(self):
        """
        Returns the number of rows in the table.
        """
        table_name = self.table_name
        table_rowcount = self.sdk.table_row_count(table_name)
        return table_rowcount


    def generate_query_rn(self):
        pass

    def get_bq_cursor_field(self, cursor_field):
        """
        Table can use a field within itself as a cursor field. If a table
        doesn't have a datetime field, it may use one from a related table
        as its cursor field (i.e. event_attribute using event.created_time
        as its cursor field).
        Cursor field may also be null, indicating that there's no way to
        get the data incrementally. Data must be full refreshed.
        """
        # If there's cursor field, check if table depends on another table field
        # Otherwise return NULL_CURSOR_FIELD
        if cursor_field:
            # If only 1 cursor field return str of bq cursor field
            if isinstance(cursor_field, str):
                # If cursor field has table_name of this table in it, it means table is
                # using its own fields as cursor field. In this case, remove the table name
                if cursor_field.startswith(f"{self.table_name}."):
                    return cursor_field.split('.')[-1]

                # If it's another table name, then the table depends on another table
                # for cursor field. In this case retain the depends_on table name.
                # Change the dot to an underscore.
                return cursor_field.replace('.','_')
            # If cursor field is a list of fields then recursively return get_bq_cursor_field of each field in a list
            if isinstance(cursor_field, list):
                return [self.get_bq_cursor_field(i) for i in cursor_field]


        return NULL_CURSOR_FIELD





