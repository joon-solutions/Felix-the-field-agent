view: look {
  sql_table_name: @{GCP_PROJECT}.@{DATASET}.look ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
  dimension: is_run_on_load {
    type: yesno
    sql: ${TABLE}.is_run_on_load ;;
  }
  dimension: last_updater_id {
    type: number
    sql: ${TABLE}.last_updater_id ;;
  }
  dimension: link {
    type: string
    sql: ${TABLE}.id ;;
    link:{
      label:"Go to Looker Look"
      url:"https://@{LOOKER_HOST}.cloud.looker.com/looks/{{value}}"}
  }
  dimension: moved_to_trash {
    type: yesno
    sql: ${TABLE}.moved_to_trash ;;
  }
  dimension: public {
    type: yesno
    sql: ${TABLE}.public ;;
  }
  dimension: public_embed_link {
    type: string
    sql: ${TABLE}.public_embed_link ;;
  }
  dimension: public_slug {
    type: string
    sql: ${TABLE}.public_slug ;;
  }
  dimension: query_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.query_id ;;
  }
  dimension: space_id {
    type: number
    sql: ${TABLE}.space_id ;;
  }
  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_time ;;
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [id, created_time, query.created_time, query.id, history.count]
  }
}
