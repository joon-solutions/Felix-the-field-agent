
import looker_sdk
from datetime import datetime
from looker_sdk.sdk.api40 import methods as methods40
from looker_sdk import models40 as models 
import time
from dotenv import load_dotenv
import os


load_dotenv()

ROW_LIMIT = int(os.environ.get('ROW_LIMIT',50000))
QUERY_TIMEZONE = os.environ.get('QUERY_TIMEZONE','UTC')
QUERY_TIMEOUT = int(os.environ.get('QUERY_TIMEOUT',600))
DATETIME_FORMAT = os.environ.get('DATETIME_FORMAT','%Y-%m-%d %H:%M:%S')
START_TIME = os.environ.get('START_TIME',"2015-01-01 00:00:00")

class Extractor():
    def __init__(
            self,
            table_name: str,
            table_data: dict,

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
        self.sdk = looker_sdk.init40()
        self.table_name = table_name
        self.table_data = table_data
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
        self.cursor_field: str = self.table_data["cursor_field"] or (self.table_data["primary_key"] if not isinstance(self.table_data["primary_key"], list) else self.table_data["batch_cursor_field"])  # Cursor field in Looker query
        print(f"{self.cursor_field}")
        self.is_id_cursor_field = False

        


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
        filters.update(self.table_data['filters'] if self.table_data['filters'] else {})
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
        print(f"Successfully created query, query_id is [{query_id}]")
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

        print(f"Created async query task id [{query_task_id}] for query id [{query_id}]")

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

