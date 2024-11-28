view: parsed_query {
  fields_hidden_by_default: yes
  derived_table: {
    # refresh PDT at 05:15 AM UTC+7 every Monday (prod pipeline runs at 05:00 AM UTC+7) -- ref https://www.googlecloudcommunity.com/gc/Technical-Tips-Tricks/PDT-trigger-value-at-a-specific-time-and-day-of-week-once-a-week/ta-p/588208
    # Can not cluster this PDT as Looker requires a partition key in conjunction with clustering keys. However Bigquery doesn't allow partition on string fields, which are all this PDT got
    sql_trigger_value:
        select floor(((timestamp_diff(timestamp_add(current_timestamp(),interval 7 hour),'1970-01-01 00:00:00',second)) - 60*60*(24*4 + 5.25))/(60*60*(24*7))) ;;
    # partition_keys: []
    # cluster_keys: ["model", "explore"]
      sql:
      CREATE TEMPORARY FUNCTION extract_keys(infoo STRING)
      RETURNS Array<String>
      LANGUAGE js AS """
            blah = [];
            function processKey(node, parent) {
              if (parent !== '') {parent += '.'};
              Object.keys(node).forEach(function(key) {
                value = node[key].toString();
                if (value !== '[object Object]') {
                  blah.push(parent+key)
                } else {
                  processKey(node[key], parent + key);
                };
              });
            };

        try {
        x = JSON.parse(infoo);
        processKey(x,'');
        return blah;
        } catch (e) { return null }

        """
        OPTIONS ();

        CREATE TEMPORARY FUNCTION extract_keys(infoo JSON)
        RETURNS ARRAY<STRING>
        LANGUAGE js AS """
        var blah = [];

        function processKey(node, parent) {
        if (parent !== '') { parent += '.'; }
        Object.keys(node).forEach(function(key) {
        var value = node[key].toString();
        if (value !== '[object Object]') {
        blah.push(parent + key);
        } else {
        processKey(node[key], parent + key);
        }
        });
        }

        try {
        processKey(infoo, '');
        return blah;
        } catch (e) {
        return null;
        }
        """
        OPTIONS ();

        with source as
        (
        select
        id as query_id,
        model,
        view as explore,
        json_extract_array(fields) as fields,
        extract_keys(filters) as filters,
        parse_json(dynamic_fields) as dynamic_fields
        from `joon-sandbox.looker_hackathon.query`
        ),

        pjson_fields as (
        select
        query_id,
        model,
        explore,
        REGEXP_REPLACE((REGEXP_EXTRACT(parsed_fields, r'^.*\.')), '[."]', '') as view,
        REGEXP_REPLACE(REGEXP_EXTRACT(parsed_fields, r'\..*'), '[."]', '') as field,
        "fields" as field_type
        from source, unnest(fields) as parsed_fields
        ),

        pjson_filters_fields as (
        select
        query_id,
        model,
        explore,
        REGEXP_REPLACE((REGEXP_EXTRACT(parsed_filters, r'^.*\.')), '[."]', '') as view,
        REGEXP_REPLACE(REGEXP_EXTRACT(parsed_filters, r'\..*'), '[."]', '') as field,
        "filters" as field_type
        from source, unnest(filters) as parsed_filters
        ),

        flatten_dynamic_fields as (
        select
        query_id,
        model,
        explore,
        --common fields
        json_value(df_json.category) as category,
        json_value(df_json._kind_hint) as kind_hint,
        -- table calculation & dimension
        json_value(df_json.expression) as expression,
        -- table calculation & measure
        json_value(df_json.based_on) as based_on,
        -- dimension
        JSON_VALUE_ARRAY(df_json.args)[0] as args,
        -- measure
        JSON_EXTRACT(df_json, '$.filters') as filters
        from source, unnest(json_query_array(dynamic_fields)) as df_json
        where dynamic_fields is not null
        ),

        extr as (
        select  query_id,
        model,
        explore,
        case
        when coalesce(category, kind_hint)  = 'table_calculation' then 'table calculation'
        when coalesce(category, kind_hint) = 'measure' then 'custom measure'
        when coalesce(category, kind_hint) = 'dimension' then 'custom dimension'
        else null
        end as field_type,
        regexp_extract_all(expression, r'\$\{[a-zA-Z0-9_]*\.[a-zA-Z0-9_]*\}') as inputs_expression,
        regexp_extract_all(based_on, r'[a-zA-Z0-9_]*\.[a-zA-Z0-9_]*') as inputs_based_on,
        regexp_extract_all(args, r'[a-zA-Z0-9_]*\.[a-zA-Z0-9_]*') as inputs_args,
        extract_keys(filters) as inputs_filters
        from flatten_dynamic_fields
        ),

        expression_unnest as (
        select
        query_id,
        model,
        explore,
        replace(replace(replace(split(unnest_fields, '.')[0], '$', ''), '}', ''), '{', '') as view,
        replace(replace(replace(split(unnest_fields, '.')[1], '$', ''), '}', ''), '{', '') as field,
        field_type
        from extr, unnest(inputs_expression) as unnest_fields
        ),

        basedon_unnest as (
        select
        query_id,
        model,
        explore,
        split(unnest_fields, '.')[0] as view,
        split(unnest_fields, '.')[1] as field,
        field_type
        from extr, unnest(inputs_based_on) as unnest_fields
        ),

        args_unnest as (
        select
        query_id,
        model,
        explore,
        split(unnest_fields, '.')[0] as view,
        split(unnest_fields, '.')[1] as field,
        field_type
        from extr, unnest(inputs_args) as unnest_fields
        ),

        filters_unnest as (
        select
        query_id,
        model,
        explore,
        split(unnest_fields, '.')[0] as view,
        split(unnest_fields, '.')[1] as field,
        "custom filters" as field_type
        from extr, unnest(inputs_filters) as unnest_fields
        where unnest_fields like '%.%'
        ),

        final as (
        select * from pjson_fields where field is not null
        union distinct
        select * from pjson_filters_fields where field is not null
        union distinct
        select * from expression_unnest
        union distinct
        select * from basedon_unnest
        union distinct
        select * from args_unnest
        union distinct
        select * from filters_unnest
        )

        select *, generate_uuid() AS id
        from final
        ;;
    }

    dimension: id {
      primary_key: yes
      type: string
      description: "Primary key of the table"
      sql: ${TABLE}.id ;;
    }

    dimension: query_id {
      type: number
      description: "ID of the query"
      sql: ${TABLE}.query_id ;;
    }

    dimension: model {
      type: string
      description: "Model name"
      sql: ${TABLE}.model ;;
      suggest_dimension: lookml_fields.model_name
    }

    dimension: explore {
      type: string
      description: "Explore name"
      sql: ${TABLE}.explore ;;
    }

    dimension: view {
      type: string
      description: "View name"
      sql: ${TABLE}.view ;;
    }

    dimension: field {
      type: string
      description: "Field name"
      sql: ${TABLE}.field ;;
    }

    dimension: field_type_in_query {
      group_label: "Fields"
      hidden: no
      type: string
      description: "Whether a field is used in the main query, or in the filter, or in the custom dimension/ measure/ filter or in table calculation"
      sql: ${TABLE}.field_type ;;
    }

  }
