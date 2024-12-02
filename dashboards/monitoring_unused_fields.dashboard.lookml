---
- dashboard: monitoring_unused_fields
  title: Monitoring Unused Fields
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: xdvLdciFg3FikhzfMLKigY
  elements:
  - title: Detailed list of unused fields
    name: Detailed list of unused fields
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [lookml_fields.project_name, explore_label.model_name, explore_label.model_label,
      lookml_fields.explore_name, lookml_fields.view_name, lookml_fields.field_label,
      lookml_fields.field_name, lookml_fields.field_filters, lookml_fields.field_type,
      parsed_query.field_type_in_query, lookml_fields.is_field_hidden, field_usage.count]
    filters:
      field_usage.count: '0'
    sorts: [lookml_fields.field_name]
    limit: 500
    column_limit: 50
    query_timezone: Asia/Saigon
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    truncate_column_names: false
    defaults_version: 1
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
      Is Explore Hidden (Yes / No): explore_label.is_explore_hidden
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Field Type In Query: parsed_query.field_type_in_query
    row: 0
    col: 10
    width: 14
    height: 10
  - title: Unused fields by View
    name: Unused fields by View
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_bar
    fields: [lookml_fields.view_name, lookml_fields.count, lookml_fields.explore_name,
      lookml_fields.project_name]
    filters:
      field_usage.count: '0'
    sorts: [lookml_fields.count desc]
    limit: 500
    column_limit: 50
    query_timezone: Asia/Saigon
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
      Is Explore Hidden (Yes / No): explore_label.is_explore_hidden
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Field Type In Query: parsed_query.field_type_in_query
    row: 0
    col: 0
    width: 10
    height: 10
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
  - name: Is Explore Hidden (Yes / No)
    title: Is Explore Hidden (Yes / No)
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
    field: explore_label.is_explore_hidden
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
