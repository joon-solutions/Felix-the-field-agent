include: "/views/*.view"

view: +history {

  dimension: query_source {
    type: string
    group_label: "Source"
    description: "The source of a query, such as a Dashboard, a Look, an Explore"
    sql: case when ${source} = 'dashboard' or ${source} = 'render_manager_precache:dashboard' then 'dashboard'
            when ${source} = 'look' then 'look'
            when ${source} = 'explore' or ${source} = 'render_manager_cache:explore' or ${source} = 'render_manager_precache:explore' then 'explore'
            else 'others' end;;
  }

  dimension: initiated_by_ui_user {
    type: yesno
    label: "Initiated by UI User"
    description: "Whether the query is initiated by Looker UI User (dashboard, drill_modal, explore, look, merge_query, private_embed, render_manager, sqlrunner, and suggest)"
    sql: ${issuer_source} = 'User';;
  }

  measure: approximate_usage_in_minutes {
    type: number
    description: "An approximation of the number of minutes that a user used the Looker platform. This is estimated from their query usage data."
    sql: COUNT(DISTINCT
                CASE WHEN ${source} NOT IN ('alerts', 'scheduled_task') THEN
                  CONCAT( CAST(${user_id} as STRING),
                  CAST(FLOOR(UNIX_SECONDS(${created_raw})/(60*5)) as STRING)
                )
              ELSE NULL
              END
            )*5;;
  }

  measure: dashboard_run_count {
    type: count_distinct
    description: "Count of times a dashboard was run"
    sql: ${dashboard_session};;
  }

## Look run count equals to query run count because merged queries can not be saved as look https://cloud.google.com/looker/docs/merged-results
  measure: look_run_count {
    type: count
    description: "Count of times a look was run"
    filters: [status: "-cache_only_miss"]
  }

  measure: first_query_date {
    type: date
    description: "The first history event for a query."
    sql: MIN(${created_raw});;
  }

  measure: most_recent_query_date {
    type: date
    description: "The most recent history event for a query. This may be more recent than a user's Last UI Login if the query was run via the API, as part of a scheduled job, when sudoed, or during an embed session"
    sql: MAX(${created_raw});;
  }

  measure: queries_under_10s {
    type: count
    group_label: "Query Counts"
    description: "Count of queries that completed in less than 10 seconds"
    filters: [runtime_under_10s: "yes"]
  }

  measure: query_run_count {
    type: count
    group_label: "Query Counts"
    description: "The number of query runs (this field is best used in conjunction with a filter or pivot on history source). This count filters out history entries where `status` = 'cache_only_miss'."
    filters: [status: "-cache_only_miss"]
  }

  measure: cache_result_query_count {
    type: count
    group_label: "Query Counts"
    label: "Results from Cache"
    description: "The number of queries returned from cache"
    filters: [result_source: "cache"]
  }

  measure: database_result_query_count {
    type: count
    group_label: "Query Counts"
    label: "Results from Database"
    description: "The number of queries returned from database (as opposed to from cache)"
    filters: [result_source: "query"]
  }

  measure: average_runtime {
    type: average
    value_format: "0.0"
    group_label: "Runtime metrics"
    label: "Average Runtime in Seconds"
    description: "The average query runtime in seconds"
    sql: NULLIF(${runtime},0) ;;
  }

  measure: max_runtime {
    type: max
    value_format: "0.0"
    group_label: "Runtime metrics"
    label: "Max Runtime in Seconds"
    description: "The longest query runtime in seconds"
    sql: ${runtime} ;;
  }

  measure: min_runtime {
    type: min
    value_format: "0.0"
    group_label: "Runtime metrics"
    label: "Min Runtime in Seconds"
    description: "The shortest query runtime in seconds"
    sql: ${runtime} ;;
  }

  measure: total_runtime {
    type: sum
    value_format: "0.0"
    group_label: "Runtime metrics"
    label: "Total Runtime in Seconds"
    description: "The sum of query runtimes in seconds"
    sql: coalesce(${runtime}, 0) ;;
  }

  measure: dashboard_user {
    type: count_distinct
    group_label: "User Counts"
    description: "The count of distinct users who have run dashboard queries"
    sql: CASE WHEN ${source} = 'dashboard' or ${source} = 'run_async' THEN ${user.id} ELSE NULL END ;;
  }

  measure: explore_user {
    type: count_distinct
    group_label: "User Counts"
    description: "The count of distinct users who have run Explore queries"
    sql: CASE WHEN ${source} = 'explore' THEN ${user.id} ELSE NULL END ;;
  }

}
