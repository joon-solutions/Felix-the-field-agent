---
- dashboard: fields_usage_in_queries
  title: Fields Usage in Queries
  layout: newspaper
  description: ''
  preferred_slug: pELGgAGcVuuAvQnTz0CQ4a
  elements:
  - title: Field Usage by Source
    name: Field Usage by Source
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [lookml_fields.explore_name, lookml_fields.view_name, lookml_fields.field_name,
      field_usage.count]
    filters:
      lookml_fields.project_name: ''
      field_usage.query_completed_date: ''
      explore_label.explore_name: ''
      lookml_fields.view_name: ''
    sorts: [field_usage.count desc]
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      field_usage.count: Fields Usage
    series_cell_visualizations:
      field_usage.count:
        is_active: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '20'
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    x_axis_zoom: true
    y_axis_zoom: true
    trellis: ''
    stacking: ''
    hide_legend: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: desc
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    listen: {}
    row: 0
    col: 0
    width: 24
    height: 8
  - title: Fields that are mostly used in filters
    name: Fields that are mostly used in filters
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [lookml_fields.explore_name, lookml_fields.view_name, lookml_fields.field_name,
      field_usage.count]
    filters:
      lookml_fields.project_name: ''
      field_usage.query_completed_date: ''
      explore_label.explore_name: ''
      lookml_fields.view_name: ''
      user.email: "-%spectacles-worker%"
      parsed_query.field_type_in_query: filters
    sorts: [field_usage.count desc 0]
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      field_usage.count: Times of Field used in Filters
    series_column_widths:
      lookml_fields.explore_name: 256
      field_usage.count: 401
    series_cell_visualizations:
      field_usage.count:
        is_active: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '20'
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_pivots: {}
    defaults_version: 1
    hidden_fields: []
    hidden_points_if_no: []
    show_null_points: true
    listen: {}
    row: 8
    col: 0
    width: 18
    height: 8
  - title: Fields in the longest-running queries
    name: Fields in the longest-running queries
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [lookml_fields.explore_name, lookml_fields.view_name, lookml_fields.field_name,
      query_metrics.total_time]
    filters:
      lookml_fields.project_name: ''
      field_usage.query_completed_date: ''
      explore_label.explore_name: ''
      lookml_fields.view_name: ''
      user.email: "-%spectacles-worker%"
      query_metrics.total_time: NOT NULL
    sorts: [query_metrics.total_time desc]
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      query_metrics.total_time: Average Query time
    series_column_widths:
      lookml_fields.explore_name: 256
      lookml_fields.view_name: 365
    series_cell_visualizations:
      field_usage.count:
        is_active: true
      query_metrics.total_time:
        is_active: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '20'
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_pivots: {}
    defaults_version: 1
    listen: {}
    row: 16
    col: 0
    width: 18
    height: 8
  - name: Recommended Actions
    type: text
    title_text: Recommended Actions
    subtitle_text: ''
    body_text: |-
      ### - Leverage partitioning and clustering on these fields where possible in DWH design to minize the run time of queries

      ### - Avoid querying unnecessary fields by explicitly selecting only the ones required.

      ### - Rewrite queries to minimize complexity, reduce nested queries, and limit data processed.
    row: 16
    col: 18
    width: 6
    height: 8
  - name: Recommended Actions (2)
    type: text
    title_text: Recommended Actions
    subtitle_text: ''
    body_text: |-
      ### - Add the partitioning keys for datetime/timestamp fields in DWH design

      ### - Add the clustering keys for dimension fields in DWH design
    row: 8
    col: 18
    width: 6
    height: 8
