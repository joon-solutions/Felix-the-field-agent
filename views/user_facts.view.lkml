view: user_facts {
  sql_table_name: @{GCP_PROJECT}.@{DATASET}.user_facts ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: active_api_sessions {
    type: number
    sql: ${TABLE}.active_api_sessions ;;
  }
  dimension: active_ui_sessions {
    type: number
    sql: ${TABLE}.active_ui_sessions ;;
  }
  dimension: external_id {
    type: string
    sql: ${TABLE}.external_id ;;
  }
  dimension: has_api_credentials {
    type: yesno
    sql: ${TABLE}.has_api_credentials ;;
  }
  dimension: has_ui_credentials {
    type: yesno
    sql: ${TABLE}.has_ui_credentials ;;
  }
  dimension: is_admin {
    type: yesno
    sql: ${TABLE}.is_admin ;;
  }
  dimension: is_content_saver {
    type: yesno
    sql: ${TABLE}.is_content_saver ;;
  }
  dimension: is_developer {
    type: yesno
    sql: ${TABLE}.is_developer ;;
  }
  dimension: is_embed {
    type: yesno
    sql: ${TABLE}.is_embed ;;
  }
  dimension: is_explorer {
    type: yesno
    sql: ${TABLE}.is_explorer ;;
  }
  dimension: is_looker_employee {
    type: yesno
    sql: ${TABLE}.is_looker_employee ;;
  }
  dimension: is_presumed_looker_employee {
    type: yesno
    sql: ${TABLE}.is_presumed_looker_employee ;;
  }
  dimension: is_sql_runner {
    type: yesno
    sql: ${TABLE}.is_sql_runner ;;
  }
  dimension: is_verified_looker_employee {
    type: yesno
    sql: ${TABLE}.is_verified_looker_employee ;;
  }
  dimension: is_viewer {
    type: yesno
    sql: ${TABLE}.is_viewer ;;
  }
  dimension_group: last_api_login {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.last_api_login_time ;;
  }
  dimension: last_ui_login_credential_type {
    type: string
    sql: ${TABLE}.last_ui_login_credential_type ;;
  }
  dimension_group: last_ui_login {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.last_ui_login_time ;;
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  user.created_time,
  user.dev_branch_name,
  user.name,
  user.last_name,
  user.id,
  user.first_name
  ]
  }

}
