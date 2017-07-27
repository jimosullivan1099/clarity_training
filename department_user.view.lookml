- view: department_user
  sql_table_name: department_user
  fields:

  - dimension: id
    hidden: true   
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension_group: added
    hidden: true
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.added_date

  - dimension_group: last_updated
    hidden: true
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.last_updated

  - dimension: ref_department
    hidden: true
    type: number
    sql: ${TABLE}.ref_department

  - dimension: ref_user
    hidden: true
    type: number
    sql: ${TABLE}.ref_user

  - dimension: ref_user_updated
    hidden: true
    type: number
    sql: ${TABLE}.ref_user_updated

  - measure: count
    type: count
    drill_fields: [id]

