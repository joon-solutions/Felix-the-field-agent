import argparse
from utils.looker_worker import  LookerWorker
from utils.bigquery_worker import  BigQueryWorker



parser = argparse.ArgumentParser(
                    prog='thetool_extractor',
                    description='This script helps you extract data from looker system activity.'
                    )

parser.add_argument('-e', '--explore', help='system activity explore name')
parser.add_argument('-t', '--table', help='table name from the explore')

args = parser.parse_args()


if __name__ == "__main__":
    explore = args.explore
    table = args.table
    lw = LookerWorker(explore,table)
    lw.fetch()
    lw.dump()

    bqw = BigQueryWorker(explore,table,'out/explore_user__table_user.csv')
    bqw.fetch()
    bqw.dump()