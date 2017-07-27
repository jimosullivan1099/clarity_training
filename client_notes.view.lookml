- view: client_notes
  sql_table_name: client_notes
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

  - dimension_group: date
    label:  'Case Note '
    type: time
    timeframes: [date, week, month, year]
    convert_tz: false
    sql: ${TABLE}.date

  - dimension: deleted
    hidden: true
    type: yesno
    sql: ${TABLE}.deleted

  - dimension_group: last_updated
    hidden: true
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.last_updated

  - dimension: note
    type: string
    sql: replace(replace(replace(replace(replace(replace(replace(replace(${TABLE}.note,'<p>',''),'</p>',''),'<ul',''),'</ul>',''),'<li>',''),'</li>',''),'<strong>',''),'</strong>','')

  - dimension: private
    hidden: true
    type: yesno
    sql: ${TABLE}.private

  - dimension: ref_agency
    label: 'Agency'
    sql: |
          (Select name from agencies where id = ${TABLE}.ref_agency)
#   type: number
#  sql: ${TABLE}.ref_agency
    
  - dimension: ref_agency_deleted
    hidden: true
    type: number
    sql: ${TABLE}.ref_agency_deleted

  - dimension: ref_client
    hidden: true
    type: number
    sql: ${TABLE}.ref_client

  - dimension: ref_client_program_id
    hidden: true
    sql: ${TABLE}.ref_client_program


  - dimension: ref_client_program 
    label: 'Program'
    sql: |
          (Select name from programs where id = (select ref_program from client_programs where id = ${TABLE}.ref_client_program))

    
  - dimension: ref_user
    label:  'Staff'
    sql: fn_getUserNameById(${TABLE}.ref_user)

  - dimension: ref_user_updated
    hidden: true
    type: number
    sql: ${TABLE}.ref_user_updated

  - dimension: title
    type: string
    sql: ${TABLE}.title

  - dimension: tracking_hour
    type: number
    sql: ${TABLE}.tracking_hour

  - dimension: tracking_minute
    type: number
    sql: ${TABLE}.tracking_minute

  - measure: count
    type: count
    drill_fields: [id]

