include: "/explores/field_usage.explore.lkml"

view: unused_fields {
  derived_table: {
    explore_source: lookml_fields {
      column: view_name {}
      column: field_name {}
      column: explore_name {}
      column: count { field: field_usage.count }
    }
  }
  dimension: view_name {
    hidden: yes
    label: "LookML fields View Name"
    description: "The associated view's name"
  }
  dimension: field_name {
    hidden: yes
    label: "LookML fields Field Name"
    description: "The field's name."
  }
  dimension: explore_name {
    hidden: yes
    label: "LookML fields Explore Name"
    description: "The associated explore's name"
  }
  dimension: count {
    hidden: yes
    description: ""
    type: number
  }
  dimension: is_unused_field {
    description: "Is unused field (no history count all the time)?"
    type: yesno
    sql: ${count} = 0 ;;
  }
}
