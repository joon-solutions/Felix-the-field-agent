view: group_user {
  sql_table_name: @{SCHEMA_NAME}.group_user ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: from_group_id {
    type: number
    sql: ${TABLE}.from_group_id ;;
  }
  dimension: group_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.group_id ;;
  }
  dimension: is_direct_group {
    type: yesno
    sql: ${TABLE}.is_direct_group ;;
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
  id,
  user_created_time,
  group.name,
  group.id,
  user.created_time,
  user.dev_branch_name,
  user.name,
  user.last_name,
  user.id,
  user.first_name
  ]
  }

}
