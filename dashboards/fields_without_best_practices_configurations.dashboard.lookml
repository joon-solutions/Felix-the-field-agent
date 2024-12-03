---
- dashboard: fields_that_do_not_follow_lookml_best_practices
  title: Fields that do not follow LookML best practices
  layout: newspaper
  description: ''
  preferred_slug: GFhhp88AIfk44GdSBVCx4e
  elements:
  - title: Fields that do not have descriptions
    name: Fields that do not have descriptions
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [lookml_fields.explore_name, lookml_fields.view_name, lookml_fields.field_name,
      lookml_fields.field_description, lookml_fields.count]
    filters:
      lookml_fields.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_description: 'NULL'
    sorts: [lookml_fields.explore_name]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields:
    - category: measure
      expression:
      label: Total Fields without Description
      value_format:
      value_format_name:
      based_on: lookml_fields.field_name
      _kind_hint: measure
      measure: total_fields_without_description
      type: count_distinct
      _type_hint: number
      filters:
        lookml_fields.field_description: 'NULL'
    query_timezone: Asia/Saigon
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: true
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
      total_fields_without_description: Fields without Description
      lookml_fields.count: Fields without Description
    series_column_widths:
      lookml_fields.count: 150
    series_cell_visualizations:
      lookml_fields.count:
        is_active: false
    conditional_formatting: [{type: equal to, value: 1, background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}]
    truncate_column_names: false
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Project Name: explore_label.project_name
      Query Completed Date: field_usage.query_completed_date
      View Name: lookml_fields.view_name
      Field Name: lookml_fields.field_name
    row: 9
    col: 12
    width: 12
    height: 8
  - title: Fields that have both Group Item Label & Label
    name: Fields that have both Group Item Label & Label
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [lookml_fields.explore_name, lookml_fields.view_label, lookml_fields.field_name,
      total_fields_with_both_group_item_label_and_label]
    filters:
      lookml_fields.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_label: "-NULL"
      lookml_fields.field_group_label: "-NULL"
    sorts: [total_fields_with_both_group_item_label_and_label desc 0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields:
    - category: measure
      expression:
      label: Total Fields with both Group Item Label and Label
      value_format:
      value_format_name:
      based_on: lookml_fields.field_name
      _kind_hint: measure
      measure: total_fields_with_both_group_item_label_and_label
      type: count_distinct
      _type_hint: number
      filters:
        lookml_fields.field_group_label: "-NULL"
        lookml_fields.field_label: "-NULL"
    query_timezone: Asia/Saigon
    show_view_names: true
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: true
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
      total_fields_with_both_group_item_label_and_label: Fields with both Group Item
        Label and Label
    series_column_widths:
      total_fields_with_both_group_item_label_and_label: 150
    series_cell_visualizations:
      total_fields_with_both_group_item_label_and_label:
        is_active: false
    conditional_formatting: [{type: equal to, value: 1, background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Project Name: explore_label.project_name
      Query Completed Date: field_usage.query_completed_date
      View Name: lookml_fields.view_name
      Field Name: lookml_fields.field_name
    row: 0
    col: 12
    width: 12
    height: 9
  - title: Fields that have Group Item Label but not Group Label
    name: Fields that have Group Item Label but not Group Label
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [lookml_fields.explore_name, lookml_fields.view_label, lookml_fields.field_name,
      lookml_fields.count]
    filters:
      lookml_fields.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_group_label: 'NULL'
      lookml_fields.field_group_item_label: "-NULL"
    sorts: [lookml_fields.count desc 0]
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", lookml_fields.explore_name, lookml_fields.view_label,
      lookml_fields.field_name, total_fields_with_group_item_label_but_not_group_label]
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      total_fields_with_group_item_label_but_not_group_label: Fields with Group Item
        Label but not Group Label
      lookml_fields.count: Fields with Group Item Label but not Group Label
    series_column_widths:
      lookml_fields.count: 150
    series_cell_visualizations:
      total_fields_with_both_group_item_label_and_label:
        is_active: false
    conditional_formatting: [{type: equal to, value: 1, background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Project Name: explore_label.project_name
      Query Completed Date: field_usage.query_completed_date
      View Name: lookml_fields.view_name
      Field Name: lookml_fields.field_name
    row: 9
    col: 0
    width: 12
    height: 8
  - title: Fields that do not specify types
    name: Fields that do not specify types
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [explore_label.explore_name, lookml_fields.view_name, lookml_fields.field_name,
      lookml_fields.count]
    filters:
      lookml_fields.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_data_type: 'NULL'
    sorts: [explore_label.explore_name]
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      lookml_fields.count: Fields without Data Type
    series_column_widths:
      lookml_fields.field_name: 200
      lookml_fields.count: 100
    series_cell_visualizations:
      lookml_fields.count:
        is_active: false
        value_display: true
    conditional_formatting: [{type: equal to, value: 1, background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    defaults_version: 1
    listen:
      Project Name: explore_label.project_name
      Query Completed Date: field_usage.query_completed_date
      View Name: lookml_fields.view_name
      Field Name: lookml_fields.field_name
    row: 0
    col: 0
    width: 12
    height: 9
  filters:
  - name: Project Name
    title: Project Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: explore_label.project_name
  - name: Query Completed Date
    title: Query Completed Date
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
    field: field_usage.query_completed_date
  - name: View Name
    title: View Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: lookml_fields.view_name
  - name: Field Name
    title: Field Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: looker_hackathon_2024
    explore: lookml_fields
    listens_to_filters: []
    field: lookml_fields.field_name
