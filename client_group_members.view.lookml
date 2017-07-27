- view: client_group_members
  fields:

  - dimension: id
    primary_key: true
    hidden: true
    type: int
    sql: ${TABLE}.id

  - dimension_group: end
    type: time
    hidden: true
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.end_date

  - dimension: ref_client
    type: int
    hidden: true
    sql: ${TABLE}.ref_client

  - dimension: ref_group
    label: 'Global Household ID (Profile Household)'
    type: int
    sql: ${TABLE}.ref_group

  - dimension: ref_type
    hidden: true
    type: int
    sql: ${TABLE}.ref_type

  - dimension_group: start
    type: time
    timeframes: [date, week, month]
    hidden: true
    convert_tz: false
    sql: ${TABLE}.start_date
    
  - measure: count
    label: 'Number of Global Household IDs'
    description:  'Distinct count of Global Household IDs'
    type: count_distinct
    drill_fields: detail*
    sql: ${TABLE}.ref_group


