from dotenv import load_dotenv
import os
load_dotenv()

ROW_LIMIT = int(os.environ.get('ROW_LIMIT',50000))
QUERY_TIMEZONE = os.environ.get('QUERY_TIMEZONE','UTC')
QUERY_TIMEOUT = int(os.environ.get('QUERY_TIMEOUT',600))
DATETIME_FORMAT = os.environ.get('DATETIME_FORMAT','%Y-%m-%d %H:%M:%S')
START_TIME = os.environ.get('START_TIME',"2015-01-01 00:00:00")
CSV_DUMP_DIR = os.environ.get('CSV_DUMP_DIR','out')




BQ_PROJECT_ID = os.environ.get('BQ_PROJECT_ID')
BQ_DATASET_ID = os.environ.get('BQ_DATASET_ID')

ID_CURSOR_FIELD = os.environ.get('ID_CURSOR_FIELD','id')
NULL_CURSOR_FIELD = os.environ.get('NULL_CURSOR_FIELD','null_cursor_field')