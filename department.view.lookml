- view: department
  sql_table_name: department
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension_group: added
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.added_date

  - dimension: clients
    hidden: true
    type: yesno
    sql: ${TABLE}.clients

  - dimension: files
    hidden: true
    type: number
    sql: ${TABLE}.files

  - dimension_group: last_updated
    hidden: true
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.last_updated

  - dimension: messages
    hidden: true
    type: number
    sql: ${TABLE}.messages

  - dimension: name
    type: string
    sql: ${TABLE}.name

  - dimension: ref_agency
    hidden: true
    type: number
    sql: ${TABLE}.ref_agency

  - dimension: ref_user_updated
    hidden: true
    type: number
    sql: ${TABLE}.ref_user_updated

  - dimension: services
    hidden: true
    type: number
    sql: ${TABLE}.services

  - measure: count
    type: count
    drill_fields: [id, name]

