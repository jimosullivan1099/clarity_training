- view: program_inventory
  sql_table_name: program_inventory
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension_group: added
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.added_date

  - dimension: availability
    description:  'Bed Inventory Availability, (Year-Round, Seasonal, etc.) (HMIS Data Element 2.7.4)'
    sql: fn_getPicklistValueName('availability',${TABLE}.availability)   

  - dimension: ref_bed_type
    label: 'bed type'
    bypass_suggest_restrictions: true
    sql: fn_getPicklistValueName('bed_types',${TABLE}.ref_bed_type)  
    
  - measure: total_bed_inventory
    description:  'Number of beds (HMIS Data Element 2.7.5)'
    type: sum
    sql: ${TABLE}.bed_inventory

  - measure: total_bed_inventory_between_18_24
    description:  'Number of youth beds for Ages 18 to 24 (HMIS Data Element 2.7.5.3.2)'
    type: sum
    sql: ${TABLE}.between_18_24

  - measure: total_bed_chronic_inventory
    description:  'Number of beds designated for Chronic Homeless (HMIS Data Element 2.7.5.1)'
    type: sum
    sql: ${TABLE}.chronic_inventory

  - dimension: coc
    type: string
    sql: ${TABLE}.coc

  - dimension: deleted
    type: yesno
    sql: ${TABLE}.deleted

  - dimension_group: end
    description:  'End Date for Bed Inventory (HMIS Data Element 2.7.8)'
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.end_date

  - dimension_group: information
    description:  'Date the Bed Inventory was updated (User entered date) (HMIS Data Element 2.7.1)'
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.information_date

  - dimension: is_between_18_24
    hidden: true
    type: yesno
    sql: ${TABLE}.is_between_18_24

  - dimension: is_chronic
    hidden: true
    type: yesno
    sql: ${TABLE}.is_chronic

  - dimension: is_hmis_participating
    type: yesno
    sql: ${TABLE}.is_hmis_participating

  - dimension: is_under_18
    hidden: true
    type: yesno
    sql: ${TABLE}.is_under_18

  - dimension: is_under_24
    hidden: true
    type: yesno
    sql: ${TABLE}.is_under_24

  - dimension: is_veteran
    hidden: true
    type: yesno
    sql: ${TABLE}.is_veteran

  - dimension: is_youth
    hidden: true
    type: yesno
    sql: ${TABLE}.is_youth

  - dimension_group: last_updated
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.last_updated

  - measure: total_participating_beds
    description:  'Number of beds where usage is being tracked in HMIS (HMIS Data Element 2.7.9)'
    type: sum
    sql: ${TABLE}.participating_beds

  - dimension: ref_agency_deleted
    hidden: true
    type: number
    sql: ${TABLE}.ref_agency_deleted


  - dimension: household_type
    description:  'Type of Households will be using the Bed Inventory (HMIS Data Element 2.7.2)'
    sql: fn_getPicklistValueName('household_types',${TABLE}.ref_household_type)   

  - dimension: ref_program
    hidden: true
    type: number
    sql: ${TABLE}.ref_program

  - dimension: ref_user_updated
    hidden: true
    type: number
    sql: ${TABLE}.ref_user_updated

  - dimension_group: start
    description:  'Start Date for Bed Inventory (HMIS Data Element 2.7.7)'
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.start_date

  - measure: total_bed_inventory_under_18
    description:  'Number of youth beds for Under 18 (HMIS Data Element 2.7.5.3.1)'
    type: sum
    sql: ${TABLE}.under_18

  - measure: total_bed_inventory_under_24
    description:  'Number of youth beds for Under 24 (HMIS Data Element 2.7.5.3.3)'
    type: sum
    sql: ${TABLE}.under_24

  - measure: total_unit_inventory
    description:  'Number of Units (Rooms, Apartments, etc.) (HMIS Data Element 2.7.6)'
    type: sum
    sql: ${TABLE}.unit_inventory

  - measure: veteran_inventory
    description:  'Number of beds designated for Veterans (HMIS Data Element 2.7.5.2)'
    type: sum
    sql: ${TABLE}.veteran_inventory

  - measure: total_bed_youth_inventory
    description:  'Number of beds designated for Youth (HMIS Data Element 2.7.5.3)'
    type: sum
    sql: ${TABLE}.youth_inventory

  - measure: count
    type: count
    drill_fields: [id]

