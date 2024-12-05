---
- dashboard: impact_analysis_of_field_usage
  title: Impact Analysis of Field Usage
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: BSZaSu0keZiPoHqCCi466R
  elements:
  - title: Field metadata
    name: Field metadata
    model: felix_the_field_agent
    explore: lookml_fields
    type: looker_single_record
    fields: [lookml_fields.field_name, lookml_fields.field_label, lookml_fields.field_description,
      lookml_fields.field_type, explore_label.explore_name, explore_label.explore_label,
      explore_label.project_name, field_usage.count, lookml_fields.field_filters,
      lookml_fields.field_group_label, lookml_fields.field_group_item_label, explore_label.model_name,
      explore_label.is_explore_hidden, dashboard.count, look.count]
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
      Field Type: lookml_fields.field_type
      Field Name: lookml_fields.field_name
    row: 2
    col: 0
    width: 8
    height: 11
  - title: List of dashboards using a specific field
    name: List of dashboards using a specific field
    model: felix_the_field_agent
    explore: lookml_fields
    type: table
    fields: [field_usage.count, dashboard.title, dashboard.link]
    filters:
      parsed_query.field_type_in_query: ''
      look.id: ''
      dashboard.id: NOT NULL
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
      Field Type: lookml_fields.field_type
      Field Name: lookml_fields.field_name
    row: 2
    col: 8
    width: 8
    height: 11
  - title: List of looks using a specific field
    name: List of looks using a specific field
    model: felix_the_field_agent
    explore: lookml_fields
    type: table
    fields: [field_usage.count, look.title, look.link]
    filters:
      parsed_query.field_type_in_query: ''
      look.id: NOT NULL
      dashboard.id: ''
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
      Field Type: lookml_fields.field_type
      Field Name: lookml_fields.field_name
    row: 2
    col: 16
    width: 8
    height: 11
  - name: " (Copy)"
    type: text
    title_text: " (Copy)"
    body_text: '[{"type":"h1","children":[{"text":"Analysis of a specific dashboard/
      look"}],"align":"center"},{"type":"p","children":[{"text":"Please use "},{"text":"Dashboard
      Title","code":true},{"text":" or "},{"text":"Look Title","code":true},{"text":"
      filter"}],"align":"center","id":"l1n0u"}]'
    rich_content_json: '{"format":"slate"}'
    row: 13
    col: 0
    width: 24
    height: 2
  - name: ''
    type: text
    title_text: ''
    body_text: '[{"type":"h1","children":[{"text":"Analysis of a specific field"}],"align":"center"},{"type":"p","children":[{"text":"Please
      use "},{"text":"Field Name","code":true},{"text":" filter"}],"id":"nw97t","align":"center"}]'
    rich_content_json: '{"format":"slate"}'
    row: 0
    col: 0
    width: 24
    height: 2
  - title: Number of fields used by dashboards
    name: Number of fields used by dashboards
    model: felix_the_field_agent
    explore: lookml_fields
    type: looker_bar
    fields: [dashboard.title, lookml_fields.count]
    filters:
      parsed_query.field_type_in_query: ''
      look.id: ''
      dashboard.id: NOT NULL
      lookml_fields.field_name: ''
    sorts: [lookml_fields.count desc 0]
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
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Dashboard Title: dashboard.title
    row: 15
    col: 0
    width: 12
    height: 7
  - title: Field usage of a specific dashboard/ look
    name: Field usage of a specific dashboard/ look
    model: felix_the_field_agent
    explore: lookml_fields
    type: table
    fields: [dashboard.title, dashboard.link, look.title, look.link, lookml_fields.field_name,
      lookml_fields.field_label, lookml_fields.view_name, lookml_fields.view_label,
      lookml_fields.explore_name, lookml_fields.model_name, lookml_fields.project_name,
      lookml_fields.field_description, field_usage.count]
    filters:
      parsed_query.field_type_in_query: ''
      look.id: ''
      dashboard.id: NOT NULL
      lookml_fields.field_name: ''
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
      Field Type: lookml_fields.field_type
      Dashboard Title: dashboard.title
      Look Title: look.title
    row: 22
    col: 0
    width: 24
    height: 13
  - title: Number of fields used by looks
    name: Number of fields used by looks
    model: felix_the_field_agent
    explore: lookml_fields
    type: looker_bar
    fields: [lookml_fields.count, look.title]
    filters:
      parsed_query.field_type_in_query: ''
      look.id: NOT NULL
      lookml_fields.field_name: ''
    sorts: [lookml_fields.count desc 0]
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
    listen:
      Project Name: lookml_fields.project_name
      Query Completed Date: field_usage.query_completed_date
      Explore Name: lookml_fields.explore_name
      View Label: lookml_fields.view_label
      Field Type: lookml_fields.field_type
      Look Title: look.title
    row: 15
    col: 12
    width: 12
    height: 7
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
    model: felix_the_field_agent
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
    model: felix_the_field_agent
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
    model: felix_the_field_agent
    explore: lookml_fields
    listens_to_filters: []
    field: lookml_fields.view_label
  - name: Field Name
    title: Field Name
    type: field_filter
    default_value: date
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: felix_the_field_agent
    explore: lookml_fields
    listens_to_filters: []
    field: lookml_fields.field_name
  - name: Query Completed Date
    title: Query Completed Date
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: felix_the_field_agent
    explore: lookml_fields
    listens_to_filters: []
    field: field_usage.query_completed_date
  - name: Field Type
    title: Field Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: felix_the_field_agent
    explore: lookml_fields
    listens_to_filters: []
    field: lookml_fields.field_type
  - name: Dashboard Title
    title: Dashboard Title
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: felix_the_field_agent
    explore: lookml_fields
    listens_to_filters: []
    field: dashboard.title
  - name: Look Title
    title: Look Title
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: felix_the_field_agent
    explore: lookml_fields
    listens_to_filters: []
    field: look.title
