- view: services
  fields:

  - dimension: id
    hidden: true
    type: int
    sql: ${TABLE}.id
    
  - dimension: service_id
    description:  'Unique identifier for a particular service transaction (HMIS Data Element 4.14, only certain services are required)'
    primary_key: true
    type: int
    sql: ${client_services.id}  
  

  - dimension: name
    description:  'Program defined Service Name'
    bypass_suggest_restrictions: true
    sql: ${TABLE}.name

  - dimension: service_item_name
    description:  'Program defined Service Item Name'
    sql: ${service_items.name}
    
  - dimension: service_item_id
    description:  'Clarity HS Service Item ID'
    sql: ${service_items.id}
        
  - dimension: service_notes
    description:  'User created notes concerning service transaction'
    sql: ${client_service_notes.notes} 
    
  - dimension: service_added_date
    description: 'Date service added'
    type: date
    sql: ${client_services.added_date}

  - dimension: start_date
    description:  'Date service was provided or began (HMIS Data Element 4.14, only certain services are required)'
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${client_services.start_date}

  - dimension: status
    label: 'Service Active'
    description:  'Current status of the Service'
    sql_case:
       Active: ${TABLE}.status = 1
       Inactive: ${TABLE}.status = 2
       
  - filter: date_filter
    label: 'Service Date Filter'
    description:  'Service End Date is >= beginning date of the period filter AND Service Start Date is <= ending date of the period filter. Requires two "dates" to set the filter'
    type: date
    sql: |
      ${start_date_raw} <= {% date_end date_filter %} 
      AND ${end_date_raw} >= {% date_start date_filter %}
 
 
  - dimension: start_date_or_report_start
    type: date
    hidden: true
    sql: |
      CASE
      WHEN COALESCE ({% date_start date_filter %},${start_date_raw}) <= ${start_date_raw}
      THEN ${start_date_raw}
      ELSE 
      {% date_start date_filter %}
      END

  - dimension: end_date_or_report_end
    hidden: true
    type: date
    sql: |
      CASE
      WHEN COALESCE ({% date_end date_filter %},${end_date_raw}) >= ${end_date_raw}
      THEN ${end_date_raw}
      ELSE 
      {% date_end date_filter %}
      END




  - measure: first_start
    label: 'First Start Date'
    description:  'Earliest (min) start date'
    type: date
    sql: |
      CASE
      WHEN MIN( COALESCE(${client_services.start_date},'1900-01-01')) = '1900-01-01' THEN
      NULL
      ELSE MIN( COALESCE(${client_services.start_date},'1900-01-01'))
      END   

  - measure: last_start
    label: 'Last Start Date'
    description:  'Most recent (max) start date'
    type: date
    sql: |
      CASE
      WHEN MAX( COALESCE(${client_services.start_date},'1900-01-01')) = '1900-01-01' THEN
      NULL
      ELSE MAX( COALESCE(${client_services.start_date},'1900-01-01'))
      END   


  - dimension: end_date
    description: 'Service End Date'
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${client_services.end_date}

  - dimension: ref_user 
    description:  'User creating the client service'
    label: 'User Creating'
    sql: ${client_services.ref_user}

  - dimension: ref_user_updated 
    description:  'User updating the client service'
    label: 'User Updating'
    sql: ${client_services.ref_user_updated}

  - dimension: ref_agency
    hidden: true
    type: int
    sql: ${TABLE}.ref_agency

  - dimension: ref_category
    description:  'Clarity HS defined Service Category'
    label: 'Service Category'
    bypass_suggest_restrictions: true
    sql: fn_getPicklistValueName('service_categories',${TABLE}.ref_category)  
    
  - measure: days_of_longterm_service
    description:  'Number of days the client was receiving the service during the reporting period.'
    label: 'Days of Service (Long Term)'
    hidden: true
    bypass_suggest_restrictions: true
    type: int
    sql: SUM(DATEDIFF(${end_date_or_report_end},${start_date_or_report_start}))

  - measure: attendance_days_in_period
    hidden: true
    sql: |
      COUNT(CASE WHEN ${service_dates.date_raw} >= COALESCE({% date_start date_filter %} , ${service_dates.date_raw} )
      AND ${service_dates.date_raw} < COALESCE({% date_end date_filter %} , ${service_dates.date_raw})
      THEN ${service_dates.date_raw} ELSE NULL END)
   
    

  - measure: total_days
    label: 'Total Days of Service'
    description: 'Sums total days service was provided during the reporting period. Takes into account Long Term and Daily Attendance services.'
    type: int
    sql: |
      (CASE
      WHEN ${service_items.ref_delivery_type} = 1 THEN
      (${days_of_longterm_service})
      ELSE ${attendance_days_in_period}
      END )



  - dimension: delivery_type
    bypass_suggest_restrictions: true
    sql_case:
       Long Term: ${service_items.ref_delivery_type} = 1
       Daily Attendance: ${service_items.ref_delivery_type} = 2
       Multiple Attendance: ${service_items.ref_delivery_type} = 3


  - measure: count
    description:  'Count of Service IDs'
    type: count



