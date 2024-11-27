import pandas as pd
from google.cloud import bigquery
from utils.worker import Worker
import os
import csv



BQ_PROJECT_ID = os.environ.get('BQ_PROJECT_ID')
BQ_DATASET_ID = os.environ.get('BQ_DATASET_ID')


class BigQueryWorker(Worker):
    def __init__(
            self,
            explore_name: str,
            table_name: str,
            csv_file_path: str = 'out',
            **kwargs
    ) -> None:
        super().__init__(explore_name,table_name)
        self.bq_project_id = BQ_PROJECT_ID
        self.bq_dataset_id = BQ_DATASET_ID
        self.bq_table_id = self.table_name
        self.csv_file_path = csv_file_path
        self.client = bigquery.Client(project=self.bq_project_id)

    def fetch(self,**kwargs) -> None:
        """
        Reads data from the CSV and loads it into the specified BigQuery table.
        """
        print(f"Reading CSV data from {self.csv_file_path}...")
        df = pd.read_csv(self.csv_file_path)
        self.df = df
        


    def dump(self, **kwargs) -> None:   
        # https://cloud.google.com/python/docs/reference/bigquery/latest/google.cloud.bigquery.job.LoadJobConfig
        # Specify the fully qualified table ID (project_id.dataset_id.table_id)
        table_id = f"{self.bq_project_id}.{self.bq_dataset_id}.{self.bq_table_id}"

        # Configure job to load data
        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.CSV,
            skip_leading_rows=1,  # Skip header row in CSV
            autodetect=True,  # Automatically detect schema
            field_delimiter=',',
        )

        print(f"Loading data into BigQuery table: {table_id}")
        job = self.client.load_table_from_dataframe(
            self.df, table_id, job_config=job_config
        )

        # Wait for the load job to complete
        job.result()
        print(f"Data loaded successfully into {table_id}.")