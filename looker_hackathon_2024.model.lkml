connection: "joon-sandbox"

# include all the views
include: "/views/refined/*.refined.view"
include: "/views/*.view"
include: "/views/derived_tables/*.derived.view"
include: "/explores/*.explore.lkml"

datagroup: looker_hackathon_2024_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_hackathon_2024_default_datagroup

label: "Looker Hackathon 2024"
