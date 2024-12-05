project_name: "felix_the_field_agent"

################# Constants ################

## Used in google_analytics_block.model connection param
constant: CONNECTION_NAME {
  value: "lookerdata"
  export: override_required
}

## Used in ga_sessions.view sql_table_name whattttt
constant: SCHEMA_NAME {
  value: "joon-sandbox.looker_hackathon_2024"
  export: override_required
}

## Used in ga_sessions.view sql_table_name
constant: LOOKER_HOST {
  value: "joonpartner"
  export: override_required
}
