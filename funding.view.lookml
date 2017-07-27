- view: funding
  sql_table_name: funding
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension_group: added
    hidden: true
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.added_date

  - dimension: amount
    label: 'Fund Amount'
    type: number
    sql: ${TABLE}.amount
    value_format_name: usd

  - dimension_group: last_updated
    hidden: true
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.last_updated

  - dimension: name
    label: 'Fund Name'
    type: string
    sql: ${TABLE}.name

  - dimension: ref_agency
    hidden: true
    type: number
    sql: ${TABLE}.ref_agency

  - dimension: ref_funding
    hidden: true
    type: number
    sql: ${TABLE}.ref_funding

  - dimension: ref_user_updated
    hidden: true
    type: number
    sql: ${TABLE}.ref_user_updated

  - dimension: status
    label: 'Fund Active'
    sql_case:
       Active: ${TABLE}.status = 1
       Inactive: ${TABLE}.status = 2

  - measure: count
    type: count
    drill_fields: [id, name]

