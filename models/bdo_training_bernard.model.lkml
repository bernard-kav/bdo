connection: "events_ecommerce"





# include all the views

include: "/views/**/*.view"

explore: users {
  access_filter: {
    field: users.state
    user_attribute: state
  }
}

datagroup: midnight {
  sql_trigger: SELECT current_date;;
  max_cache_age: "24 hours"
}

datagroup: order_items {
  sql_trigger: SELECT MAX(created_at) FROM order_items;;
  max_cache_age: "4 hours"
}

access_grant: inventory {
  user_attribute: accessible_departments
  allowed_values: ["Inventory"]
}

access_grant: is_pii_viewer {
  user_attribute: is_pii_viewer
  allowed_values: ["No"]
}

persist_with: midnight

explore: distribution_centers {}

explore: etl_jobs {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
persist_for: "1 hour"
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: distribution_centers {
    required_access_grants: [inventory]
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one

  }

}


explore: order_items {

  access_filter: {
    field: products.brand
    user_attribute: brand
  }
  persist_with: order_items
view_label: "Orders"
description: "Information on Orders"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: distribution_centers {
    required_access_grants: [inventory]
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
  join: order_facts {
    type: left_outer
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
    relationship: many_to_one
  }
  join: user_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_facts.user_id} ;;
    relationship: many_to_one
}

}



explore: products {

  join: distribution_centers {

    type: left_outer

    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;

    relationship: many_to_one

  }

}
