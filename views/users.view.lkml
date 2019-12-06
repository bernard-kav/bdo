include: "geography.view.lkml"
view: users {
  extends: [geography]
  sql_table_name: public.users ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: hidden_traffic_source_filter {
    hidden: yes
    type: yesno
    sql: {% condition incoming_traffic_source %} ${traffic_source} {% endcondition %} ;;
  }

  filter: incoming_traffic_source {
    default_value: "Email"
    type: string
    suggest_dimension: users.traffic_source
    suggest_explore: users
  }

  measure: count_traffic_source {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: hidden_traffic_source_filter
      value: "Yes"
    }
  }


  dimension: name {
    required_access_grants: [is_pii_viewer]
    type: string
    sql: ${first_name} || ' ' ||${last_name};;
  }

  dimension: days_since_user_signup {
    type: duration_day
    sql_start: ${created_raw} ;;
    sql_end: getdate() ;;
  }

  dimension: months_since_user_signup {
    type: duration_month
    sql_start: ${created_raw} ;;
    sql_end: getdate() ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_user_signup} <= 90 ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    tiers: [0, 30, 90, 180, 360, 720]
    sql: ${days_since_user_signup} ;;
    style: integer
  }

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source} = "Email" ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql: ${age} ;;
    style: integer
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
#     required_access_grants: [is_pii_viewer]
    type: string
    sql: ${TABLE}.email ;;
    link: {
      label: "Category Detail Dashboard"
      url: "https://teach.corp.looker.com/dashboards/1813?Email={{ value | encode_uri }}"
    }
  }

  dimension: first_name {
    required_access_grants: [is_pii_viewer]
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    required_access_grants: [is_pii_viewer]
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: traffic_source {
    description: "Origin of customer to site"
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    group_label: "Location"
    map_layer_name: us_zipcode_tabulation_areas
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }

  measure: count_female_users {
    type: count
    filters: {
      field: gender
      value: "Female"
    }
  }

  measure: percentage_female_users{
    type: number
    sql: 1.0*${count_female_users}/NULLIF(${count},0) ;;
    value_format_name: percent_0
  }
}
