view: group {
  sql_table_name: @{SCHEMA_NAME}.group ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: can_add_to_content_metadata {
    type: yesno
    sql: ${TABLE}.can_add_to_content_metadata ;;
  }
  dimension: edit_link {
    type: string
    sql: ${TABLE}.edit_link ;;
  }
  dimension: external_group_id {
    type: string
    sql: ${TABLE}.external_group_id ;;
  }
  dimension: externally_managed {
    type: yesno
    sql: ${TABLE}.externally_managed ;;
  }
  dimension: include_by_default {
    type: yesno
    sql: ${TABLE}.include_by_default ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  measure: count {
    type: count
    drill_fields: [id, name, group_user.count]
  }
}
