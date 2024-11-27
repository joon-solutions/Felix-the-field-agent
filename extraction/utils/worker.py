
from abc import ABC, abstractmethod
import pandas as pd
import yaml


class Worker(ABC):
    @abstractmethod
    def __init__(self, 
                 explore_name: str,
                 table_name: str,
                 schema_file: str = 'schema.yaml', 
                 *args, **kwargs) -> None:
        self.explore_name = explore_name
        self.table_name = table_name
        with open(schema_file) as f:
            self.schema_data = yaml.safe_load(f)

    @abstractmethod
    def fetch(self, **kwargs) -> dict | pd.DataFrame | str | None:
        """Fetch data (e.g., Looker API call)."""
        pass

    @abstractmethod
    def dump(self, **kwargs):
        """Save data locally (e.g., CSV file)."""
        pass