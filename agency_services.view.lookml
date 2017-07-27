- view: agency_services
  derived_table:
    sql: |
      select 
      services.id as id,
      services.name as name,
      service_items.name as service_item_name,
      service_items.id as service_item_id,
      service_items.end_availability,
      service_items.start_availability,
      service_items.deleted,
      services.status,
      services.ref_agency,
      services.ref_category,
      service_items.ref_delivery_type
      from services INNER JOIN service_items on services.id = service_items.ref_service
      
  fields:

  - dimension: id
    primary_key: true
    type: int
    sql: ${TABLE}.id
    
  - dimension: name
    bypass_suggest_restrictions: true
    sql: ${TABLE}.name

  - dimension: service_item_name
    sql: ${TABLE}.service_item_name
    
  - dimension: service_item_id
    sql: ${TABLE}.service_item_id
    
  - dimension_group: service_items_end_availability
    label:  'Service Item End Availability'
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.end_availability
    
  - dimension_group: service_items_start_availability
    label: 'Service Item Start Availability'
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.start_availability
    
  - dimension: deleted
    label:  'Service Item Deleted'
    type: yesno
    sql: ${TABLE}.deleted
    
  - dimension: status
    label: 'Service Active'
    sql_case:
       Active: ${TABLE}.status = 1
       Inactive: ${TABLE}.status = 2

  - dimension: ref_agency
    hidden: true
    type: int
    sql: ${TABLE}.ref_agency

  - dimension: ref_category
    label: 'Service Category'
    bypass_suggest_restrictions: true
    sql: fn_getPicklistValueName('service_categories',${TABLE}.ref_category)  
    
    
  - dimension: delivery_type
    bypass_suggest_restrictions: true
    sql_case:
       Long Term: ${TABLE}.ref_delivery_type = 1
       Daily Attendance: ${TABLE}.ref_delivery_type = 2
       Multiple Attendance: ${TABLE}.ref_delivery_type = 3    

  - measure: count
    type: count


