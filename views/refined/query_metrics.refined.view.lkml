include: "/views/query_metrics.view.lkml"

view: +query_metrics {

  measure: count_acquire_connection {
    type: number
    group_label: "Counts"
    label: "Count Acquire Connection Query Events"
    description: "Count of query events that waited for the connection to be acquired."
    sql: COUNT(CASE WHEN NOT (${acquire_connection} IS NULL) THEN 1 ELSE NULL END) ;;
  }

  measure: count_explore_init_computed {
    type: number
    group_label: "Counts"
    label: "Count of Explore Init: Computed"
    description: "Count of query events that did not pull the explore definition from cache."
    sql: COUNT(CASE WHEN (${explore_init_mode} = 'computed') THEN 1 ELSE NULL END) ;;
  }

  measure: count_per_user_throttler_events {
    type: number
    group_label: "Counts"
    label: "Count Per User Throttler Events"
    description: "Count of query events that waited for a connection to become available."
    sql:  COUNT(CASE WHEN NOT (${per_user_throttler} IS NULL) THEN 1 ELSE NULL END) ;;
  }

  measure: count_queued_events {
    type: number
    group_label: "Counts"
    description: "Count of query events that were queued waiting for a worker to become available."
    sql:  COUNT(CASE WHEN NOT (${queued} IS NULL) THEN 1 ELSE NULL END)  ;;
  }

  ############### Used for Explore Warnings & Recommendations ###############
  measure: count_prepare {
    type: number
    group_label: "Counts"
    hidden: yes
    sql:  COUNT(${prepare})  ;;
  }

  measure: count_acquire_connection_all {
    type: number
    group_label: "Counts"
    label: "Count All Acquire Connection"
    hidden: yes
    sql: COUNT(${acquire_connection}) ;;
  }

  measure: count_explore_init_cached {
    type: number
    group_label: "Counts"
    label: "Count of Explore Init: Cached"
    hidden: yes
    sql: COUNT(${marshalled_cache_load}) ;;
  }

  measure: count_explore_init_computed_all {
    type: number
    group_label: "Counts"
    hidden: yes
    sql: COUNT(CASE WHEN (${explore_init_mode} = 'computed') THEN ${explore_init} ELSE NULL END) ;;
  }

  measure: count_model_init_computed {
    type: number
    group_label: "Counts"
    label: "Count of Model Init: Computed"
    hidden: yes
    sql: COUNT(${model_init_computed}) ;;
  }

  measure: count_execute_main_query {
    type: number
    group_label: "Counts"
    hidden: yes
    sql: COUNT(${execute_main_query}) ;;
  }

  measure: count_post_processing {
    type: number
    group_label: "Counts"
    hidden: yes
    sql: COUNT(${post_processing}) ;;
  }

  measure: count_stream_to_cache {
    type: number
    group_label: "Counts"
    hidden: yes
    sql: COUNT(${stream_to_cache}) ;;
  }

  ############### Timings: Asynchronous Worker ###############
  measure: queued_average {
    type: average
    group_label: "Timings: Asynchronous Worker"
    description: "Average time in seconds that a query spent waiting for a worker to be available to run the query."
    value_format: "0.000"
    sql: COALESCE(${queued}, 0.0);;
  }

  measure: async_processing_average {
    type: average
    group_label: "Timings: Asynchronous Worker"
    description: "Average time in seconds spent executing the query. Will not include time it takes for a query task to be “added” to the queue, or time it takes for the client API workflow to “notice” that the query has completed, or stream the results from the cache."
    value_format: "0.000"
    sql: COALESCE(${async_processing}, 0.0);;
  }

  measure: acquisition_percent_of_async {
    label: "Percentage of Async Processing spent Acquiring the Connection"
    group_label: "Timings: Asynchronous Worker"
    description: "Average time spent acquiring the connection as a percentage of Average Async Processing."
    value_format_name: "percent_2"
    sql: ${acquire_connection_average} / ${async_processing_average} ;;
  }
  measure: per_user_throttle_percent_of_async {
    label: "Percentage of Async Processing spent in Per User Throttler"
    group_label: "Timings: Asynchronous Worker"
    description: "Average Per User Throttler Duration as a percentage of Average Total Async Processing."
    value_format_name: "percent_2"
    sql: ${per_user_throttler_average} / ${async_processing_average} ;;
  }

  measure: queued_percent_of_async {
    label: "Percentage of Async Processing spent Queued"
    group_label: "Timings: Asynchronous Worker"
    description: "Average time spent waiting for a worker to become available as a percentage of Average Async Processing."
    value_format_name: "percent_2"
    sql: ${queued_average} / ${async_processing_average} ;;
  }

  ############### Timings: Connection Handling ###############
  measure: acquire_connection_average {
    type: average
    group_label: "Timings: Connection Handling"
    description: "Average time in seconds necessary to acquire connection to the DB. This includes time to look up the credentials (or key) for the user, create the connection pool if it does not already exist, and initialize the connection for use."
    value_format: "0.000"
    sql:  COALESCE(${acquire_connection}, 0.0);;
  }

  measure: connection_held_average {
    type: average
    group_label: "Timings: Connection Handling"
    description: "Average time in seconds that Looker maintained a connection to the customer database (AKA 'execute SQL duration'). This includes time it takes for the customer database to run the SQL query."
    value_format: "0.000"
    sql: COALESCE(${connection_held}, 0.0);;
  }
  measure: connection_held_total {
    type: sum
    group_label: "Timings: Connection Handling"
    description: "Total time in seconds necessary to execute the sql (seconds). The time recorded here is NOT the time to execute the SQL query, but instead the time with the connection held open"
    value_format: "0.000"
    sql: ${connection_held} ;;
  }
  measure: per_user_throttler_average {
    type:  average
    group_label: "Timings: Connection Handling"
    description: "Average time in seconds the query is throttled by the per-user throttler. This is time spent waiting for a connection to be available for the user to run the query. This could be high either due to the user running a high number of concurrent queries or a low user limit."
    value_format: "0.000"
    sql:  COALESCE(${per_user_throttler}, 0.0);;
  }

  ############### Timings: Initialization ###############
  #measure based on pre-computed dimension explore_init in BigQuery
  measure: explore_init_average {
    type: average
    group_label: "Timings: Initialization"
    label: "Explore Init: Computed Average"
    description: "Average time in seconds to initialize the explore before 'preparing' it. If this is null, then the initialization came from cache, see 'Explore Init: From Cache Average.'"
    value_format: "0.000"
    sql: COALESCE(${explore_init}, 0.0);;

  }

  #measure based on pre-computed dimension marshalled_cache_load in BigQuery
  measure: marshalled_cache_load_average {
    type: average
    group_label: "Timings: Initialization"
    label: "Explore Init: From Cache Average"
    description: "Average time in seconds to pull the explore initialization from cache. Also known as 'Marshalled Cache Load.' If this is null, then the initiialization was computed, see 'Explore Init: Computed Average.'"
    value_format: "0.000"
    sql: COALESCE(${marshalled_cache_load}, 0.0);;

  }

  #measure based on pre-computed dimension model_init_computed in BigQuery
  measure: model_init_computed_average {
    type: average
    group_label: "Timings: Initialization"
    label: "Model Init: Computed Average"
    description: "Average time in seconds to initialize the model required to run the query."
    value_format: "0.000"
    sql: COALESCE(${model_init_computed}, 0.0);;

  }

  #measure based on pre-computed dimension model_init_cache in BigQuery
  measure: model_init_cache_average {
    type: average
    group_label: "Timings: Initialization"
    label: "Model Init: From Cache Average"
    description: "Average time in seconds to load from cache the model initialization required to run the query"
    value_format: "0.000"
    sql: COALESCE(${model_init_cache}, 0.0);;

  }
  measure: prepare_average {
    type: average
    group_label: "Timings: Initialization"
    description: "Average time in seconds necessary for preparing the query."
    value_format: "0.000"
    sql: COALESCE(${prepare}, 0.0);;

  }

  ############### Timings: Main Query ###############
  measure: cache_load_average {
    type: average
    group_label: "Timings: Main Query"
    description: "Average time in seconds it takes to pull raw results from the result set cache. When a query has been run recently, it is possible that the results will be in the result set cache. Instead of running the query on the database again, Looker loads these results from the cache into memory."
    value_format: "0.000"
    sql: COALESCE(${cache_load}, 0.0);;
  }
  measure: execute_main_query_average {
    type: average
    group_label: "Timings: Main Query"
    description: "Average time in seconds it took to run the 'primary' query on the customer database."
    value_format: "0.000"
    sql: COALESCE(${execute_main_query}, 0.0);;
  }
  measure: load_main_query_in_memory_average {
    type: average
    group_label: "Timings: Main Query"
    description: "Average time in seconds it took to load the main query results in memory from the customer database. Applies to non-streamed queries only."
    value_format: "0.000"
    sql: COALESCE(${load_main_query_in_memory}, 0.0);;
  }
  measure: load_process_and_stream_main_query_average {
    type: average
    group_label: "Timings: Main Query"
    description: "Average time in seconds it took to load (from the customer database), process, and stream (to the client) the main query. Applies to streamed queries only."
    value_format: "0.000"
    sql: COALESCE(${load_process_and_stream_main_query}, 0.0);;
  }

  ############### Timings: Misc. Ancillary Queries ###############
  measure: pdt_average {
    type: average
    group_label: "Timings: Misc. Ancillary Queries"
    label: "PDTs average"
    description: "Average time in seconds to build the persistent derived tables required for the query."
    value_format: "0.000"
    sql: COALESCE(${pdt}, 0.0);;
  }

  ############### Timings: Post Query ###############
  measure: postprocessing_average {
    type: average
    group_label: "Timings: Post Query"
    description: "Average time in seconds necessary for postprocessing query."
    value_format: "0.000"
    sql: COALESCE(${post_processing}, 0.0);;
  }

  measure: stream_to_cache_average {
    type: average
    group_label: "Timings: Post Query"
    description: "Average time in seconds to process and stream results to the render cache (seconds). This span is only present when running an async query from the query manager."
    value_format: "0.000"
    sql: COALESCE(${stream_to_cache}, 0) ;;
  }

  ############### Timings: Summaries ###############
  measure: average_in_queue {
    type: average
    group_label: "Timings: Summaries"
    label: "Average Time Spent in Looker Queue"
    description: "Average time spent in the Looker-side queue"
    value_format: "0.000"
    sql: COALESCE(${queued}, 0.0);;
  }

  measure: average_query_initialization {
    type: average
    group_label: "Timings: Summaries"
    label: "Average Time Spent Initializing and Connecting"
    description: "Time spent building the query from the underlying LookML and connecting to the database"
    value_format: "0.000"
    sql: COALESCE(${acquire_connection}, 0) --
        + COALESCE(${per_user_throttler}, 0) --
        + COALESCE((CASE WHEN ${explore_init_mode} = 'computed' THEN ${explore_init} ELSE NULL END), 0) --
        + COALESCE(${project_init}, 0)
        + COALESCE((CASE WHEN ${explore_init_mode} = 'cached' THEN ${explore_init} ELSE NULL END), 0) --
        + COALESCE(${model_init_computed}, 0) --
        + COALESCE(${model_init_cache}, 0) --
        + COALESCE(${prepare}, 0) --
        + COALESCE(${cache_load}, 0) -- ;;
  }

  measure: average_processing_results {
    type: average
    group_label: "Timings: Summaries"
    label: "Average Time Spent Processing Results"
    description: "After the query has finished running, the average time spent post processing and streaming to cache"
    value_format: "0.000"
    sql: COALESCE(${post_processing}, 0) + COALESCE(${stream_to_cache}, 0) ;;
  }

  measure: running_query_average {
    type: average
    group_label: "Timings: Summaries"
    label: "Average Time Spent Running Queries"
    description: "Average time spent running the query on the database. This includes the main query and any needed additional queries including calculating totals and building PDTs."
    value_format: "0.000"
    sql: COALESCE(${execute_main_query}, 0)
          + COALESCE(${load_main_query_in_memory}, 0)
          + COALESCE(${load_process_and_stream_main_query}, 0)
          + COALESCE(${load_fill_pivot_min_query_in_memory}, 0)
          + COALESCE(${load_fill_pivot_max_query_in_memory}, 0)
          + COALESCE(${load_extents_query_in_memory}, 0)
          + COALESCE(${temporary_dt}, 0)
          + COALESCE(${load_row_totals_query_in_memory}, 0)
          + COALESCE(${execute_fill_pivot_max_query}, 0)
          + COALESCE(${execute_fill_pivot_min_query}, 0)
          + COALESCE(${execute_extents_query}, 0)
          + COALESCE(${execute_grand_totals_query}, 0)
          + COALESCE(${execute_row_totals_query}, 0)
          + COALESCE(${execute_totals_query}, 0)
          + COALESCE(${pdt}, 0) ;;
  }

  ############### Timings: Phase Summaries ###############

  measure: 1_async_worker_phase {
    type: number
    group_label: "Timings: Phase Summaries"
    label: " 1-Average time spent in Async Worker Phase"
    description: "Average time in seconds it took for the query to be assigned to an available asynchronous worker. There may be queue time if no worker is available."
    value_format: "0.000"
    sql: ${queued_average}+${async_processing_average} ;;
  }

  measure: 2_initialization_phase {
    type: number
    group_label: "Timings: Phase Summaries"
    label: "2-Average time spent in Initialization Phase"
    description: "Average time in seconds it took for the Looker instance to run several initialization steps to prepare the query."
    value_format: "0.000"
    sql:  ${model_init_cache_average}
          + ${model_init_computed_average}
          + ${marshalled_cache_load_average}
          + ${explore_init_average}
          + ${prepare_average} ;;
  }

  measure: 3_connection_handling {
    type: number
    group_label: "Timings: Phase Summaries"
    label: "3-Average time spent in Connection handling"
    description: "Average time in seconds it took for the Looker instance to establishe a connection to the customer database."
    value_format: "0.000"
    sql:  ${per_user_throttler_average}
          + ${acquire_connection_average}
          + ${connection_held_average} ;;
  }

  measure: 4_main_query_phase {
    type: number
    group_label: "Timings: Phase Summaries"
    label: "4-Average time spent in Main Query Phase"
    description: "Average time in seconds it took for the main query to be executed on the customer database."
    value_format: "0.000"
    sql:  ${cache_load_average}
          + ${pdt_average}
          + ${execute_main_query_average}
          + ${avg_execute_totals_query}
          + ${avg_execute_row_totals_query}
          + ${avg_execute_grand_totals_query}
          + ${load_process_and_stream_main_query_average}
          + ${load_main_query_in_memory_average}
          + ${avg_load_totals_query_in_memory}
          + ${avg_load_row_totals_query_in_memory}
          + ${avg_load_grand_totals_query_in_memory} ;;
  }

  measure: 5_postquery_phase {
    type: number
    group_label: "Timings: Phase Summaries"
    label: "5-Average time spent in PostQuery phase"
    description: "Average time in seconds it took for the Looker instance to run several post-query steps to prepare the query for its next destination."
    value_format: "0.000"
    sql: ${postprocessing_average} + ${stream_to_cache_average} ;;
  }

  measure: total_time {
    type: number
    group_label: "Timings: Phase Summaries"
    label: "Total Time"
    description: "Average time in seconds it took to complete all phases, including time a query spends waiting for an asynchronous worker"
    value_format: "0.000"
    sql:  ${queued_average} --- exclude async_processing_average as it overlaps with most of other steps
          + ${2_initialization_phase}
          + ${per_user_throttler_average} --- exclude async_processing_average as it overlaps query execution steps
          + ${acquire_connection_average} --- exclude async_processing_average as it overlaps query execution steps
          + ${4_main_query_phase}
          + ${5_postquery_phase} ;;
  }

  ############### Timings: Total Query ###############

  measure: avg_execute_grand_totals_query {
    type: average
    group_label: "Timings: Total Query"
    label: "Execute Grand Totals Query"
    description: "Average time in seconds it took run the 'Grand Totals' query results in memory from the customer database. Only applies if both 'Totals' and 'Row Totals' are enabled for the query."
    value_format: "0.000"
    sql: ${execute_grand_totals_query} ;;
  }

  measure: avg_execute_row_totals_query {
    type: average
    group_label: "Timings: Total Query"
    label: "Execute Row Totals Query"
    description: "Average time in seconds it took to run the 'Row Totals' query results in memory from the customer database. Only applies if 'Row Totals' are enabled for the query."
    value_format: "0.000"
    sql: ${execute_row_totals_query} ;;
  }

  measure: avg_execute_totals_query {
    type: average
    group_label: "Timings: Total Query"
    label: "Execute Totals Query"
    description: "Average time in seconds it took to run the 'Totals' query on the customer database."
    value_format: "0.000"
    sql: ${execute_totals_query} ;;
  }

  measure: avg_load_grand_totals_query_in_memory {
    type: average
    group_label: "Timings: Total Query"
    label: "Load Grand Totals Query In Memory"
    description: "Average time in seconds it took to load the 'Grand Totals' query results in memory from the customer database. Only applies if both 'Totals' and 'Row Totals' are enabled for the query."
    value_format: "0.000"
    sql: ${load_grand_totals_query_in_memory} ;;
  }

  measure: avg_load_row_totals_query_in_memory {
    type: average
    group_label: "Timings: Total Query"
    label: "Load Row Totals Query In Memory"
    description: "Average time in seconds it took to load the 'Row Totals' query results in memory from the customer database. Only applies if 'Row Totals' are enabled for the query."
    value_format: "0.000"
    sql: ${load_row_totals_query_in_memory} ;;
  }

  measure: avg_load_totals_query_in_memory {
    type: average
    group_label: "Timings: Total Query"
    label: "Load Totals Query In Memory"
    description: "Average time in seconds it took to load the 'Totals' query results in memory from the customer database. Only applies if both 'Totals' are enabled for the query."
    value_format: "0.000"
    sql: ${load_totals_query_in_memory} ;;
  }

  measure: avg_execute_n_load_all_totals_query {
    type: average
    group_label: "Timings: Total Query"
    label: "Excecute & Load All Totals Query"
    description: "Average time in seconds it took to run & load all types of Totals (Totals, Row Totals, Grand Totals) query results in memory from the customer database"
    value_format: "0.000"
    sql: ${execute_grand_totals_query}
                  + ${execute_totals_query}
                  + ${execute_row_totals_query}
                  + ${load_grand_totals_query_in_memory}
                  + ${load_totals_query_in_memory}
                  + ${load_row_totals_query_in_memory} ;;
  }

  ############### Explore Warnings and Recommendations ###############
  measure: severity_score {
    type: number
    view_label: "Explore Warnings and Recommendations"
    description: "Severity score based on query metric values above the recommended benchmark."
    value_format: "0.000"
    sql: ROUND(
            COALESCE((${prepare_average} - 0.4389) * (FLOOR(${prepare_average} / 0.4389) / NULLIF(FLOOR(${prepare_average} / 0.4389), 0)), 0)
            + COALESCE((${marshalled_cache_load_average} - 0.3513) * (FLOOR(${marshalled_cache_load_average} / 0.3513) / NULLIF(FLOOR(${marshalled_cache_load_average} / 0.3513), 0)), 0)
            + COALESCE((${explore_init_average} - 0.2333) * (FLOOR(${explore_init_average} / 0.2333) / NULLIF(FLOOR(${explore_init_average} / 0.2333), 0)), 0)
            + COALESCE((${model_init_computed_average} - 2.4199) * (FLOOR(${model_init_computed_average} / 2.4199) / NULLIF(FLOOR(${model_init_computed_average} / 2.4199), 0)), 0)
            + COALESCE((${acquire_connection_average} - 0.2383) * (FLOOR(${acquire_connection_average} / 0.2383) / NULLIF(FLOOR(${acquire_connection_average} / 0.2383), 0)), 0)
            + COALESCE((${execute_main_query_average} - 4.8698) * (FLOOR(${execute_main_query_average} / 4.8698) / NULLIF(FLOOR(${execute_main_query_average} / 4.8698), 0)), 0)
            + COALESCE((${postprocessing_average} - 0.0017) * (FLOOR(${postprocessing_average} / 0.0017) / NULLIF(FLOOR(${postprocessing_average} / 0.0017), 0)), 0)
            + COALESCE((${stream_to_cache_average} - 0.2334) * (FLOOR(${stream_to_cache_average} / 0.2334) / NULLIF(FLOOR(${stream_to_cache_average} / 0.2334), 0)), 0),
            2);;
  }

  measure: warnings_summary {
    type: string
    view_label: "Explore Warnings and Recommendations"
    description: "Displays a warning if the severity is above the recommended benchmark."
    sql: CONCAT(
            CASE WHEN ${count_prepare} >= {% parameter minimum_query_events %} AND ${prepare_average} >= 0.4389 THEN CONCAT('The average prepare time is ', ROUND(${prepare_average}, 3), 's which is ', ROUND(100 * (${prepare_average} - 0.4389) / 0.4389, 2), '% above the recommended benchmark (0.4389s).') ELSE '' END,
            CASE WHEN ${count_explore_init_computed_all} >= {% parameter minimum_query_events %} AND ${explore_init_average} >= 0.2333 THEN CONCAT('  The average explore init: computed time is ', ROUND(${explore_init_average}, 3), 's which is ', ROUND(100 * (${explore_init_average} - 0.2333) / 0.2333, 2), '% above the recommended benchmark (0.2333s).') ELSE '' END,
            CASE WHEN ${count_explore_init_cached} >= {% parameter minimum_query_events %} AND ${marshalled_cache_load_average} >= 0.3513 THEN CONCAT('  The average explore init: from cache (marshalled cache load) time is ', ROUND(${marshalled_cache_load_average}, 3), 's which is ', ROUND(100 * (${marshalled_cache_load_average} - 0.3513) / 0.3513, 2), '% above the recommended benchmark (0.3513s).') ELSE '' END,
            CASE WHEN ${count_model_init_computed} >= {% parameter minimum_query_events %} AND ${model_init_computed_average} >= 2.4199 THEN CONCAT('  The average model init: computed time is ', ROUND(${model_init_computed_average}, 3), 's which is ', ROUND(100 * (${model_init_computed_average} - 2.4199) / 2.4199, 2), '% above the recommended benchmark (2.4199s).') ELSE '' END,
            CASE WHEN ${count_acquire_connection_all} >= {% parameter minimum_query_events %} AND ${acquire_connection_average} >= 0.2383 THEN CONCAT('  The average connection acquisition time is ', ROUND(${acquire_connection_average}, 3), 's which is ', ROUND(100 * (${acquire_connection_average} - 0.2383) / 0.2383, 2), '% above the recommended benchmark (0.2383s).') ELSE '' END,
            CASE WHEN ${count_execute_main_query} >= {% parameter minimum_query_events %} AND ${execute_main_query_average} >= 4.8698 THEN CONCAT('  The average main query execution time is ', ROUND(${execute_main_query_average}, 3), 's which is ', ROUND(100 * (${execute_main_query_average} - 4.8698) / 4.8698, 2), '% above the recommended benchmark (4.8698s).') ELSE '' END,
            CASE WHEN ${count_post_processing} >= {% parameter minimum_query_events %} AND ${postprocessing_average} >= 0.0017 THEN CONCAT('  The average postprocessing time is ', ROUND(${postprocessing_average}, 3), 's which is ', ROUND(100 * (${postprocessing_average} - 0.0017) / 0.0017, 2), '% above the recommended benchmark (0.0017s).') ELSE '' END,
            CASE WHEN ${count_stream_to_cache} >= {% parameter minimum_query_events %} AND ${stream_to_cache_average} >= 0.2334 THEN CONCAT('  The average stream to cache time is ', ROUND(${stream_to_cache_average}, 3), 's which is ', ROUND(100 * (${stream_to_cache_average} - 0.2334) / 0.2334, 2), '% above the recommended benchmark (0.2334s).') ELSE '' END
        );;
    ## html transforms a string into multiple lines, inserts icons to each line; condition sentence.size > 0 excludes all undesired content (e.g. empty line with icon).
      html: {% assign sentences = value | split: '  ' %}
        {% for sentence in sentences %}
          {% if sentence.size > 0 %}
            <p><img src="https://upload.wikimedia.org/wikipedia/commons/9/99/OOjs_UI_icon_alert-yellow.svg" alt="" height="15" width="10"> {{ sentence }}</p>
          {% endif %}
        {% endfor %} ;;
    }

    measure: recommendations_summary {
      type: string
      view_label: "Explore Warnings and Recommendations"
      description: "Displays Looker best practice recommendation if the severity is above the recommended benchmark."
      sql: CONCAT(
            CASE WHEN ${count_prepare} >= {% parameter minimum_query_events %} AND ${prepare_average} >= 0.4389 THEN 'Prepare: Enable the Aragonite feature to decrease preparation time. Move custom fields and table calculations into LookML wherever possible.' ELSE '' END,
            CASE WHEN ${count_explore_init_computed_all} >= {% parameter minimum_query_events %} AND ${explore_init_average} >= 0.2333 THEN '  Explore Init Computed: Remove unnecessary joins and exclude unnecessary fields (using the "fields" parameter) from the LookML explore. Ensure that LookML production code is changed infrequently, ideally at times when users aren`t running many queries.' ELSE '' END,
            CASE WHEN ${count_explore_init_cached} >= {% parameter minimum_query_events %} AND ${marshalled_cache_load_average} >= 0.3513 THEN '  Explore Init From Cache: Move custom fields and table calculations into LookML wherever possible.' ELSE '' END,
            CASE WHEN ${count_model_init_computed} >= {% parameter minimum_query_events %} AND ${model_init_computed_average} >= 2.4199 THEN '  Model Init Computed: Remove unnecessary views from the "include" statement of the LookML model. Ensure that LookML production code is changed infrequently, ideally at times when users aren`t running many queries.' ELSE '' END,
            CASE WHEN ${count_acquire_connection_all} >= {% parameter minimum_query_events %} AND ${acquire_connection_average} >= 0.2383 THEN '  Acquire Connection: Configure the max connection limit in the connection settings panel. It`s recommended to configure a limit no less than the max number of queries needed to run concurrently at peak traffic.' ELSE '' END,
            CASE WHEN ${count_execute_main_query} >= {% parameter minimum_query_events %} AND ${execute_main_query_average} >= 4.8698 THEN '  Execute Main Query: Avoid complex SQL logic such as window functions, CTEs, join conditions on date fields, or large join chains. Put complex SQL logic into PDTs to reduce query times. Use aggregate awareness when possible.' ELSE '' END,
            CASE WHEN ${count_post_processing} >= {% parameter minimum_query_events %} AND ${postprocessing_average} >= 0.0017 OR ${count_stream_to_cache} >= {% parameter minimum_query_events %} AND ${stream_to_cache_average} >= 0.2334 THEN '  Postprocessing or Stream to cache: Simplify table calculations and move them to LookML when possible. Remove complex pivots, sorts, or value formatting.' ELSE '' END
        );;
    ## html transforms a string into multiple lines, inserts icons to each line; condition sentence.size > 0 excludes all undesired content (e.g. empty line with icon).
        html: {% assign sentences = value | split: '  ' %}
                  {% for sentence in sentences %}
                    {% if sentence.size > 0 %}
                      <p><img src="https://upload.wikimedia.org/wikipedia/commons/8/87/Light_Bulb_or_Idea_Flat_Icon_Vector.svg" alt="" height="15" width="10"> {{ sentence }}</p>
                    {% endif %}
                  {% endfor %} ;;
      }

      measure: severity_level {
        view_label: "Explore Warnings and Recommendations"
        description: "Severity level based on query metric values above the recommended benchmark."
        type: string
        sql: CASE WHEN ${severity_score} > 0 AND ${severity_score} < 1 THEN "Low"
              WHEN ${severity_score} >= 1 AND ${severity_score} < 5 THEN "Moderate"
              WHEN ${severity_score} >= 5 THEN "High"
          ELSE NULL END;;
      }

      parameter: minimum_query_events {
        view_label: "Explore Warnings and Recommendations"
        type: number
        default_value: "30"
      }

####### Explore Warnings & Recommendations in details #######
      measure: acquire_connection_recommendation {
        group_label: "Explore Warnings & Recommendations"
        view_label: "Explore Warnings and Recommendations"
        description: "Displays Looker best practice recommendation if the average connection acquisition time is above the recommended benchmark."
        type: string
        sql: CASE WHEN ${count_acquire_connection_all} >= {% parameter minimum_query_events %}
          AND ${acquire_connection_average} >= 0.2383
          THEN 'Acquire Connection: Configure the max connection limit in the connection settings panel. It`s recommended to configure a limit no less than the max number of queries needed to run concurrently at peak traffic.'
          ELSE '' END;;
      }

      measure: acquire_connection_warning {
        group_label: "Explore Warnings & Recommendations"
        view_label: "Explore Warnings and Recommendations"
        description: "Displays a warning if the average connection acquisition time is above the recommended benchmark."
        type: string
        sql: CASE WHEN ${count_acquire_connection_all} >= {% parameter minimum_query_events %}
            AND ${acquire_connection_average} >= 0.2383
            THEN CONCAT('The average connection acquisition time is ', ROUND(${acquire_connection_average}, 3), 's which is ', ROUND(100 * (${acquire_connection_average} - 0.2383) / 0.2383, 2), '% above the recommended benchmark (0.2383s).')
            ELSE '' END ;;
      }

      measure: execute_main_query_recommendation {
        group_label: "Explore Warnings & Recommendations"
        view_label: "Explore Warnings and Recommendations"
        description: "Displays Looker best practice recommendation if the average main query execution time is above the recommended benchmark."
        type: string
        sql: CASE WHEN ${count_execute_main_query} >= {% parameter minimum_query_events %}
            AND ${execute_main_query_average} >= 4.8698
            THEN 'Execute Main Query: Avoid complex SQL logic such as window functions, CTEs, join conditions on date fields, or large join chains. Put complex SQL logic into PDTs to reduce query times. Use aggregate awareness when possible.'
            ELSE '' END ;;
      }

      measure: execute_main_query_warning {
        group_label: "Explore Warnings & Recommendations"
        view_label: "Explore Warnings and Recommendations"
        description: "Displays a warning if the average main query execution time is above the recommended benchmark."
        type: string
        sql: CASE WHEN ${count_execute_main_query} >= {% parameter minimum_query_events %}
            AND ${execute_main_query_average} >= 4.8698
            THEN CONCAT('The average main query execution time is ', ROUND(${execute_main_query_average}, 3), 's which is ', ROUND(100 * (${execute_main_query_average} - 4.8698) / 4.8698, 2), '% above the recommended benchmark (4.8698s).')
            ELSE '' END ;;
      }

      measure: explore_init_recommendation {
        group_label: "Explore Warnings & Recommendations"
        view_label: "Explore Warnings and Recommendations"
        label: "Explore Init: Computed Recommendation"
        description: "Displays Looker best practice recommendation if the average explore init: computed time is above the recommended benchmark."
        type: string
        sql: CASE WHEN ${count_explore_init_computed_all} >= {% parameter minimum_query_events %}
            AND ${explore_init_average} >= 0.2333
            THEN 'Explore Init Computed: Remove unnecessary joins and exclude unnecessary fields (using the "fields" parameter) from the LookML explore. Ensure that LookML production code is changed infrequently, ideally at times when users aren`t running many queries.'
            ELSE '' END ;;
      }

      measure: explore_init_warning {
        group_label: "Explore Warnings & Recommendations"
        view_label: "Explore Warnings and Recommendations"
        label: "Explore Init: Computed Warning"
        description: "Displays a warning if the average explore init: computed time is above the recommended benchmark."
        type: string
        sql: CASE WHEN ${count_explore_init_computed_all} >= {% parameter minimum_query_events %}
            AND ${explore_init_average} >= 0.2333
            THEN CONCAT('The average explore init: computed time is ', ROUND(${explore_init_average}, 3), 's which is ', ROUND(100 * (${explore_init_average} - 0.2333) / 0.2333, 2), '% above the recommended benchmark (0.2333s).')
            ELSE '' END ;;
      }

      measure: marshalled_cache_load_recommendation {
        group_label: "Explore Warnings & Recommendations"
        view_label: "Explore Warnings and Recommendations"
        label: "Explore Init: From Cache Recommendation"
        description: "Displays Looker best practice recommendation if the average explore init: from cache time is above the recommended benchmark."
        type: string
        sql: CASE WHEN ${count_explore_init_cached} >= {% parameter minimum_query_events %}
            AND ${marshalled_cache_load_average} >= 0.3513
            THEN 'Explore Init From Cache: Move custom fields and table calculations into LookML wherever possible.'
            ELSE '' END ;;
      }

      measure: marshalled_cache_load_warning {
        group_label: "Explore Warnings & Recommendations"
        view_label: "Explore Warnings and Recommendations"
        label: "Explore Init: From Cache Warning"
        description: "Displays a warning if the average explore init: from cache time is above the recommended benchmark."
        type: string
        sql: CASE WHEN ${count_explore_init_cached} >= {% parameter minimum_query_events %}
            AND ${marshalled_cache_load_average} >= 0.3513
            THEN CONCAT('The average explore init: from cache (marshalled cache load) time is ', ROUND(${count_explore_init_computed_all}, 3), 's which is ', ROUND(100 * (${count_explore_init_computed_all} - 0.3513) / 0.3513, 2), '% above the recommended benchmark (0.3513s).')
            ELSE '' END ;;
      }

      measure: model_init_computed_recommendation {
        group_label: "Explore Warnings & Recommendations"
        description: "Displays Looker best practice recommendation if the average model init: computed time is above the recommended benchmark."
        view_label: "Explore Warnings and Recommendations"
        type: string
        sql: CASE WHEN ${count_model_init_computed} >= {% parameter minimum_query_events %}
            AND ${model_init_computed_average} >= 2.4199
            THEN 'Model Init Computed: Remove unnecessary views from the "include" statement of the LookML model. Ensure that LookML production code is changed infrequently, ideally at times when users aren`t running many queries.'
            ELSE '' END ;;
      }

      measure: model_init_computed_warning {
        group_label: "Explore Warnings & Recommendations"
        description: "Displays a warning if the average model init: computed time is above the recommended benchmark."
        view_label: "Explore Warnings and Recommendations"
        type: string
        sql: CASE WHEN ${count_model_init_computed} >= {% parameter minimum_query_events %}
            AND ${model_init_computed_average} >= 2.4199
            THEN CONCAT('The average model init: computed time is ', ROUND(${model_init_computed_average}, 3), 's which is ', ROUND(100 * (${model_init_computed_average} - 2.4199) / 2.4199, 2), '% above the recommended benchmark (2.4199s).')
            ELSE '' END ;;
      }

      measure: postprocessing_or_stream_to_cache_recommendation {
        group_label: "Explore Warnings & Recommendations"
        description: "Displays Looker best practice recommendation if the average postprocessing time is above the recommended benchmark."
        view_label: "Explore Warnings and Recommendations"
        type: string
        sql: CASE WHEN ${count_post_processing}>= {% parameter minimum_query_events %}
            AND ${postprocessing_average} >= 0.0017
            OR ${count_stream_to_cache} >= {% parameter minimum_query_events %}
            AND ${stream_to_cache_average} >= 0.2334
            THEN 'Postprocessing or Stream to cache: Simplify table calculations and move them to LookML when possible. Remove complex pivots, sorts, or value formatting.'
            ELSE '' END ;;
      }

      measure: postprocessing_warning {
        group_label: "Explore Warnings & Recommendations"
        description: "Displays a warning if the average postprocessing time is above the recommended benchmark."
        view_label: "Explore Warnings and Recommendations"
        type: string
        sql: CASE WHEN ${count_stream_to_cache} >= {% parameter minimum_query_events %}
            AND ${postprocessing_average} >= 0.0017
            THEN CONCAT('The average postprocessing time is ', ROUND(${postprocessing_average}, 3), 's which is ', ROUND(100 * (${postprocessing_average} - 0.0017) / 0.0017, 2), '% above the recommended benchmark (0.0017s).')
            ELSE '' END ;;
      }

      measure: prepare_recommendation {
        group_label: "Explore Warnings & Recommendations"
        description: "Displays Looker best practice recommendation if the average prepare time is above the recommended benchmark."
        view_label: "Explore Warnings and Recommendations"
        type: string
        sql: CASE WHEN ${count_prepare} >= {% parameter minimum_query_events %}
            AND ${prepare_average} >= 0.4389
            THEN 'Prepare: Enable the Aragonite feature to decrease preparation time. Move custom fields and table calculations into LookML wherever possible.'
            ELSE '' END ;;
      }

      measure: prepare_warning {
        group_label: "Explore Warnings & Recommendations"
        description: "Displays a warning if the average prepare time is above the recommended benchmark."
        view_label: "Explore Warnings and Recommendations"
        type: string
        sql: CASE WHEN ${count_prepare} >= {% parameter minimum_query_events %}
            AND ${prepare_average} >= 0.4389
            THEN CONCAT('The average prepare time is ', ROUND(${prepare_average}, 3), 's which is ', ROUND(100 * (${prepare_average} - 0.4389) / 0.4389, 2), '% above the recommended benchmark (0.4389s).')
            ELSE '' END ;;
      }

      measure: stream_to_cache_warning {
        group_label: "Explore Warnings & Recommendations"
        description: "Displays a warning if the average stream to cache time is above the recommended benchmark."
        view_label: "Explore Warnings and Recommendations"
        type: string
        sql: CASE WHEN ${count_stream_to_cache} >= {% parameter minimum_query_events %}
            AND ${stream_to_cache_average} >= 0.2334
            THEN CONCAT('The average stream to cache time is ', ROUND(${stream_to_cache_average}, 3), 's which is ', ROUND(100 * (${stream_to_cache_average} - 0.2334) / 0.2334, 2), '% above the recommended benchmark (0.2334s).')
            ELSE '' END ;;
      }
    }
