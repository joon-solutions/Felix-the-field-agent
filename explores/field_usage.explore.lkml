include: "/views/refined/*.refined.view"
include: "/views/*.view"
include: "/views/derived_tables/*.derived.view"

explore: lookml_fields {
  label: "Field Usage"
  description: "Details about LookML fields and the number of times they have been queried by any source"
  always_filter: {
    filters: [lookml_fields.project_name: "", field_usage.query_completed_date: ""]
  }

  join: parsed_query {
    view_label: "LookML fields"
    sql_on: ${lookml_fields.field_name} = ${parsed_query.field}
            and ${lookml_fields.view_name} = ${parsed_query.view}
            and ${lookml_fields.explore_name} = ${parsed_query.explore}
            ;;
    relationship: one_to_many
    type: left_outer
  }

  join: explore_label {
    sql_on: ${lookml_fields.explore_name} = ${explore_label.explore_name} and ${lookml_fields.model_name} = ${explore_label.model_name} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: user {
    sql_on: ${field_usage.user_id} = ${user.id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: field_usage {
    sql_on: ${parsed_query.query_id} = ${field_usage.query_id} ;;
    relationship: many_to_many
    type: left_outer
  }

  join: dashboard {
    sql_on: (CASE WHEN REGEXP_CONTAINS ( ${field_usage.dashboard_id}, '^[0-9]+$')
          THEN CAST( ${field_usage.dashboard_id} AS INT64)
          ELSE 0
          END) =  ${dashboard.id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: look {
    sql_on: ${field_usage.look_id} = ${look.id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: user_facts {
    sql_on: ${user.id} = ${user_facts.user_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: user_email {
    sql_on: ${user.email} = ${user_email.email} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: user_facts_role {
    sql_on: ${user.id} = ${user_facts_role.user_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: role {
    sql_on: ${user_facts_role.role_id} = ${role.id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: group_user {
    sql_on: ${user.id} = ${group_user.user_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: group {
    sql_on: ${group_user.group_id} = ${group.id} ;;
    relationship: many_to_one
    type: left_outer
  }

}
