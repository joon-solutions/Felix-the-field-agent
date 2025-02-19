project_name: "@{PROJECT_NAME}"

################# Constants ################

## Used in google_analytics_block.model connection param
constant: CONNECTION_NAME {
  value: "@{CONNECTION_NAME}"
  export: override_required
}

## Used in ga_sessions.view sql_table_name whattttt
constant: SCHEMA_NAME {
  value: "@{SCHEMA_NAME}"
  export: override_required
}

## Used in ga_sessions.view sql_table_name
constant: LOOKER_HOST {
  value: "@{LOOKER_HOST}"
  export: override_required
}
