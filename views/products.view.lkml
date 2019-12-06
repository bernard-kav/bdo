view: products {
  sql_table_name: public.products ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: category_to_compare{
    type: string
    suggest_explore: inventory_items
    suggest_dimension: products.category
  }

  dimension: category_comparator {
    type: string
    sql:  CASE
          WHEN {% condition category_to_compare %} ${category} {% endcondition %}
          THEN ${category}
          ELSE 'All Other Categories'
          END;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Google"
      url: "http://www.Google.com/searchq={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
