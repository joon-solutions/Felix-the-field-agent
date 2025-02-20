include: "/views/refined/*.refined.view"
include: "/views/*.view"

view: field_usage {
  view_label: "Field Usage"
  extends: [history]
  derived_table: {
    sql:
      select *
      from  @{GCP_PROJECT}.@{DATASET}.history
      where completed_time >= coalesce({% date_start query_completed_date %}, cast('1970-01-01' as timestamp format 'YYYY-MM-DD')) and completed_time <= coalesce({% date_end query_completed_date %}, current_timestamp())
            {% if field_usage.filter_issuer_source._is_filtered %}
               and issuer_source in ({{ _filters['field_usage.filter_issuer_source'] | split:"," | sql_quote | join:"," }})
            {% endif %}

      {% if field_usage.filter_source._is_filtered %}
      and source in ({{ _filters['field_usage.filter_source'] | split:"," | sql_quote | join:"," }})
      {% endif %}

      {% if field_usage.filter_status._is_filtered %}
      and status in ({{ _filters['field_usage.filter_status'] | split:"," | sql_quote | join:"," }})
      {% endif %}
      ;;
  }

  fields_hidden_by_default: yes

  filter: query_completed_date {
    type: date
    convert_tz: no
    hidden: no
    description: "When an event in 'History' was completed. Each event is linked to a query in Looker."
  }

  filter: filter_issuer_source {
    hidden: no
    suggest_dimension: issuer_source
    description: "The source of a query, bucketed. Buckets are the API, users themselves, Action Hub, or automated system activities (PDTs and schedules)."
  }

  filter: filter_source {
    hidden: no
    suggest_dimension: source
    description: "The source of a query, bucketed. Buckets are the API, users themselves, Action Hub, or automated system activities (PDTs and schedules)."
  }

  filter: filter_status {
    hidden: no
    suggest_dimension: status
    description: "The current status of the history event. For more information about errors, see the message field. The value cache_only_miss is a result when a query is run with the cache_only=TRUE option and the cache entry is not present."
  }

  measure: count {
    hidden: no
  }

  measure: first_query_date {
    hidden: no
  }

  measure: most_recent_query_date {
    hidden: no
  }

  measure: queries_under_10s {
    hidden: no
  }

  measure: query_run_count {
    hidden: no
  }

  measure: cache_result_query_count {
    hidden: no
  }

  measure: database_result_query_count {
    hidden: no
  }
}
