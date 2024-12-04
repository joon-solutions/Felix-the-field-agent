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
      lookml_fields.is_field_hidden, field_usage.count, lookml_fields.field_description]
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
    note_state: collapsed
    note_display: above
    note_text: User can use `Query Completed Date` filter in this chart
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
      Is Explore Hidden (Yes / No): explore_label.is_explore_hidden
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Field Label: lookml_fields.field_label
      Field Name: lookml_fields.field_name
    row: 13
    col: 0
    width: 24
    height: 9
  - title: Top 5 Views having the most unused fields
    name: Top 5 Views having the most unused fields
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_bar
    fields: [lookml_fields.view_name, lookml_fields.count]
    filters:
      unused_fields.is_unused_field: 'Yes'
    sorts: [lookml_fields.count desc]
    limit: 5
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
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
    note_state: collapsed
    note_display: above
    note_text: 'Note: Filter Query Completed Date is not applicable'
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
      Is Explore Hidden (Yes / No): explore_label.is_explore_hidden
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Field Label: lookml_fields.field_label
      Field Name: lookml_fields.field_name
    row: 4
    col: 16
    width: 8
    height: 9
  - title: Total of unused fields (of all time)
    name: Total of unused fields (of all time)
    model: looker_hackathon_2024
    explore: lookml_fields
    type: single_value
    fields: [lookml_fields.count]
    filters:
      field_usage.count: ''
      unused_fields.is_unused_field: 'Yes'
    sorts: [lookml_fields.count desc 0]
    limit: 500
    column_limit: 50
    query_timezone: Asia/Saigon
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
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
      Field Label: lookml_fields.field_label
      Field Name: lookml_fields.field_name
    row: 0
    col: 0
    width: 12
    height: 4
  - title: Top 5 Projects having the most unused fields
    name: Top 5 Projects having the most unused fields
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_bar
    fields: [lookml_fields.count, lookml_fields.project_name]
    filters:
      unused_fields.is_unused_field: 'Yes'
    sorts: [lookml_fields.count desc]
    limit: 5
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
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
    note_state: collapsed
    note_display: above
    note_text: 'Note: Filter Query Completed Date is not applicable'
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
      Is Explore Hidden (Yes / No): explore_label.is_explore_hidden
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Field Label: lookml_fields.field_label
      Field Name: lookml_fields.field_name
    row: 4
    col: 0
    width: 8
    height: 9
  - title: Top 5 Explores having the most unused fields
    name: Top 5 Explores having the most unused fields
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_bar
    fields: [lookml_fields.count, lookml_fields.explore_name]
    filters:
      unused_fields.is_unused_field: 'Yes'
    sorts: [lookml_fields.count desc]
    limit: 5
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
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
    note_state: collapsed
    note_display: above
    note_text: 'Note: Filter Query Completed Date is not applicable'
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
      Is Explore Hidden (Yes / No): explore_label.is_explore_hidden
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Field Label: lookml_fields.field_label
      Field Name: lookml_fields.field_name
    row: 4
    col: 8
    width: 8
    height: 9
  - title: "% Unused / total LookML fields (of all time)"
    name: "% Unused / total LookML fields (of all time)"
    model: looker_hackathon_2024
    explore: lookml_fields
    type: single_value
    fields: [lookml_fields.count, unused_fields.is_unused_field]
    pivots: [unused_fields.is_unused_field]
    filters:
      field_usage.count: ''
      unused_fields.is_unused_field: ''
    sorts: [unused_fields.is_unused_field]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - _kind_hint: measure
      _type_hint: number
      args:
      - lookml_fields.count
      based_on: lookml_fields.count
      calculation_type: percent_of_row
      category: table_calculation
      label: Percent of row
      source_field: lookml_fields.count
      table_calculation: percent_of_row
      value_format:
      value_format_name: percent_0
    query_timezone: Asia/Saigon
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    defaults_version: 1
    hidden_pivots:
      'No':
        measure_names:
        - percent_of_row
    hidden_fields: [lookml_fields.count]
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
      Is Explore Hidden (Yes / No): explore_label.is_explore_hidden
      Is Field Hidden (Yes / No): lookml_fields.is_field_hidden
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Field Label: lookml_fields.field_label
      Field Name: lookml_fields.field_name
    row: 0
    col: 12
    width: 12
    height: 4
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
  - name: Field Name
    title: Field Name
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
    field: lookml_fields.field_name
  - name: Field Label
    title: Field Label
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
    field: lookml_fields.field_label
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
