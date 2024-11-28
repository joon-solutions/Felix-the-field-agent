import argparse
from utils.looker_worker import  LookerWorker
from utils.bigquery_worker import  BigQueryWorker

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

args = parser.parse_args()


if __name__ == "__main__":
    if args.all:
        for item in hardcoded_list:
            for k,v in item.items():
                print("=" * 30 + '\n\n' +
                    f"start loading for explore: {k} table: {v}" + '\n\n' + 
                    "=" * 30
                    )
                explore = k
                table = v
                try: 
                    lw = LookerWorker(explore,table)
                    lw.fetch()
                    lw.dump()
                    bqw = BigQueryWorker(explore,table)
                    bqw.fetch()
                    bqw.dump()
                except Exception as e:
                    print(e)
                    print(f"Error loading for explore: {k} table: {v}")
                    continue
    else:
        explore = args.explore
        table = args.table
        lw = LookerWorker(explore,table)
        lw.fetch()
        lw.dump()

        bqw = BigQueryWorker(explore,table)
        bqw.fetch()
        bqw.dump()