project_name: "felix_the_field_agent"

################# Constants ################

## Used in google_analytics_block.model connection param
constant: CONNECTION_NAME {
  value: "felix_BQ_dataset"
  export: override_required
}

constant: GCP_PROJECT {
  value: "your_GCP_project"
  export: override_required
}
constant: DATASET {
  value: "felix_the_field_agent"
  export: override_required
}

constant: LOOKER_HOST {
  value: "your_looker_host"
  export: override_required
}
