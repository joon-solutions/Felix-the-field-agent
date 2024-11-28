connection: "joon-sandbox"

# include all the views
include: "/refined/*.refined.view"
include: "/staging/*.view"
include: "/derived_tables/*.derived.view"

datagroup: looker_hackathon_2024_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_hackathon_2024_default_datagroup
