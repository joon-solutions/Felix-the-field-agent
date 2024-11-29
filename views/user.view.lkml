view: user {
  sql_table_name: @{SCHEMA_NAME}.user ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_time ;;
  }
  dimension: dev_branch_name {
    type: string
    sql: ${TABLE}.dev_branch_name ;;
  }
  dimension: edit_link {
    type: string
    sql: ${TABLE}.edit_link ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: external_avatar_url {
    type: string
    sql: ${TABLE}.external_avatar_url ;;
  }
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }
  dimension: home_space_id {
    type: string
    sql: ${TABLE}.home_space_id ;;
  }
  dimension: is_disabled {
    type: yesno
    sql: ${TABLE}.is_disabled ;;
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  created_time,
  dev_branch_name,
  name,
  last_name,
  first_name,
  user_facts.count,
  group_user.count,
  user_facts_role.count
  ]
  }

}
