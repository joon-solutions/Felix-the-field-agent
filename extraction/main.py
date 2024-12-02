import argparse
import os
import shutil
import pandas as pd

from utils.looker_worker import  LookerWorker
from utils.bigquery_worker import  BigQueryWorker
from utils.enums import  CSV_DUMP_DIR, LOOKER_PROJECT_MAPPING_PATH

hardcoded_list = [
                  'user',
                  'user_facts',
                  'user_facts_role',
                  'role',
                  'group_user',
                  'group',
                  'dashboard',
                  'look',
                  'explore_label',
                  'history',
                  'query',
                  'lookml_fields',
                  'query_metrics'
                 ]


parser = argparse.ArgumentParser(
                    prog='thetool_extractor',
                    description='This script helps you extract data from looker system activity.'
                    )

parser.add_argument('-e', '--explore', help='system activity explore name')
parser.add_argument('-t', '--table', help='table name from the explore')
parser.add_argument('-m', '--mapping-file', help='Path to Looker project mapping JSON file.')
parser.add_argument('-a', '--all', help='loads all required tables', action='store_true')
parser.add_argument('-f', '--full-refresh', help='drops table before reload', action='store_true')

args = parser.parse_args()


if __name__ == "__main__":
    # clear the output path
    for filename in os.listdir(CSV_DUMP_DIR):
        file_path = os.path.join(CSV_DUMP_DIR, filename)
        if os.path.isfile(file_path):
            os.remove(file_path)
        elif os.path.isdir(file_path):
            shutil.rmtree(file_path)

    if args.all:
        report = pd.DataFrame()
        for table_name in hardcoded_list:
            print("=" * 30 + '\n\n' +
                f"Start extracting {table_name} table" + '\n\n' +
                "=" * 30
                )
            table = table_name
            project_mapping_path = args.mapping_file if args.mapping_file else LOOKER_PROJECT_MAPPING_PATH
            try:
                looker_worker = LookerWorker(table_name = table)
                if table == 'lookml_fields':
                    looker_worker.set_project_mapping(project_mapping_path)
                looker_worker.fetch()
                looker_worker.dump()
                bq_worker = BigQueryWorker(explore,table)
                bq_worker.fetch()
                bq_worker.dump()
                job = bq_worker.generate_summary_df()
                report = pd.concat([job,report], ignore_index=True)
            except Exception as e:
                print(e)
                print(f"Error while extracting {table_name} table")
                continue
    else:
        explore = args.explore
        table = args.table
        looker_worker = LookerWorker(explore,table)
        looker_worker.fetch()
        looker_worker.dump()

        bq_worker = BigQueryWorker(explore,table)
        bq_worker.fetch()
        bq_worker.dump()
        report = bq_worker.generate_summary_df()

    print("\n\n\tFinished running scripts with report below:\n\n\t")
    print(report.to_markdown(index=False))