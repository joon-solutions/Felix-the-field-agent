import looker_sdk
import time
import os
import pandas as pd
import csv
import hashlib
import warnings
import json


from looker_sdk.sdk.api40 import methods as methods40
from looker_sdk import models40 as models
from .worker import Worker
from io import StringIO
from .enums import (ROW_LIMIT,
                         QUERY_TIMEZONE,
                         QUERY_TIMEOUT,
                         DATETIME_FORMAT,
                         START_TIME,
                         ID_CURSOR_FIELD,
                         START_ID,
                         LOOKER_REPO_PATH
                         )
from .lookml_repo import LookerRepo



class LookerWorker(Worker):
    def __init__(
            self,
            table_name:str
            ) -> None:
        super().__init__(table_name = table_name)
        self.sdk = looker_sdk.init40()
        self.start_time: str | int | None = START_TIME
        self.project_mapping = None
        self.row_limit = ROW_LIMIT
        self.query_timezone= QUERY_TIMEZONE
        self.datetime_format= DATETIME_FORMAT
        self.row_count = self._fetch_rowcount()
        if self.row_count:
            self.cursor_field: str = self.table_data["cursor_field"] or (self.table_data["primary_key"] if not isinstance(self.table_data["primary_key"], list) else self.table_data["batch_cursor_field"])  # Cursor field in Looker query
            self.is_id_cursor_field = False
            if self.cursor_field and (self.cursor_field == ID_CURSOR_FIELD or self.cursor_field.split(".")[1] == ID_CURSOR_FIELD):
                print(f"Cursor field is {self.cursor_field}.")
                self.is_id_cursor_field = True
                # cursor field is id; assigns int type
                self.start_time = START_ID
            self.cursor_value = None
            self.is_last_batch = None
        self.file_num = -1

    def set_project_mapping(self, project_mapping_path: str):
        with open(project_mapping_path, "r") as f:
            project_mapping = json.load(f)
        self.project_mapping = project_mapping

    def _fetch_rowcount(self) -> int | None:
        """
        executes a rowcount query on the target view's count_measure.
        this self.row_count is the core logic of doing a full or batch extraction.
        """
        try:
            # limitation : not all systerm activity has a count_measure.
            # thus we only do rowcount on views with such attr.
            # all worker instances with row_count are set for batch extraction.
            count_measure = self.table_data["count_measure"]
            view = self.table_data["view"]
            model = self.table_data["model"]

            body = models.WriteQuery(
                            model = model,
                            view = view,
                            fields = [count_measure],
                            )

            print(f'fetching rowcount for {model}.{view} : ')
            query = self.sdk.create_query(
                body = body
            )
            query_id = query.id
            if not query_id:
                raise ValueError(f"Failed to create query for view [{view}]")
            print(f"""Successfully created query, query_id is [{query_id}]
                query url: {query.share_url}"""
                )
            row_count = self.run_query(query_id)
            row_count = int(row_count.split('\n')[1])
            return row_count
        except KeyError:
            # catches the error & assigns None row_count to the worker.
            # all worker instances without row_count are set for full extraction.

            return None


    def create_query(
            self,
            table_data,
            start_time: str | int | None,
            ) -> str:
        """
        Create Looker Query
        Ref: https://developers.looker.com/api/explorer/4.0/methods/Query/create_query?sdk=py
        """
        model = table_data["model"]
        view = table_data["view"]
        fields = table_data["fields"]

        if self.row_count:
            cursor_field = self.cursor_field

            sorts = []
            print(f"Extracting in incremental mode for view [{view}].")
            sorts = [cursor_field] if cursor_field else []
            if not self.is_id_cursor_field:
                filters = {cursor_field: f"after {start_time}"} if cursor_field else {}
            else:
                filters = {cursor_field: f">= {start_time}"} if cursor_field else {}
            filters.update(self.table_data['filters'] if self.table_data['filters'] else {})
            # print(
            #     f"Creating query on view [{view}], filters {filters}, cursor_field {cursor_field},"
            #     f" timezone [{self.query_timezone}]"
            #     f" fields [{fields}]"
            #     )

            body = models.WriteQuery(
                    model = model,
                    view = view,
                    fields = fields,
                    filters = filters,
                    sorts = sorts,
                    limit = str(self.row_limit),
                    query_timezone = self.query_timezone,
                    )
        else:
            print(f"Extracting in full mode for view [{view}].")
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

# TODO @minh check this part out - remove the filter for looker repo (i.e. we need ALL the data)
    def fetch(self, **kwargs):
        if self.table_name == 'explore_label': # explore_label use a different API to extract from Looker
            self.get_explore_label()
            self.df = self.get_explore_label()
        elif self.table_name == 'lookml_fields':
            if self.project_mapping:
                looker_repo = LookerRepo(LOOKER_REPO_PATH, self.project_mapping)
                self.df = looker_repo.run()
            else:
                raise ValueError(f"""Extracting {self.table_name} without project mapping file.
                                 Please make a copy of looker_project.json and fill in the
                                 mappings of your LookML project(s).
                                 """)
        else:
            query_id = self.create_query(self.table_data,
                    self.start_time,
                    )

            query_results = self.run_query(query_id)
            self.query_results = query_results
            self.df = pd.read_csv(StringIO(query_results))

        self.map_fields_name_with_config()

        if self.row_count:
            # grab the cursor val for batch extraction
            self.last_cursor_value = self.cursor_value if hasattr(self, 'cursor_value') else None
            self.cursor_value = self.df[self.cursor_field.split('.')[-1]].iloc[-1]
        elif not self.row_count and len(self.df) == 50000:
            warnings.warn(f"\n\n\tWARNING : this view [{self.table_name}] has more than 50000 rows "
                  "but there's no fields we can reliably use "
                  "as a cursor for batch extraction.\n"
                  "\tThis view will be truncated to 50000 rows.\n\n",
                  category=UserWarning
                  )




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
        table = self.table_name

        if self.row_count:
            self.start_time = self.cursor_value
            self.file_num += 1
            if self.file_num == 0:
                self.csv_basename = self.csv_name.split('.')[0]
            self.csv_name = self.csv_basename + f"_{self.file_num}.csv"
            # last batch : kills the cursor
            if self.is_last_batch:
                self.row_count = None

        # create the dir
        if not os.path.exists(self.csv_target_path):
            os.makedirs(self.csv_target_path,exist_ok=True)

        self.df.to_csv(self.csv_name,
                index=False,
                quotechar='"',
                quoting=csv.QUOTE_MINIMAL,
                )
        print(f"sucessfully extracted explore table '{table}'. \n"
            f"total rows extracted: {len(self.df)}. \n"
            f"output file: '{self.csv_name}' \n"
            )
        self.total_record += len(self.df)

        if self.row_count:
            self.fetch()
            if self.last_cursor_value != self.cursor_value:
                if len(self.df) < self.row_limit:
                    self.is_last_batch = True
                self.dump()



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
