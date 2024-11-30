
from abc import ABC, abstractmethod
import pandas as pd
import yaml
import os
from utils.enums import CSV_DUMP_DIR


class Worker(ABC):
    @abstractmethod
    def __init__(self, 
                 explore_name: str,
                 table_name: str,
                 schema_file: str = 'schema.yaml', 
                 *args, **kwargs) -> None:

        self.explore_name = explore_name
        self.table_name = table_name
        self._load_schema(schema_file)
        self.table_data = self.schema_data[explore_name][table_name] if not self._dependent_yaml else self.schema_data[table_name]
        self.schema_info = self.table_data['schema']
        self.csv_target_path = os.path.join(CSV_DUMP_DIR,self.explore_name + '__' + self.table_name)
        self.csv_name = os.path.join(self.csv_target_path,f"{self.table_name}.csv")

    def _load_schema(self,schema_file):
        with open(schema_file) as f:
            schema = yaml.safe_load(f)  # Load the schema from the file

        with open('dependent_schema.yaml') as f_dep:
            dependent_schema = yaml.safe_load(f_dep)  # Load the dependent schema

        # Check and assign based on the condition
        if self.explore_name in schema:
            self.schema_data = schema
            self._dependent_yaml = False
        else:
            self.schema_data = dependent_schema
            self._dependent_yaml = True        
    
    @abstractmethod
    def fetch(self, **kwargs) -> dict | pd.DataFrame | str | None:
        """Fetch data (e.g., Looker API call)."""
        pass

    @abstractmethod
    def dump(self, **kwargs):
        """Save data locally (e.g., CSV file)."""
        pass