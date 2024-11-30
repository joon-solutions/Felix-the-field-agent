include: "/views/refined/*.refined.view"
include: "/views/*.view"
include: "/views/derived_tables/*.derived.view"

explore: query_metrics {
  label: "Query Performance Metrics"
  description: "Explore created by Joon Solutions to track query performance metrics data over time, included timeline above one year"

  always_filter: {
    filters: [created_at_time: "7 days"]
  }

  join: history {
    sql_on: ${query_metrics.query_task_id} = ${history.slug} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: dashboard {
    sql_on: (CASE WHEN REGEXP_CONTAINS ( ${history.dashboard_id}, '^[0-9]+$')
          THEN CAST( ${history.dashboard_id} AS INT64)
          ELSE 0
          END) =  ${dashboard.id} ;;
    relationship: many_to_one
    type: left_outer
  }

  # join: dashboard_element {
  #   sql_on: ${query_metrics.dashboard_element_id} = ${dashboard_element.id} ;;
  #   relationship: many_to_one
  # }

  # join: dashboard_folders {
  #   from: folders
  #   sql_on: ${dashboard.space_id} = ${dashboard_folders.id} ;;
  #   relationship: many_to_one
  #   type: left_outer
  # }

  # join: dashboard_tiles {
  #   sql_on: ${dashboard.id} = ${dashboard_tiles.dashboard_id} ;;
  #   relationship: one_to_one
  #   type: left_outer
  # }

  join: query {
    sql_on: ${history.query_id} = ${query.id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: query_dynamic_field {
    sql_on: ${query.id} = ${query_dynamic_field.query_id};;
    relationship: one_to_many
    type: left_outer
  }

  join: explore_label {
    sql_on: ${query.view} = ${explore_label.explore_name};;
    relationship: many_to_one
    type: left_outer
  }

  join: look {
    sql_on: ${history.look_id} = ${look.id};;
    relationship: many_to_one
    type:  left_outer
  }


  # join: look_folders {
  #   from: folders
  #   sql_on: ${look.space_id} = ${look_folders.id} ;;
  #   relationship: many_to_one
  #   type: left_outer
  # }

  join: user {
    sql_on: ${history.user_id} = ${user.id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: user_facts {
    view_label: "User Facts (updated hourly)"
    sql_on: ${history.user_id} = ${user_facts.user_id};;
    relationship: many_to_one
    type: left_outer
  }


  join: dashboard_creator {
    from: user
    view_label: "Dashboard Creator (updated hourly)"
    sql_on: ${dashboard.user_id} = ${dashboard_creator.id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: dashboard_creator_facts {
    from: user_facts
    view_label: "Dashboard Creator Facts (updated hourly)"
    sql_on: ${dashboard.user_id} = ${dashboard_creator_facts.user_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: look_creator {
    from: user
    view_label: "Look Creator (updated hourly)"
    sql_on: ${look.user_id} = ${look_creator.id};;
    relationship: many_to_one
    type: left_outer
  }

  join: look_creator_facts {
    from: user_facts
    view_label: "Look Creator Facts (updated hourly)"
    sql_on: ${look.user_id} = ${look_creator_facts.user_id};;
    relationship: one_to_many
    type: left_outer
  }


  join: dashboard_last_updater {
    from: user
    view_label: "Dashboard Last Updater (updated hourly)"
    sql_on: ${dashboard.last_updater_id} = ${dashboard_last_updater.id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: dashboard_last_updater_facts {
    from: user_facts
    view_label: "Dashboard Last Updater Facts (updated hourly)"
    sql_on: ${dashboard.last_updater_id} = ${dashboard_last_updater_facts.user_id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: look_last_updater {
    from: user
    view_label: "Look Last Updater (updated hourly)"
    sql_on: ${look.last_updater_id} = ${look_last_updater.id};;
    relationship: many_to_one
    type: left_outer
  }

  join: look_last_updater_facts {
    from: user_facts
    view_label: "Look Last Updater Facts (updated hourly)"
    sql_on: ${look.last_updater_id} = ${look_last_updater_facts.user_id};;
    relationship: one_to_many
    type: left_outer
  }


  # join: dashboard_scheduled_plan {
  #   sql_on: ${dashboard.id} = ${dashboard_scheduled_plan.dashboard_id};;
  #   relationship: one_to_one
  #   type: left_outer
  # }

  # join: look_scheduled_plan {
  #   sql_on: ${look.id} = ${look_scheduled_plan.look_id};;
  #   relationship: one_to_one
  #   type: left_outer
  # }
}

explore: +query_metrics {
  query: query_summary {
    description: "Granular look at the individual timings of a history query event."
    dimensions: [
      query.id,
      history.source,
      history.completed_time,
      history.dashboard_id,
      query_metrics.project_init,
      query_metrics.model_init_computed,
      query_metrics.model_init_cache,
      query_metrics.explore_init,
      query_metrics.marshalled_cache_load,
      query_metrics.prepare,
      query_metrics.acquire_connection,
      query_metrics.connection_held,
      query_metrics.execute_main_query,
      query_metrics.execute_fill_min_query,
      query_metrics.execute_fill_max_query,
      query_metrics.execute_fill_pivot_min_query,
      query_metrics.execute_fill_pivot_max_query,
      query_metrics.execute_totals_query,
      query_metrics.execute_row_totals_query,
      query_metrics.execute_grand_totals_query,
      query_metrics.load_main_query_in_memory,
      query_metrics.load_fill_min_query_in_memory,
      query_metrics.load_fill_max_query_in_memory,
      query_metrics.load_fill_pivot_min_query_in_memory,
      query_metrics.load_fill_pivot_max_query_in_memory,
      query_metrics.load_totals_query_in_memory,
      query_metrics.load_row_totals_query_in_memory,
      query_metrics.load_grand_totals_query_in_memory,
      query_metrics.post_processing,
      query_metrics.pdt,
      query_metrics.cache_load,
      query_metrics.stream_to_cache,
      query_metrics.async_processing,
      query_metrics.queued,
      query_metrics.per_user_throttler

    ]
  }


# explore: +query_metrics {
#   query: long_running_queries_by_users{
#     description: "Which users have the highest average main query execution time?"
#     dimensions: [user.name]
#     measures: [count, execute_main_query_average]
#   }
# }

# explore: +query_metrics {
#   query: long_running_queries_by_explores {
#     description: "Which explores have the highest average main query execution time?"
#     dimensions: [query.model, query.view]
#     measures: [count, execute_main_query_average]

#   }

# }
# explore: +query_metrics  {
#   query: asynchronous_worker_phase {
#     description: "Shows hourly trend of average timings in the asynchronous worker phase."
#     dimensions: [history.completed_hour_of_day]
#     measures: [async_processing_average, queued_average]
#   }
# }

# explore: +query_metrics {
#   query: initialization_phase {
#     description: "Shows hourly trend of average timings in the initialization phase."
#     dimensions: [history.completed_hour_of_day]
#     measures: [
#       prepare_average,
#       explore_init_average,
#       marshalled_cache_load_average,
#       model_init_computed_average,
#       model_init_cache_average,
#     ]
#   }
# }

# explore:   +query_metrics {
#   query: connection_handling_phase {
#     description: "Shows hourly trend of average timings in the connection handling phase."
#     dimensions: [history.completed_hour_of_day]
#     measures: [
#       per_user_throttler_average,
#       acquire_connection_average,
#       connection_held_average
#     ]
#   }
}

# explore:   +query_metrics {
#   query: main_query_phase {
#     description: "Shows hourly trend of average timings in the main query phase."
#     dimensions: [history.completed_hour_of_day]
#     measures: [
#       execute_main_query_average,
#       cache_load_average,
#       load_main_query_in_memory_average,
#       load_process_and_stream_main_query_average,
#       pdt_average
#     ]
#   }
# }

# explore:   +query_metrics {
#   query: post_query_phase {
#     description: "Shows hourly trend of average timings in the post query phase."
#     dimensions: [history.completed_hour_of_day]
#     measures: [postprocessing_average,stream_to_cache_average]
#   }
# }
