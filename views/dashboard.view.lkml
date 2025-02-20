view: dashboard {
  sql_table_name: @{GCP_PROJECT}.@{DATASET}.dashboard ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: background_color {
    type: string
    sql: ${TABLE}.background_color ;;
  }
  dimension: content_metadata_id {
    type: number
    sql: ${TABLE}.content_metadata_id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_time ;;
  }
  dimension_group: deleted {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.deleted_time ;;
  }
  dimension: deleter_id {
    type: number
    sql: ${TABLE}.deleter_id ;;
  }
  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }
  dimension: hidden {
    type: yesno
    sql: ${TABLE}.hidden ;;
  }
  dimension: is_legacy {
    type: yesno
    sql: ${TABLE}.is_legacy ;;
  }
  dimension: last_updater_id {
    type: number
    sql: ${TABLE}.last_updater_id ;;
  }
  dimension: link {
    type: string
    sql: ${TABLE}.id ;;
    link:{
      label:"Go to Looker Dashboard"
      url:"https://@{LOOKER_HOST}.cloud.looker.com/dashboards/{{value}}"}
  }
  dimension: load_configuration {
    type: string
    sql: ${TABLE}.load_configuration ;;
  }
  dimension: lookml_link_id {
    type: string
    sql: ${TABLE}.lookml_link_id ;;
  }
  dimension: moved_to_trash {
    type: yesno
    sql: ${TABLE}.moved_to_trash ;;
  }
  dimension: preferred_viewer {
    type: string
    sql: ${TABLE}.preferred_viewer ;;
  }
  dimension: query_timezone {
    type: string
    sql: ${TABLE}.query_timezone ;;
  }
  dimension: refresh_interval {
    type: string
    sql: ${TABLE}.refresh_interval ;;
  }
  dimension: refresh_interval_ordered {
    type: number
    sql: ${TABLE}.refresh_interval_ordered ;;
  }
  dimension: run_on_load {
    type: yesno
    sql: ${TABLE}.run_on_load ;;
  }
  dimension: show_filters_bar {
    type: yesno
    sql: ${TABLE}.show_filters_bar ;;
  }
  dimension: show_tile_shadow {
    type: yesno
    sql: ${TABLE}.show_tile_shadow ;;
  }
  dimension: show_title {
    type: yesno
    sql: ${TABLE}.show_title ;;
  }
  dimension: space_id {
    type: number
    sql: ${TABLE}.space_id ;;
  }
  dimension: text_tile_text_color {
    type: string
    sql: ${TABLE}.text_tile_text_color ;;
  }
  dimension: tile_background_color {
    type: string
    sql: ${TABLE}.tile_background_color ;;
  }
  dimension: tile_border_radius {
    type: number
    sql: ${TABLE}.tile_border_radius ;;
  }
  dimension: tile_separator_color {
    type: string
    sql: ${TABLE}.tile_separator_color ;;
  }
  dimension: tile_text_color {
    type: string
    sql: ${TABLE}.tile_text_color ;;
  }
  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }
  dimension: title_color {
    type: string
    sql: ${TABLE}.title_color ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_time ;;
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
  created_time,
  user.created_time,
  user.dev_branch_name,
  user.name,
  user.last_name,
  user.id,
  user.first_name
  ]
  }

}
