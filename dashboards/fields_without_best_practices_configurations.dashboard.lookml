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
    fields: [lookml_fields.explore_name, lookml_fields.view_name, lookml_fields.field_name]
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
    row: 5
    col: 12
    width: 12
    height: 9
  - title: Fields that have both Group Item Label & Label
    name: Fields that have both Group Item Label & Label
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [lookml_fields.explore_name, lookml_fields.view_label, lookml_fields.field_name]
    filters:
      lookml_fields.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_label: "-NULL"
      lookml_fields.field_group_label: "-NULL"
    sorts: [lookml_fields.explore_name]
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
    row: 14
    col: 0
    width: 12
    height: 8
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
    row: 14
    col: 12
    width: 12
    height: 8
  - title: Fields that do not specify types
    name: Fields that do not specify types
    model: looker_hackathon_2024
    explore: lookml_fields
    type: looker_grid
    fields: [explore_label.explore_name, lookml_fields.view_name, lookml_fields.field_name]
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
    show_totals: false
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      lookml_fields.count: Fields without Data Type
    series_column_widths:
      lookml_fields.field_name: 200
    series_cell_visualizations:
      lookml_fields.count:
        is_active: false
        value_display: true
    conditional_formatting: [{type: not null, value: !!null '', background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: []}]
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
    row: 5
    col: 0
    width: 12
    height: 9
  - title: Total fields that do not have Descriptions
    name: Total fields that do not have Descriptions
    model: looker_hackathon_2024
    explore: lookml_fields
    type: single_value
    fields: [lookml_fields.count]
    filters:
      lookml_fields.project_name: ''
      field_usage.query_completed_date: ''
      explore_label.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_description: 'NULL'
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    custom_color: ''
    single_value_title: Fields that do not have Descriptions
    conditional_formatting: [{type: greater than, value: 0, background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 1, background_color: "#9dd68d",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      lookml_fields.count: Fields without Data Type
    series_column_widths:
      lookml_fields.count: 100
    series_cell_visualizations:
      lookml_fields.count:
        is_active: false
        value_display: true
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
      Field Name: lookml_fields.field_name
      View Name: lookml_fields.view_name
    row: 0
    col: 6
    width: 6
    height: 5
  - title: Total fields that do not specify types
    name: Total fields that do not specify types
    model: looker_hackathon_2024
    explore: lookml_fields
    type: single_value
    fields: [lookml_fields.count]
    filters:
      lookml_fields.project_name: ''
      field_usage.query_completed_date: ''
      explore_label.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_data_type: 'NULL'
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    custom_color: ''
    single_value_title: Fields that do not specify Data Types
    conditional_formatting: [{type: greater than, value: 0, background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 1, background_color: "#9dd68d",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      lookml_fields.count: Fields without Data Type
    series_column_widths:
      lookml_fields.count: 100
    series_cell_visualizations:
      lookml_fields.count:
        is_active: false
        value_display: true
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
      Field Name: lookml_fields.field_name
      View Name: lookml_fields.view_name
    row: 0
    col: 0
    width: 6
    height: 5
  - title: Total fields that have both Group Label and Group item Label
    name: Total fields that have both Group Label and Group item Label
    model: looker_hackathon_2024
    explore: lookml_fields
    type: single_value
    fields: [lookml_fields.count]
    filters:
      lookml_fields.project_name: ''
      field_usage.query_completed_date: ''
      explore_label.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_group_label: "-NULL"
      lookml_fields.field_group_item_label: "-NULL"
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    custom_color: ''
    single_value_title: Fields that have both Group Label and Group Item Label
    conditional_formatting: [{type: greater than, value: 0, background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 1, background_color: "#9dd68d",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      lookml_fields.count: Fields without Data Type
    series_column_widths:
      lookml_fields.count: 100
    series_cell_visualizations:
      lookml_fields.count:
        is_active: false
        value_display: true
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
      Field Name: lookml_fields.field_name
      View Name: lookml_fields.view_name
    row: 0
    col: 12
    width: 6
    height: 5
  - title: Total fields that have Group Item Label but not Group Label
    name: Total fields that have Group Item Label but not Group Label
    model: looker_hackathon_2024
    explore: lookml_fields
    type: single_value
    fields: [lookml_fields.count]
    filters:
      lookml_fields.project_name: ''
      field_usage.query_completed_date: ''
      explore_label.project_name: ''
      explore_label.explore_name: ''
      lookml_fields.field_group_label: 'NULL'
      lookml_fields.field_group_item_label: "-NULL"
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Asia/Saigon
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    custom_color: ''
    single_value_title: Fields that have Group Item Label but not Group Label
    conditional_formatting: [{type: greater than, value: 0, background_color: "#d6bebe",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 1, background_color: "#9dd68d",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: '14'
    rows_font_size: '16'
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      lookml_fields.count: Fields without Data Type
    series_column_widths:
      lookml_fields.count: 100
    series_cell_visualizations:
      lookml_fields.count:
        is_active: false
        value_display: true
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
      Field Name: lookml_fields.field_name
      View Name: lookml_fields.view_name
    row: 0
    col: 18
    width: 6
    height: 5
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
