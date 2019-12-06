view: geography {
extension: required

  dimension: city {
    group_label: "Geography Dimensions"
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: state {
    group_label: "Geography Dimensions"
    type: string
    sql: ${TABLE}.state ;;
  }
  dimension: country {
    group_label: "Geography Dimensions"
    type: string
    sql: ${TABLE}.country ;;
  }
  dimension: region {
    group_label: "Geography Dimensions"
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: latitude {
    group_label: "Geography Dimensions"
    type: string
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "Geography Dimensions"
    type: string
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    group_label: "Geography Dimensions"
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }
}
