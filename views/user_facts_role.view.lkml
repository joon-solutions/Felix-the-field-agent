view: user_facts_role {
  sql_table_name: @{GCP_PROJECT}.@{DATASET}.user_facts_role ;;

  dimension: role_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.role_id ;;
  }
  dimension_group: user_created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.user_created_time ;;
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
  user_created_time,
  user.created_time,
  user.dev_branch_name,
  user.name,
  user.last_name,
  user.id,
  user.first_name,
  role.name,
  role.id
  ]
  }

}
