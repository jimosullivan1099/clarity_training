- view: client_program_goals
  sql_table_name: client_program_goals
  fields:

  - dimension: id
    hidden: true
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension: date
    label:  'Date Achieved'
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.date

  - dimension: ref_agency
    hidden: true
    type: number
    sql: ${TABLE}.ref_agency

  - dimension: ref_client_program
    hidden: true
    type: number
    sql: ${TABLE}.ref_client_program

  - dimension: ref_goal
    hidden: true
    type: number
    sql: ${TABLE}.ref_goal

  - dimension: status
    sql_case:
       Achieved: ${TABLE}.status = 1
       Not Achieved: ${TABLE}.status = 0
       
  - dimension: goal_name
    sql: ${goals.name}


  - measure: count
    type: count
    drill_fields: [id]

