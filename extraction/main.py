import argparse
from utils.looker_worker import  LookerWorker
from utils.bigquery_worker import  BigQueryWorker
import pandas as pd

# these needs to be handled by batch
# history
# query
# ,'query_metrics']


# these not found ?
# ,'user_email' <<< this not found ??
# template : {explore : table}
# ,'user_attribute'

hardcoded_list = [{'user': 'user'}
                    ,{'user': 'user_facts'}
                    ,{'user': 'user_facts_role'}
                    ,{'role': 'role'}
                    ,{'group': 'group_user'}
                    ,{'group': 'group'}
                    ,{'dashboard': 'dashboard'}
                    ,{'look': 'look'}
                    ,{'explore_label': 'explore_label'}
                    ,{'history': 'history'}
                    ,{'query': 'query'}
                    ,{'query_metrics': 'query_metrics'}
                ]


parser = argparse.ArgumentParser(
                    prog='thetool_extractor',
                    description='This script helps you extract data from looker system activity.'
                    )

parser.add_argument('-e', '--explore', help='system activity explore name')
parser.add_argument('-t', '--table', help='table name from the explore')
parser.add_argument('-a', '--all', help='loads all required tables', action='store_true')
parser.add_argument('-f', '--full-refresh', help='drops table before reload', action='store_true')

args = parser.parse_args()


if __name__ == "__main__":
    if args.all:
        report = pd.DataFrame()
        for item in hardcoded_list:
            for explore_name,table_name in item.items():
                print("=" * 30 + '\n\n' +
                    f"start loading for explore: {explore_name} table: {table_name}" + '\n\n' +
                    "=" * 30
                    )
                explore = explore_name
                table = table_name
                try:
                    looker_worker = LookerWorker(explore,table)
                    looker_worker.fetch()
                    looker_worker.dump()
                    bq_worker = BigQueryWorker(explore,table)
                    bq_worker.fetch()
                    bq_worker.dump()
                    job = bq_worker.generate_summary_df()
                    report = pd.concat([job,report], ignore_index=True)
                except Exception as e:
                    print(e)
                    print(f"Error loading for explore: {explore_name} table: {table_name}")
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