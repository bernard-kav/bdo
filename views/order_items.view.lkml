view: order_items {
  sql_table_name: public.order_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: dynamic_timeframe {
    type: unquoted
    allowed_value: {
      label: "Date"
      value: "date"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
  }

  dimension: dynamic {
    type: string
    sql: {% if dynamic_timeframe._parameter_value == 'date' %}
          ${created_date}
          {% elsif dynamic_timeframe._parameter_value == 'week' %}
          ${created_week}
          {% else %}
          ${created_month}
          {% endif %}
          ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      hour_of_day,
      week,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
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
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: profit {
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  dimension: shipping_days {
    type: number
    sql: datediff(day, ${shipped_date}, ${delivered_date}) ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: number_of_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

   measure: total_revenue {
     type: sum
      sql: ${sale_price} ;;
      value_format_name: usd
   }

  measure: average_revenue {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_new_users {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.is_new_customer
      value: "Yes"
    }
  }

  measure: total_profit {
    type: sum
    sql: ${profit} ;;
    value_format_name: usd
  }

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: {
      field: users.traffic_source
      value: "Email"
    }
  }

  measure: percentage_of_sales_email {
    type: number
    value_format_name: percent_0
    sql: 1.0*${total_sales_email_users}/nullif(${total_revenue},0) ;;
    drill_fields: [users.country, user.state, average_user_spend]
  }

  measure: average_user_spend {
    type: number
    sql: ${total_revenue}/nullif(${users.count},0) ;;
    value_format_name: usd
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.id,
      inventory_items.product_name,
      users.id,
      users.last_name,
      users.first_name
    ]
  }
}
