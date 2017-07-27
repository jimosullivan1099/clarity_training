- view: referrals
  fields:

  - dimension: id
    primary_key: true
    type: int
    links:
    - label: Edit Referral
      url: https://{{ _access_filters["site.name"]] }}.clarityhs.com/referrals/modify/{{ value }}  
    sql: ${TABLE}.id

  - dimension_group: added
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.added_date

  - dimension_group: date
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.date

  - dimension: days_pending
    type: int
    sql: ${TABLE}.days_pending

  - dimension: deleted
    type: int
    sql: ${TABLE}.deleted

  - dimension: denied_message
    type: string
    sql: ${TABLE}.denied_message

  - dimension: denied_reason
    sql: fn_getPicklistValueName('referral_denied_reason',${TABLE}.denied_reason)    



  - dimension: in_progress
    type: int
    sql: ${TABLE}.in_progress

  - dimension_group: last_updated
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.last_updated

  - dimension: private
    type: int
    sql: ${TABLE}.private

  - dimension: queue
    type: int
    sql: ${TABLE}.queue
    


  - dimension: reassigned
    type: int
    sql: ${TABLE}.reassigned

  - dimension: referring_agency
    sql: ${referring_agencies.name}
    
  - dimension: ref_agency
    hidden: true
    sql: ${TABLE}.ref_agency

#   - dimension: ref_agency_deleted
#     type: int
#     sql: ${TABLE}.ref_agency_deleted

  - dimension: assessment_id
    type: int
    sql: ${TABLE}.ref_assessment

  - dimension: ref_client
    hidden: true
    type: int
    sql: ${TABLE}.ref_client
# 
#   - dimension: ref_navigator
#     type: int
#     sql: ${TABLE}.ref_navigator
# 
  - dimension: ref_opening
    type: int
    sql: ${TABLE}.ref_opening
# 
  - dimension: ref_program
    hidden: true
    type: int
    sql: ${TABLE}.ref_program

  - dimension: user
    sql: fn_getUserNameById(${TABLE}.ref_user)
    
# 
#   - dimension: ref_user_updated
#     type: int
#     sql: ${TABLE}.ref_user_updated

  - dimension: replaced_with
    type: int
    sql: ${TABLE}.replaced_with

  - dimension: status
    sql_case:
        Pending: ${TABLE}.status = 0
        Reassigned: ${TABLE}.status = 1
        Denied:  ${TABLE}.status = 2
        else: Unknown   
        
    
  - dimension: Currently_On_Queue
    type: string
    sql_case:
        Yes: ${TABLE}.queue= 1 and ${TABLE}.status=0
        else: No

  - dimension_group: date_accepted_in_program
    type: time
    timeframes: [time, date, week, month]
    sql: |
       (select cp.start_date from referral_connections rf_c, client_programs cp where rf_c.ref_client_program=cp.id and
        rf_c.ref_referral = ${TABLE}.id limit 0,1)


  # - dimension_group: date_denied
  #   type: time
  #   timeframes: [time, date, week, month]
  #   sql: |
  #     (SELECT rh.date FROM referral_history AS rh WHERE rh.ref_referral = rf.id
  #               ORDER BY rh.date DESC LIMIT 0,1)


  - dimension: ever_on_queue
    type: yesno
    sql: ${TABLE}.queue is not null
    

  - dimension: type
    type: int
    sql: ${TABLE}.type
    
  - dimension: queue_remove_reason
    sql: fn_getPicklistValueName('queue_remove_reason',${TABLE}.ref_queue_removed_reason)    

  - measure: count
    type: count
    drill_fields: [id]

