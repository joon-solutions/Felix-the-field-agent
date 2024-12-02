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
    fields: [lookml_fields.field_name, lookml_fields.field_label, lookml_fields.field_description,
      parsed_query.field_type_in_query, lookml_fields.field_type, lookml_fields.is_field_hidden,
      explore_label.explore_name, explore_label.explore_label, explore_label.project_name,
      dashboard.title, dashboard.link, field_usage.count]
    filters: {}
    sorts: [field_usage.count desc]
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
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Dashboard ID: dashboard.id
      Look ID: look.id
      Field Type: lookml_fields.field_type
      Field Type In Query: parsed_query.field_type_in_query
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
    row: 8
    col: 0
    width: 24
    height: 9
  - title: Fields queried on a Look
    name: Fields queried on a Look
    model: looker_hackathon_2024
    explore: lookml_fields
    type: table
    fields: [lookml_fields.field_name, lookml_fields.field_label, lookml_fields.field_description,
      explore_label.explore_name, explore_label.explore_label, explore_label.project_name,
      look.title, look.link, field_usage.count]
    filters: {}
    sorts: [field_usage.count desc]
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
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Dashboard ID: dashboard.id
      Look ID: look.id
      Field Type: lookml_fields.field_type
      Field Type In Query: parsed_query.field_type_in_query
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
    row: 17
    col: 0
    width: 24
    height: 9
  - title: Dashboards using a certain field
    name: Dashboards using a certain field
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_bar
    fields: [dashboard.title, field_usage.count]
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
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Dashboard ID: dashboard.id
      Look ID: look.id
      Field Type: lookml_fields.field_type
      Field Type In Query: parsed_query.field_type_in_query
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
    row: 0
    col: 0
    width: 12
    height: 8
  - title: Looks using a certain field
    name: Looks using a certain field
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_bar
    fields: [field_usage.count, look.title]
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
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Dashboard ID: dashboard.id
      Look ID: look.id
      Field Type: lookml_fields.field_type
      Field Type In Query: parsed_query.field_type_in_query
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
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
  - name: Explore Name
    title: Explore Name
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
    field: lookml_fields.explore_name
  - name: View Label
    title: View Label
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
    field: lookml_fields.view_label
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
  - name: Dashboard ID
    title: Dashboard ID
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: dashboard.id
  - name: Look ID
    title: Look ID
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: look.id
  - name: Field Type
    title: Field Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: lookml_fields.field_type
  - name: Field Type In Query
    title: Field Type In Query
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: popover
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: parsed_query.field_type_in_query
  - name: Is Field Hidden (Yes / No)
    title: Is Field Hidden (Yes / No)
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
    field: lookml_fields.is_field_hidden
