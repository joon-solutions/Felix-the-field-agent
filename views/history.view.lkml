view: history {
  sql_table_name: `joon-sandbox.looker_hackathon.history` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: apply_formatting {
    type: yesno
    sql: ${TABLE}.apply_formatting ;;
  }
  dimension: apply_vis {
    type: yesno
    sql: ${TABLE}.apply_vis ;;
  }
  dimension: cache {
    type: yesno
    sql: ${TABLE}.cache ;;
  }
  dimension: cache_key {
    type: string
    sql: ${TABLE}.cache_key ;;
  }
  dimension: cache_only {
    type: yesno
    sql: ${TABLE}.cache_only ;;
  }
  dimension_group: completed {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.completed_time ;;
  }
  dimension: connection_id {
    type: string
    sql: ${TABLE}.connection_id ;;
  }
  dimension: connection_name {
    type: string
    sql: ${TABLE}.connection_name ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_time ;;
  }
  dimension: dashboard_id {
    type: string
    sql: ${TABLE}.dashboard_id ;;
  }
  dimension: dashboard_id_as_number {
    type: number
    value_format_name: id
    sql: ${TABLE}.dashboard_id_as_number ;;
  }
  dimension: dashboard_session {
    type: string
    sql: ${TABLE}.dashboard_session ;;
  }
  dimension: dialect {
    type: string
    sql: ${TABLE}.dialect ;;
  }
  dimension: force_production {
    type: yesno
    sql: ${TABLE}.force_production ;;
  }
  dimension: generate_links {
    type: yesno
    sql: ${TABLE}.generate_links ;;
  }
  dimension: is_single_query {
    type: yesno
    sql: ${TABLE}.is_single_query ;;
  }
  dimension: is_user_dashboard {
    type: yesno
    sql: ${TABLE}.is_user_dashboard ;;
  }
  dimension: issuer_source {
    type: string
    sql: ${TABLE}.issuer_source ;;
  }
  dimension: look_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.look_id ;;
  }
  dimension: message {
    type: string
    sql: ${TABLE}.message ;;
  }
  dimension: most_recent_length {
    type: number
    sql: ${TABLE}.most_recent_length ;;
  }
  dimension_group: most_recent_run_at {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.most_recent_run_at_time ;;
  }
  dimension: node_id {
    type: number
    sql: ${TABLE}.node_id ;;
  }
  dimension: query_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.query_id ;;
  }
  dimension: raw_source {
    type: string
    sql: ${TABLE}.raw_source ;;
  }
  dimension: real_dash_id {
    type: string
    sql: ${TABLE}.real_dash_id ;;
  }
  dimension: rebuild_pdts {
    type: yesno
    sql: ${TABLE}.rebuild_pdts ;;
  }
  dimension: render_key {
    type: string
    sql: ${TABLE}.render_key ;;
  }
  dimension: result_format {
    type: string
    sql: ${TABLE}.result_format ;;
  }
  dimension: result_maker_id {
    type: string
    sql: ${TABLE}.result_maker_id ;;
  }
  dimension: result_source {
    type: string
    sql: ${TABLE}.result_source ;;
  }
  dimension: runtime {
    type: number
    sql: ${TABLE}.runtime ;;
  }
  dimension: runtime_tiers {
    type: string
    sql: ${TABLE}.runtime_tiers ;;
  }
  dimension: runtime_tiers_1 {
    type: string
    sql: ${TABLE}.runtime_tiers_1 ;;
  }
  dimension: runtime_tiers_5 {
    type: string
    sql: ${TABLE}.runtime_tiers_5 ;;
  }
  dimension: runtime_under_10s {
    type: yesno
    sql: ${TABLE}.runtime_under_10s ;;
  }
  dimension: server_table_calcs {
    type: yesno
    sql: ${TABLE}.server_table_calcs ;;
  }
  dimension: slug {
    type: string
    sql: ${TABLE}.slug ;;
  }
  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }
  dimension: sql_query_id {
    type: number
    sql: ${TABLE}.sql_query_id ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: workspace_id {
    type: string
    sql: ${TABLE}.workspace_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
	id,
	connection_name,
	created_time,
	query.created_time,
	query.id,
	look.created_time,
	look.id,
	query_metrics.count
	]
  }

}
