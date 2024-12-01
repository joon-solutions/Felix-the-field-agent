view: lookml_fields {
  label: "LookML fields"
  derived_table: {
    # refresh PDT at 05:15 AM UTC+7 every Monday (prod pipeline runs at 05:00 AM UTC+7) -- ref https://www.googlecloudcommunity.com/gc/Technical-Tips-Tricks/PDT-trigger-value-at-a-specific-time-and-day-of-week-once-a-week/ta-p/588208
    # Can not cluster this PDT as Looker requires a partition key in conjunction with clustering keys. However Bigquery doesn't allow partition on string fields, which are all this PDT got
    sql_trigger_value:
        select floor(((timestamp_diff(timestamp_add(current_timestamp(),interval 7 hour),'1970-01-01 00:00:00',second)) - 60*60*(24*4 + 5.25))/(60*60*(24*7))) ;;
    sql:
        select
            * except (view_name, explore_name),
            replace(
                    case  when view_name_param is not null and join_param is null then view_name_param  -- if base view has view_name param then view_name takes value from view_name param
                          when join_from_param is not null then join_param -- if join view has from param then view_name takes value from join param
                          else view_name
                    end,
                    '+', '' -- clean refinement's names
                  ) as view_name,
            replace(explore_name, '+', '') as explore_name, -- clean refinement's names
            row_number() over(partition by project, replace(explore_name, '+', ''), field_name, replace(view_name, '+', ''), field_type, field_group_label , field_label, field_data_type, is_field_hidden, field_filters) as rnk
        from  @{SCHEMA_NAME}.lookml_fields as fields
        qualify rnk = 1 -- deduplicate data, details see this data test doc https://docs.google.com/document/d/1SdGWYGbRo28ZPlc_OwSYC-KzXXUxFe8aHUn5tuvY7Ug/edit
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
    group_label: " Fields"
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
