- view: member_activity_logs
  label:  'Staff Activity Logs'
  sql_table_name: _logs
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension_group: date_in
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.date_in

  - dimension_group: date_out
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.date_out

  - dimension: error
    hidden: true
    type: string
    sql: ${TABLE}.error

  - dimension: host
    hidden: true
    type: string
    sql: ${TABLE}.host

  - dimension: ip
    hidden: true
    type: string
    sql: ${TABLE}.ip

  - dimension: msg
    hidden: true
    type: string
    sql: ${TABLE}.msg

  - dimension: ref_user
    hidden: true
    type: number
    sql: ${TABLE}.ref_user

  - dimension: sid
    hidden: true
    type: string
    sql: ${TABLE}.sid

  - dimension: type
    hidden: true
    type: string
    sql: ${TABLE}.type

  - measure: count
    type: count
    drill_fields: [id]

