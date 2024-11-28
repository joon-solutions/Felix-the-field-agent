
view: user_email {
  derived_table: {
    sql: SELECT
          user.email  AS email,
          logical_or(user_facts.is_embed) AS has_embed_account
      FROM `joon-sandbox.looker_hackathon.user`
           AS user
      LEFT JOIN `joon-sandbox.looker_hackathon.user_facts`
           AS user_facts ON user.id = user_facts.user_id
      GROUP BY
          1 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: email {
    primary_key: yes
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: has_embed_account {
    type: yesno
    description: "True if any user of an email address is embed"
    sql: ${TABLE}.has_embed_account ;;
  }

  set: detail {
    fields: [
      email,
      has_embed_account
    ]
  }
}
