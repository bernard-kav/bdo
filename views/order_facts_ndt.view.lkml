# If necessary, uncomment the line below to include explore_source.
# include: "bdo_training_bernard.model.lkml"
explore: order_facts_ndt {}
view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count { field: order_items.count }
      column: total_revenue {}
      derived_column: order_revenue_rank {
        sql: rank() over(order by total_revenue desc) ;;
      }
    }
  }

  dimension: order_revenue_rank {
    type: number
  }
  dimension: order_id {
    label: "Orders Order ID"
    type: number
  }
  dimension: count {
    label: "Order Items Count"
    type: number
  }
  dimension: total_revenue {
    label: "Orders Total Revenue"
    value_format: "$#,##0.00"
    type: number
  }
  measure: average_items {
    type: average
    sql: ${count} ;;
  }
}
