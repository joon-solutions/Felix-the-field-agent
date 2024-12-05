view: lookml_fields {
  label: "LookML fields"
  derived_table: {
    sql_trigger_value:
        select floor(((timestamp_diff(timestamp_add(current_timestamp(),interval 7 hour),'1970-01-01 00:00:00',second)) - 60*60*(24*4 + 5.25))/(60*60*(24*7))) ;;
    sql:
        select
            * except (view_name, explore_name),
            replace(view_name,'+', '' ) as view_name, -- clean refinement's names
            replace(explore_name, '+', '') as explore_name, -- clean refinement's names
            row_number() over(partition by project, replace(explore_name, '+', ''), field_name, replace(view_name, '+', ''), field_type, field_group_label , field_label, field_data_type, is_field_hidden, field_filters) as rnk
        from  @{SCHEMA_NAME}.lookml_fields as fields
        qualify rnk = 1
        ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: COALESCE(${TABLE}.project, '') || COALESCE(${TABLE}.explore_name, '') || COALESCE(${TABLE}.field_name, '') || COALESCE(${TABLE}.view_name, '') ||
      COALESCE(${TABLE}.field_type, '') || COALESCE(${TABLE}.field_group_label, '') || COALESCE(${TABLE}.field_label, '') || COALESCE(${TABLE}.field_data_type, '') ||
      COALESCE(CAST (${TABLE}.is_field_hidden AS STRING), '') || COALESCE(${TABLE}.field_type, '') || COALESCE(${TABLE}.field_filters, '') || COALESCE(${TABLE}.extends__all, '');;
  }

  dimension: model_name {
    #hidden: yes ### use model_name from Explore_Label view
    type: string
    description: "The associated model's name"
    sql: ${TABLE}.model_name ;;
  }

  dimension: explore_name {
    type: string
    description: "The associated explore's name"
    sql: ${TABLE}.explore_name ;;
  }

  dimension: view_name {
    type: string
    description: "The associated view's name"
    sql: ${TABLE}.view_name ;;
  }

  dimension: view_label {
    type: string
    description: "The associated view's label"
    sql: ${TABLE}.view_label ;;
  }

  dimension: project_name {
    type: string
    description: "The associated project's name"
    sql: ${TABLE}.project ;;
  }

  dimension: field_name {
    type: string
    group_label: "Fields"
    description: "The field's name."
    sql: ${TABLE}.field_name ;;
  }

  dimension: field_type {
    type: string
    description: "Whether a field is a Dimension or Measure"
    group_label: "Fields"
    sql: ${TABLE}.field_type ;;
  }

  dimension: field_label {
    type: string
    description: "The field's specified label"
    group_label: "Fields"
    sql: ${TABLE}.field_label ;;
  }

  dimension: field_group_label {
    type: string
    description: "The field's specified group label"
    group_label: "Fields"
    sql: ${TABLE}.field_group_label ;;
  }

  dimension: field_group_item_label {
    type: string
    description: "The field's specified group item label"
    group_label: "Fields"
    sql: ${TABLE}.field_group_item_label ;;
  }

  dimension: field_data_type {
    type: string
    description: "The field's data type"
    group_label: "Fields"
    sql: ${TABLE}.field_data_type ;;
  }

  dimension: field_description {
    type:  string
    description: "The field's description"
    group_label: "Fields"
    sql:  ${TABLE}.field_description ;;
  }

  dimension: is_field_hidden {
    type: yesno
    description: "Is the field hidden in explore?"
    group_label: "Fields"
    sql: ${TABLE}.is_field_hidden ;;
  }

  dimension: field_filters {
    type: string
    description: "An array of filters associated to the field"
    group_label: "Fields"
    sql: ${TABLE}.field_filters ;;
  }

  dimension: extends__all {
    hidden: yes
    type: string
    sql: ${TABLE}.extends__all ;;
  }

  measure: count {
    type: count
    drill_fields: [model_name, view_name, field_name]
  }
}
