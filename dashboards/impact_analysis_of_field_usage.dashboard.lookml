---
- dashboard: impact_analysis_of_field_usage
  title: Impact Analysis of Field Usage
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: BSZaSu0keZiPoHqCCi466R
  elements:
  - title: Fields queried on a Dashboard
    name: Fields queried on a Dashboard
    model: looker_hackathon_2024
    explore: lookml_fields
    type: table
    fields: [lookml_fields.field_name, lookml_fields.field_label, explore_label.explore_name,
      explore_label.explore_label, explore_label.project_name, dashboard.title, dashboard.link,
      field_usage.count]
    filters: {}
    limit: 500
    column_limit: 50
    query_timezone: Asia/Saigon
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
    row: 8
    col: 0
    width: 24
    height: 9
  - title: Fields queried on a Look
    name: Fields queried on a Look
    model: looker_hackathon_2024
    explore: lookml_fields
    type: table
    fields: [lookml_fields.field_name, lookml_fields.field_label, explore_label.explore_name,
      explore_label.explore_label, explore_label.project_name, field_usage.count,
      look.title, look.link]
    filters: {}
    limit: 500
    column_limit: 50
    query_timezone: Asia/Saigon
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
    row: 17
    col: 0
    width: 24
    height: 9
  - title: Dashboards using a certain field
    name: Dashboards using a certain field
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_bar
    fields: [dashboard.title, dashboard.link, field_usage.count]
    filters: {}
    limit: 500
    column_limit: 50
    query_timezone: Asia/Saigon
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
    limit_displayed_rows: false
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
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
    row: 0
    col: 0
    width: 12
    height: 8
  - title: Looks using a certain field
    name: Looks using a certain field
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_bar
    fields: [field_usage.count, look.link, look.id]
    filters: {}
    sorts: [field_usage.count desc 0]
    limit: 500
    column_limit: 50
    query_timezone: Asia/Saigon
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
    limit_displayed_rows: false
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
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
    row: 0
    col: 12
    width: 12
    height: 8
  filters:
  - name: Project Name
    title: Project Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: lookml_fields.project_name
  - name: Query Completed Date
    title: Query Completed Date
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: field_usage.query_completed_date
