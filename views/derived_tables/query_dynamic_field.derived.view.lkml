view: query_dynamic_field {
  derived_table: {
    sql:
      with source as (
        select  id as query_id,
                safe.parse_json(dynamic_fields) as dynamic_fields
        from @{GCP_PROJECT}.@{DATASET}.query
        where dynamic_fields is not null and dynamic_fields != '[]'
      ),

      pjson as (
      select
      query_id,
      --common fields
      json_value(df_json.description) as description,
      json_value(df_json.expression) as expression,
      json_value(df_json.label) as label,
      -- measure fields
      json_value(df_json.measure) as measure,
      json_value(df_json.type) as type,
      json_value(df_json.based_on) as based_on,
      -- dimension fields
      json_value(df_json.dimension) as dimension,
      json_value(df_json.calculation_type) as calculation_type,
      json_value(df_json.args) as args,
      -- table calculation fields
      json_value(df_json.table_calculation) as table_calculation
      from source, unnest(json_query_array(dynamic_fields)) as df_json
      ),

      final as (
        select
          query_id,
          case  when measure is not null then "custom measure"
          when dimension is not null then "custom dimension"
          when table_calculation is not null then "table_calculation"
          else null
          end as type,
          coalesce(measure, dimension, table_calculation) as name,
          description,
          label,
          case  when measure is not null then
          coalesce(type,'') ||
          ' ' ||
          coalesce(based_on,'') ||
          (case when coalesce(expression,'') != '' then ' custom filter ' else '' end) ||
          coalesce(expression,'')
          when dimension is not null then coalesce (expression, coalesce(calculation_type,'') || ' ' || coalesce(args,'')) --- there is no case where dimension & expression & calculation type keys coexist
          when table_calculation is not null then coalesce(expression, coalesce(calculation_type,'') || ' ' || coalesce(based_on,'')) --- there is no case where dimension & expression & calculation type keys coexist
          else null
          end as custom_logics,
          generate_uuid() AS id
        from pjson
      )

      select *,
        coalesce(name, '')
              || coalesce(description, '')
              || coalesce(label, '')
              || coalesce(custom_logics, '')
              as dynamic_field_identifier
      from final
      ;;
  }

  dimension: id {
    primary_key: yes
    type: string
    hidden: yes
    description: "Primary key of the table"
    sql: ${TABLE}.id ;;
  }

  dimension: query_id {
    type: number
    description: "ID of the query"
    sql: ${TABLE}.query_id ;;
  }

  dimension: type {
    type: string
    description: "Type of the dynamic fields. Possible values are custom measure, custom dimension, table_calculation"
    sql: ${TABLE}.type ;;
  }

  dimension: name {
    type: string
    description: "Name of the dynamic fields"
    sql: ${TABLE}.name ;;
  }

  dimension: description {
    type: string
    description: "Description of the dynamic fields"
    sql: ${TABLE}.description ;;
  }

  dimension: label {
    type: string
    description: "Label of the dynamic fields"
    sql: ${TABLE}.label ;;
  }

  dimension: custom_logics {
    type: string
    description: "Calculation logics of the custom fields"
    sql: ${TABLE}.custom_logics ;;
  }

  measure: count_dynamic_field {
    type: count_distinct
    description: "Count distinct dynamic fields used"
    sql: ${TABLE}.dynamic_field_identifier;;
  }

}
