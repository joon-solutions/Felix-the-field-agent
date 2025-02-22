view: explore_label {
  sql_table_name: @{GCP_PROJECT}.@{DATASET}.explore_label ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: explore_description {
    type: string
    sql: ${TABLE}.explore_description ;;
  }
  dimension: explore_group_label {
    type: string
    sql: ${TABLE}.explore_group_label ;;
  }
  dimension: explore_label {
    type: string
    sql: ${TABLE}.explore_label ;;
  }
  dimension: explore_name {
    type: string
    sql: ${TABLE}.explore_name ;;
  }
  dimension: is_explore_hidden {
    type: yesno
    sql: ${TABLE}.is_explore_hidden ;;
  }
  dimension: model_allowed_db_connection_names {
    type: string
    sql: ${TABLE}.model_allowed_db_connection_names ;;
  }
  dimension: model_has_content {
    type: yesno
    sql: ${TABLE}.model_has_content ;;
  }
  dimension: model_label {
    type: string
    sql: ${TABLE}.model_label ;;
  }
  dimension: model_name {
    type: string
    sql: ${TABLE}.model_name ;;
  }
  dimension: model_unlimited_db_connections {
    type: yesno
    sql: ${TABLE}.model_unlimited_db_connections ;;
  }
  dimension: project_name {
    type: string
    sql: ${TABLE}.project_name ;;
  }
  measure: count {
    type: count
    drill_fields: [id, model_name, project_name, explore_name]
  }
}
