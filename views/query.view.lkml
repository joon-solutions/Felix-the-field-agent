view: query {
  sql_table_name: @{SCHEMA_NAME}.query ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: column_limit {
    type: string
    sql: ${TABLE}.column_limit ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_time ;;
  }
  dimension: dynamic_fields {
    type: string
    sql: ${TABLE}.dynamic_fields ;;
  }
  dimension: field_or_filter_contains {
    type: yesno
    sql: ${TABLE}.field_or_filter_contains ;;
  }
  dimension: fields {
    type: string
    sql: ${TABLE}.fields ;;
  }
  dimension: fill_fields {
    type: string
    sql: ${TABLE}.fill_fields ;;
  }
  dimension: filters {
    type: string
    sql: ${TABLE}.filters ;;
  }
  dimension: formatted_fields {
    type: string
    sql: ${TABLE}.formatted_fields ;;
  }
  dimension: formatted_pivots {
    type: string
    sql: ${TABLE}.formatted_pivots ;;
  }
  dimension: hash {
    type: string
    sql: ${TABLE}.`hash` ;;
  }
  dimension: limit {
    type: number
    sql: ${TABLE}.`limit` ;;
  }
  dimension: link {
    type: string
    sql: ${TABLE}.link ;;
  }
  dimension: model {
    type: string
    sql: ${TABLE}.model ;;
  }
  dimension: pivots {
    type: string
    sql: ${TABLE}.pivots ;;
  }
  dimension: query_timezone {
    type: string
    sql: ${TABLE}.query_timezone ;;
  }
  dimension: row_total {
    type: string
    sql: ${TABLE}.row_total ;;
  }
  dimension: row_totals {
    type: yesno
    sql: ${TABLE}.row_totals ;;
  }
  dimension: slug {
    type: string
    sql: ${TABLE}.slug ;;
  }
  dimension: sorts {
    type: string
    sql: ${TABLE}.sorts ;;
  }
  dimension: total {
    type: yesno
    sql: ${TABLE}.total ;;
  }
  dimension: view {
    type: string
    sql: ${TABLE}.view ;;
  }
  dimension: vis_config {
    type: string
    sql: ${TABLE}.vis_config ;;
  }
  dimension: visible_ui_sections {
    type: string
    sql: ${TABLE}.visible_ui_sections ;;
  }
  measure: count {
    type: count
    drill_fields: [id, created_time, history.count, look.count]
  }
}
