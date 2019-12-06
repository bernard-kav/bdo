# If necessary, uncomment the line below to include explore_source.
# include: "bdo_training_bernard.model.lkml"
explore: user_order_ndt {}
view: user_order_ndt {
  derived_table: {
    explore_source: order_items {
      column: number_of_orders {}
      column: total_revenue {}
      column: user_id {}
      derived_column: current_timestamp {
        sql: getdate() ;;
      }
    }
  }

  dimension_group: current_timestamp {
    type: time
  }
  dimension: number_of_orders {
    label: "Orders Number of Orders"
    type: number
  }
  dimension: total_revenue {
    label: "Orders Total Revenue"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: user_id {
    primary_key: yes
    label: "Orders User ID"
    type: number
  }
}
