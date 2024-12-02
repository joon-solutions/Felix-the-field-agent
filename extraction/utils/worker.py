
from abc import ABC, abstractmethod
import pandas as pd
import yaml
import os
from .enums import CSV_DUMP_DIR
import pandas as pd

class Worker(ABC):
    @abstractmethod
    def __init__(self,
                 table_name: str,
                 schema_file: str = 'schema.yaml',
                 *args, **kwargs) -> None:

        self.table_name = table_name
        self.total_record = 0
        self._load_schema(schema_file)
        self.table_data = self.schema_data[table_name]
        self.schema_info = self.table_data['schema']
        self.csv_target_path = os.path.join(CSV_DUMP_DIR,self.table_name)
        self.csv_name = os.path.join(self.csv_target_path,f"{self.table_name}.csv")

    def _load_schema(self,schema_file):
        with open(schema_file) as f:
            schema = yaml.safe_load(f)  # Load the schema from the file

        # Check and assign based on the condition
        if self.table_name in schema:
            self.schema_data = schema
        else:
            raise KeyError(f"Table {self.table_name} is not found in {schema_file} file.")

    @abstractmethod
    def fetch(self, **kwargs) -> dict | pd.DataFrame | str | None:
        """Fetch data (e.g., Looker API call)."""
        pass

    @abstractmethod
    def dump(self, **kwargs):
        """Save data locally (e.g., CSV file)."""
        pass

    def generate_summary_df(self) -> pd.DataFrame:
        """
        Generate a summary table for the fetch-dump iteration.
        """
        # Data points for the summary
        explore_name = self.explore_name
        table_name = self.table_name
        total_rows = self.total_record  # Total rows fetched in this iteration
        data_dir = self.csv_target_path  # Folder holding dumped files

        # Create a summary dictionary
        summary_data = {
            "Explore Name": [explore_name],
            "Table Name": [table_name],
            "Data Folder": [data_dir],
            "Total Rows": [total_rows],
        }

        # Convert to a Pandas DataFrame for tabular display
        summary_df = pd.DataFrame(summary_data)

        return summary_df