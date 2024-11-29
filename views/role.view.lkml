view: role {
  sql_table_name: @{SCHEMA_NAME}.role ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: built_in {
    type: yesno
    sql: ${TABLE}.built_in ;;
  }
  dimension: edit_link {
    type: string
    sql: ${TABLE}.edit_link ;;
  }
  dimension: embed {
    type: yesno
    sql: ${TABLE}.embed ;;
  }
  dimension: has_role {
    type: yesno
    sql: ${TABLE}.has_role ;;
  }
  dimension: model_set_id {
    type: number
    sql: ${TABLE}.model_set_id ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: permission_set_id {
    type: number
    sql: ${TABLE}.permission_set_id ;;
  }
  measure: count {
    type: count
    drill_fields: [id, name, user_facts_role.count]
  }
}
