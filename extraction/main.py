import yaml
import argparse
from utils.extractor import  Extractor
from io import StringIO
import pandas as pd
import csv



with open('schema.yaml') as f:
    schema_data = yaml.safe_load(f)


parser = argparse.ArgumentParser(
                    prog='thetool_extractor',
                    description='This script helps you extract data from looker system activity.'
                    )

parser.add_argument('-e', '--explore', help='system activity explore name')
parser.add_argument('-t', '--table', help='table name from the explore')

args = parser.parse_args()

def main(explore: str,table: str) -> None:    
    table_data = schema_data[explore][table]
    extractor = Extractor(
            table_data = table_data,
            table_name = table_data['view']
    )
    query_id = extractor.create_query(extractor.table_data, 
                           extractor.start_time,
                           )
    query_results = extractor.run_query(query_id)

    out = StringIO(query_results)
    df = pd.read_csv(out)
    df.to_csv(f'out/explore_{explore}__table_{table}.csv', 
              index=False,
              quotechar='"',
              quoting=csv.QUOTE_MINIMAL,
              )
    print(f'sucessfully extracted explore "{explore}" table "{table}". \n'
          f'total rows extracted: {len(df)}. \n'
          f'output file: "explore_{explore}__table_{table}.csv" \n'
          )
    

    



if __name__ == "__main__":
    explore = args.explore
    table = args.table
    main(explore, table)