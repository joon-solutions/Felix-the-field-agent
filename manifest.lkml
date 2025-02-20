project_name: "felix_the_field_agent"

################# Constants ################

## Used in google_analytics_block.model connection param
constant: CONNECTION_NAME {
  value: "felix_the_field_agent"
  export: override_required
}

## Used in ga_sessions.view sql_table_name whattttt
constant: SCHEMA_NAME {
  value: "demo.looker_felix_the_field_agent"
  export: override_required
}

## Used in ga_sessions.view sql_table_name
constant: LOOKER_HOST {
  value: "yourlookerhost"
  export: override_required
}
