---
- dashboard: dynamic_field_analysis
  title: Dynamic Field Analysis
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: 4PtyogOIPEKHZs4sVQSUge
  elements:
  - title: Top 20 mostly used dynamic fields
    name: Top 20 mostly used dynamic fields
    model: felix_the_field_agent
    explore: query_metrics
    type: looker_grid
    fields: [query_dynamic_field.name, query_dynamic_field.type, query_dynamic_field.description,
      query_dynamic_field.custom_logics, history.count]
    filters:
      query_dynamic_field.name: "-NULL"
    sorts: [history.count desc]
    limit: 20
    column_limit: 50
    query_timezone: Asia/Saigon
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      query_dynamic_field.name: Field Name
      query_dynamic_field.type: Field Type
      query_dynamic_field.description: Field Description
      query_dynamic_field.custom_logics: Field Calculation Logics
      history.count: Number of queries
    series_cell_visualizations:
      history.count:
        is_active: true
    defaults_version: 1
    listen:
      Query's created time: query_metrics.created_at_time
      History run time: history.created_date
      Dashboard ID: dashboard.id
      Look ID: look.id
    row: 14
    col: 0
    width: 24
    height: 12
  - title: Dynamic fields usage in Dashboards
    name: Dynamic fields usage in Dashboards
    model: felix_the_field_agent
    explore: query_metrics
    type: looker_grid
    fields: [dashboard.title, dashboard.link, query_dynamic_field.count_dynamic_field]
    filters:
      query_dynamic_field.name: "-NULL"
      dashboard.title: "-NULL"
    sorts: [query_dynamic_field.count_dynamic_field desc]
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
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_column_widths:
      dashboard.link: 92
      dashboard.title: 383
    series_cell_visualizations:
      query_dynamic_field.count_dynamic_field:
        is_active: true
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Query's created time: query_metrics.created_at_time
      Dashboard ID: dashboard.id
    row: 8
    col: 0
    width: 13
    height: 6
  - title: Dynamic fields usage in Looks
    name: Dynamic fields usage in Looks
    model: felix_the_field_agent
    explore: query_metrics
    type: looker_grid
    fields: [query_dynamic_field.count_dynamic_field, look.title, look.link]
    filters:
      query_dynamic_field.name: "-NULL"
      look.title: "-NULL"
    sorts: [query_dynamic_field.count_dynamic_field desc 0]
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
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_pivots: {}
    minimum_column_width: 75
    series_column_widths:
      look.link: 109
    listen:
      Query's created time: query_metrics.created_at_time
      Look ID: look.id
    row: 8
    col: 13
    width: 11
    height: 6
  - title: Total Dynamic Fields Used
    name: Total Dynamic Fields Used
    model: felix_the_field_agent
    explore: query_metrics
    type: single_value
    fields: [history.count, query_dynamic_field.count_dynamic_field]
    filters:
      query_dynamic_field.name: "-NULL"
    sorts: [history.count desc]
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
    custom_color: "#3EB0D5"
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    listen:
      Query's created time: query_metrics.created_at_time
      Dashboard ID: dashboard.id
      Look ID: look.id
    row: 0
    col: 0
    width: 24
    height: 6
  - title: Number of Dashboards using Dynamic Fields
    name: Number of Dashboards using Dynamic Fields
    model: felix_the_field_agent
    explore: query_metrics
    type: single_value
    fields: [dashboard.count]
    filters:
      query_dynamic_field.name: "-NULL"
      dashboard.title: "-NULL"
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
    custom_color: ''
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      query_dynamic_field.count_dynamic_field:
        is_active: true
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Query's created time: query_metrics.created_at_time
      Dashboard ID: dashboard.id
    row: 6
    col: 0
    width: 13
    height: 2
  - title: Number of Looks using Dynamic Fields
    name: Number of Looks using Dynamic Fields
    model: felix_the_field_agent
    explore: query_metrics
    type: single_value
    fields: [look.count]
    filters:
      query_dynamic_field.name: "-NULL"
      look.title: "-NULL"
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
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Query's created time: query_metrics.created_at_time
      Look ID: look.id
    row: 6
    col: 13
    width: 11
    height: 2
  filters:
  - name: Query's created time
    title: Query's created time
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: felix_the_field_agent
    explore: query_metrics
    listens_to_filters: []
    field: query_metrics.created_at_time
  - name: History run time
    title: History run time
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: felix_the_field_agent
    explore: query_metrics
    listens_to_filters: []
    field: history.created_date
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
    model: felix_the_field_agent
    explore: query_metrics
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
    model: felix_the_field_agent
    explore: query_metrics
    listens_to_filters: []
    field: look.id
