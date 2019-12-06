view: order_facts {
  derived_table: {
    sql: SELECT
      order_items.order_id,
      order_items.user_id,
      Count(*) AS order_items_count,
      sum(sale_price) as order_total
      FROM order_items
      Group BY 1, 2
      Order By 3 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}.order_items_count ;;
  }

  dimension: order_total {
    type: number
    sql: ${TABLE}.order_total ;;
  }

  set: detail {
    fields: [order_id, user_id, order_items_count, order_total]
  }
}
