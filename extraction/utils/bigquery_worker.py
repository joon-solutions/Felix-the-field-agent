import pandas as pd
from google.cloud import bigquery
from utils.worker import Worker
import os
import csv
from utils.enums import BQ_PROJECT_ID,BQ_DATASET_ID 



class BigQueryWorker(Worker):
    def __init__(
            self,
            explore_name: str,
            table_name: str,
            full_refresh: bool = False,
            **kwargs
    ) -> None:
        super().__init__(explore_name,table_name)
        self.bq_project_id = BQ_PROJECT_ID
        self.bq_dataset_id = BQ_DATASET_ID
        self.bq_table_id = self.table_name
        self.bq_schema = []
        self.client = bigquery.Client(project=self.bq_project_id)
        self.is_last_batch = None
        self.files = os.listdir(self.csv_target_path)


    def fetch(self,**kwargs) -> None:
        """
        Reads data from the CSV and loads it into the specified BigQuery table.
        """
        if len(self.files) == 1:
            self.is_last_batch = True
        if len(self.files) >= 1:
            csv_file = self.files.pop()
            self.csv_name = os.path.join(self.csv_target_path,csv_file)
            df = pd.read_csv(self.csv_name)
            self.df = df
        

    def parse_column_types(self):
        for column in self.schema_info:
            field_name = column['name']
            field_type = column['type']
            field_description = column['description']
            self.bq_schema.append(bigquery.SchemaField(name=field_name, 
                                                       field_type=field_type, 
                                                       description=field_description,
                                                       mode='NULLABLE'))



    def dump(self, **kwargs) -> None:   
        # https://cloud.google.com/python/docs/reference/bigquery/latest/google.cloud.bigquery.job.LoadJobConfig
        # Specify the fully qualified table ID (project_id.dataset_id.table_id)
        
        table_id = f"{self.bq_project_id}.{self.bq_dataset_id}.{self.bq_table_id}"
        self.parse_column_types()

        # Configure job to load data
        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.CSV,
            skip_leading_rows=1,  # Skip header row in CSV
            field_delimiter=',',
            schema=self.bq_schema,
            write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
            allow_quoted_newlines=True
        )

        print(f"Loading data into BigQuery table: {table_id}, filename {self.csv_name}")
        job = self.client.load_table_from_dataframe(
            self.df, table_id, job_config=job_config
        )

        # Wait for the load job to complete
        job.result()
        print(f"Data loaded successfully into {table_id}.")
        if not self.is_last_batch:
            self.fetch()
            self.dump()
        elif self.is_last_batch:
            print(f"Loaded all files for {table_id}.")
    
    def full_refresh(self,table_id):
    # Delete the table
        try:
            self.client.delete_table(table_id)  # Deletes the table
            print(f"Table {table_id} has been deleted.")
        except Exception as e:
            print(f"An error occurred while deleting the table {table_id}: {e}")

