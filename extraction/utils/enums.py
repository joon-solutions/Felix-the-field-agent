from dotenv import load_dotenv
import os
load_dotenv()
BQ_PROJECT_ID = os.environ.get('BQ_PROJECT_ID')
BQ_DATASET_ID = os.environ.get('BQ_DATASET_ID')
CSV_DUMP_DIR = os.environ.get('CSV_DUMP_DIR','out')
START_TIME = os.environ.get('START_TIME',"2015-01-01 00:00:00")
LOOKER_REPO_PATH = os.environ.get('LOOKER_REPO_PATH', 'repo')
LOOKER_PROJECT_MAPPING_PATH = os.environ.get('LOOKER_PROJECT_MAPPING_PATH', "looker_project.json")

ROW_LIMIT = 50000
QUERY_TIMEZONE = 'UTC'
QUERY_TIMEOUT = 600
DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S'
IGNORE_FILES = ['README.lkml', 'manifest_lock.lkml']
JOINS_KEYS = {'type', 'sql_on', 'relationship', 'required_joins', 'name'                }
DEFAULT_TIMEFRAMES = ['date', 'day_of_month', 'day_of_week', 'day_of_week_index', 'day_of_year',
                'hour', 'hour_of_day', 'minute', 'month', 'month_name', 'month_num', 'quarter',
                'quarter_of_year', 'time', 'time_of_day', 'week', 'week_of_year', 'year']
DEFAULT_INTERVALS = ['day', 'hour', 'minute', 'month', 'quarter', 'second', 'week', 'year']
FOLDERS_TO_SKIP = ['99_Tests']




ID_CURSOR_FIELD = 'id'
NULL_CURSOR_FIELD = 'null_cursor_field'
START_ID = -1
CURSOR_FIELD_NOT_PICKED = "please_choose"
NULL_CURSOR_VALUE = "null_cursor_value"

