

- explore: base
  from: client_program_screening_base
  persist_for: 60 minutes
  label: 'HMIS Performance'
  conditionally_filter: 
    enrollments.date_filter: '1 Quarter'
  access_filter_fields: [agencies.id, agencies.coc, agencies.county]
  always_join: [clients]
  sql_always_where: clients.deleted is NULL or clients.deleted =0

  joins:
    - join: entry_screen
      sql_on: ${base.first_entry_screen_id} = ${entry_screen.id}  
      type: inner
      sql_always_where: ref_agency = 0

    - join: household_entry_screen
      view_label: 'Entry Screen'
      type: inner
      sql_on:  ${enrollments.ref_household} =  ${household_entry_screen.household_id}     

      
    - join: entry_custom
      type: inner
      fields: [entry_custom_fields*]
      sql_on: ${entry_custom.ref_client_program_demographics} = ${entry_screen.id} 
        
    - join: last_screen
      sql_on: ${base.last_screening_to_analyze} = ${last_screen.id}
      type: left_outer
      
    - join: last_custom
      type: left_outer
      view_label: 'Update/Exit Custom'
      fields: [last_custom_fields*]
      sql_on: ${last_screen.id} = ${last_custom.ref_client_program_demographics}        
      
    - join: outbound_recidivism
      type: left_outer
      sql_on: ${last_screen.id} = ${outbound_recidivism.screen_id}
    
    - join: enrollments
      type: inner
      sql_on: ${base.ref_program} = ${enrollments.id}
      
    - join: client_last_program
      fields: []
      sql_on: ${client_last_program.id} = ${enrollments.id}     
      
    - join: client_last_system_program_enrollment
      fields: []
      sql_on: ${client_last_system_program_enrollment.id} = ${enrollments.id}         
 
    - join: client_first_program
      fields: []
      sql_on: ${client_first_program.id} = ${enrollments.id}     
      
    - join: client_first_system_enrollment
      fields: []
      sql_on: ${client_first_system_enrollment.id} = ${enrollments.id}         
      

    - join: client_program_staff
      fields: []
      sql_on: ${client_program_staff.ref_client_program} = ${enrollments.id}
      
    - join: members
      fields: []
      sql_on: ${client_program_staff.ref_user} = ${members.ref_user}    
      
    - join: programs
      fields: [ref_agency, name, project_type_code,  agency_project_name, id, list_of_program_names, added_date, description, geocode, tracking_method, template, program_applicability, status, ref_target_b,  count]
      sql_on: ${enrollments.ref_program} = ${programs.id}
      
    - join: program_funding_sources
      sql_on: ${programs.id} = ${program_funding_sources.ref_program}     
      
    - join: program_templates
      fields: []
      sql_on: ${programs.ref_template} = ${program_templates.id}   
      
    - join: program_inventory
      relationship: one_to_many
      sql_on: ${programs.id} = ${program_inventory.ref_program} and  ( program_inventory.deleted is null OR  program_inventory.deleted =0 )  
      
    - join: agencies
      fields: [id, coc, name, status, county]
      sql_on: ${programs.ref_agency} = ${agencies.id}


      
    - join: counties
      fields: []
      sql_on: ${counties.id} = ${agencies.ref_county}

    - join: household_makeup
      sql_on: ${enrollments.ref_household} = ${household_makeup.id}

    - join: clients
      type: inner
      sql_on: ${base.ref_client} = ${clients.id}

    - join: client_group_members
      view_label: Clients
      sql_on: ${clients.id} = ${client_group_members.ref_client} and ${client_group_members.end_date} is NULL
      
      
    - join: client_addresses
      sql_on: ${base.ref_client} = ${client_addresses.ref_client}  and ${client_addresses.deleted} is null 

    - join: client_field_interactions
      sql_on: ${base.ref_client} = ${client_field_interactions.ref_client}

    - join: client_notes
      from: client_notes
      sql_on: ${client_notes.ref_client_program_id} = ${base.ref_program} and ( ${client_notes.deleted} is null OR ${client_notes.deleted} =0 )
     # sql_on: ${clients.id} = ${client_notes.ref_client} and ( ${client_notes.deleted} is null OR ${client_notes.deleted} =0 )


    - join: static_demographics
      from: client_demographics
      view_label: 'Clients'
      type: inner
      fields: [id, gender, gender_text, ethnicity, ethnicity_text, name_middle, ref_client, race , race_text, race_1_text,race_2_text, race_3_text, race_4_text, race_5_text, veteran, veteran_text, veteran_branch, veteran_discharge,  veteran_theater_afg, veteran_theater_iraq1, veteran_theater_iraq2, veteran_theater_kw, veteran_theater_other, veteran_theater_pg, veteran_theater_vw, veteran_theater_ww2, veteran_entered, veteran_separated, zipcode]
      sql_on: ${clients.id} = ${static_demographics.ref_client}
      
    - join: static_demographics_custom
      from: client_custom
      fields: [client_custom_fields*]
      sql_on:  ${static_demographics.id} = ${static_demographics_custom.ref_client_demographics}
      
    - join: client_service_programs
      fields: []
      type: left_outer
      sql_on: ${enrollments.id} = ${client_service_programs.ref_client_program}
      
    - join: client_services
      fields: []
      relationship: one_to_one
      sql_on: ${client_services.id} = ${client_service_programs.ref_client_service} and ( ${client_services.deleted} is null OR ${client_services.deleted} =0 ) 
      
      
    - join: service_items
      fields: []
      relationship: one_to_one
      sql_on: ${service_items.id} = ${client_services.ref_service_item}

    - join: client_service_notes
      fields: []
      sql_on: ${client_service_notes.ref_client_service} = ${client_services.id}
      
    - join: client_program_goals
      view_label: 'Goals'
      sql_on: ${client_program_goals.ref_client_program} = ${enrollments.id}    

    - join: goals
      fields: []
      sql_on: ${goals.id} = ${client_program_goals.ref_goal} 
      
    - join: service_expenses
      relationship: one_to_one
      sql_on: ${service_expenses.ref_client_service} = ${client_services.id}
      
    - join: funding
      view_label: "Service Funding"
      sql_on: ${funding.id} = ${service_expenses.ref_funding}      
      
    - join:  service_time_tracking
      relationship: one_to_one
      sql_on: ${service_time_tracking.ref_client_service} = ${client_services.id}      

    - join: services
      sql_on: ${service_items.ref_service} = ${services.id}
      
    - join: service_dates
      type: left_outer
      sql_on: ${service_dates.ref_client_service} = ${client_services.id}
      
    - join: client_assessments
      sql_on: ${clients.id} = ${client_assessments.ref_client} and  ( ${client_assessments.deleted} is null OR ${client_assessments.deleted} =0 ) 
   
    - join: client_last_assessment
      fields: []
      sql_on: ${client_assessments.id} = ${client_last_assessment.id}   
      
    - join: client_assessment_scores
      fields: []
      sql_on: ${client_assessments.id} = ${client_assessment_scores.ref_assessment}
      
    - join: screens
      fields: []
      type: inner
      sql_on: ${screens.id} = ${client_assessments.ref_assessment}
      
    - join: client_assessment_custom
      sql_on: ${client_assessments.id} =${client_assessment_custom.ref_client_assessment_demographics}

    - join: release_of_information
      sql_on: ${release_of_information.ref_client} =${clients.id}  and ( ${release_of_information.deleted} is null OR ${release_of_information.deleted} =0 ) 

    - join: roi_agencies
      from: agencies
      fields: []
      sql_on: ${release_of_information.ref_agency} =${roi_agencies.id}
      


- explore: population
  label: 'HMIS Population over Time'
  access_filter_fields: [agencies.id, agencies.coc, agencies.county]
  always_join: [clients]
  sql_always_where: clients.deleted is NULL or clients.deleted =0
  joins:
   - join: entry_screen
     sql_on: ${population.first_entry_screen_id} = ${entry_screen.id}
     type: left_outer
 # #     - join: inbound_recidivism
# #       sql_on: ${entry_screen.id} = ${inbound_recidivism.screen_id}
# 
   - join: last_screen
     sql_on: ${population.last_screening_to_analyze} = ${last_screen.id}
     type: left_outer
#       
# #     - join: outbound_recidivism
# #       sql_on: ${last_screen.id} = ${outbound_recidivism.screen_id}
#     
   - join: enrollments
     fields: [id, date_filter, end_date, start_date, ref_client_group, head_of_household, ref_household, days_since_start, days_since_start_tier, average_duration, still_in_program, is_first_enrollment, is_latest_enrollment, is_first_system_enrollment, is_latest_system_enrollment, count]
     sql_on: ${population.ref_program} = ${enrollments.id}

   - join: client_last_program
     fields: []
     sql_on: ${client_last_program.id} = ${enrollments.id}     
      
   - join: client_last_system_program_enrollment
     fields: []
     sql_on: ${client_last_system_program_enrollment.id} = ${enrollments.id}          

   - join: client_first_program
     fields: []
     sql_on: ${client_first_program.id} = ${enrollments.id}     
      
   - join: client_first_system_enrollment
     fields: []
     sql_on: ${client_first_system_enrollment.id} = ${enrollments.id}    


#       
   - join: programs
     fields: [ref_agency, name, project_type_code,  agency_project_name, id, list_of_program_names, added_date, description, tracking_method, template, count]
     sql_on: ${enrollments.ref_program} = ${programs.id}

   - join: program_templates
     fields: []
     sql_on: ${programs.ref_template} = ${program_templates.id}     
#       
   - join: agencies
     fields: [id, coc,  name, county]
     sql_on: ${programs.ref_agency} = ${agencies.id}
     
   - join: counties
     fields: []
     sql_on: ${counties.id} = ${agencies.ref_county}     
# 
#     - join: household_makeup
#       sql_on: ${enrollments.ref_household} = ${household_makeup.id}
#       
   - join: clients
     sql_on: ${population.ref_client} = ${clients.id}
# 
   - join: static_demographics
     from: client_demographics
#      required_joins: clients
     fields: [id, gender, gender_text, ethnicity, ethnicity_text, ref_client, race, race_text, veteran, veteran_text]
     sql_on: ${clients.id} = ${static_demographics.ref_client}






- explore: clients
  persist_for: 60 minutes
  label: 'Services Model'
  access_filter_fields: [agencies.id, agencies.coc, agencies.county]

  joins:

    - join: static_demographics
      from: client_demographics
      type: inner
      fields: [id, gender, gender_text, ethnicity, ethnicity_text, ref_client, race , race_text, veteran, veteran_text, veteran_branch, veteran_discharge,  veteran_theater_afg, veteran_theater_iraq1, veteran_theater_iraq2, veteran_theater_kw, veteran_theater_other, veteran_theater_pg, veteran_theater_vw, veteran_theater_ww2,   zipcode]
      sql_on: ${clients.id} = ${static_demographics.ref_client}
      
    - join: static_demographics_custom
      from: client_custom
      fields: [static_demographics_custom.client_custom_fields*]
#      sql_on:  ${clients.id} = ${static_demographics_custom.ref_client}
      sql_on:  ${static_demographics.id} = ${static_demographics_custom.ref_client_demographics}      

    - join: client_services
      relationship: one_to_many
      fields: []
      sql_on: ${client_services.ref_client} = ${clients.id} and ( ${client_services.deleted} is null OR ${client_services.deleted} =0 ) 

    - join: service_items
      fields: []
      type: inner
#       required_joins: client_services
      sql_on: ${service_items.id} = ${client_services.ref_service_item}
      
    - join: service_dates
      type: left_outer
      sql_on: ${service_dates.ref_client_service} = ${client_services.id}      

    - join: client_service_notes
      fields: []
      sql_on: ${client_service_notes.ref_client_service} = ${client_services.id}
      
    - join: service_expenses
#       fields: []
      relationship: one_to_one
      sql_on: ${service_expenses.ref_client_service} = ${client_services.id}

    - join:  service_time_tracking
      relationship: one_to_one
      sql_on: ${service_time_tracking.ref_client_service} = ${client_services.id}            


    - join: services
      type: inner
      sql_on: ${service_items.ref_service} = ${services.id}


    - join: agencies
      fields: [id, coc, county, name]
      sql_on: ${client_services.ref_agency} = ${agencies.id}

    - join: counties
      fields: []
      sql_on: ${counties.id} = ${agencies.ref_county}         
      
    - join: client_addresses
      sql_on: ${clients.id} = ${client_addresses.ref_client}  
      
    - join: client_assessments
      sql_on: ${clients.id} = ${client_assessments.ref_client}
      
    - join: client_last_assessment
      fields: []
      sql_on: ${client_assessments.id} = ${client_last_assessment.id}         
      
    - join: client_assessment_scores
      fields: []
      sql_on: ${client_assessments.id} = ${client_assessment_scores.ref_assessment}
      
    - join: screens
      fields: []
      type: inner
      sql_on: ${screens.id} = ${client_assessments.ref_assessment}
      
    - join: client_assessment_custom
      sql_on: ${client_assessments.id} =${client_assessment_custom.id}     
      
    - join: enrollments
      type: inner
      fields: [id, date_filter, end_date, start_date, ref_client_group, head_of_household, ref_household, days_since_start, days_since_start_tier, average_duration, still_in_program, count]
      sql_on: ${clients.id} = ${enrollments.ref_client}  
      
    - join: client_last_program
      fields: []
      sql_on: ${client_last_program.id} = ${enrollments.id}     
      
    - join: members
      fields: []
      sql_on: ${enrollments.ref_user} = ${members.ref_user}          
      
      
- explore: client
  from: clients
  persist_for: 60 minutes
  label: 'Coordinated Entry'
  access_filter_fields: [agencies.id, agencies.coc, agencies.county]
  sql_always_where: client.deleted is NULL or client.deleted =0
  joins:


    - join: client_addresses
      sql_on: ${client.id} = ${client_addresses.ref_client}   and ${client_addresses.deleted} is null 
    

    - join: static_demographics
      from: client_demographics
      fields: [id, gender, gender_text, ethnicity, ethnicity_text, ref_client, race , race_text, veteran, veteran_text, veteran_discharge]
      sql_on: ${client.id} = ${static_demographics.ref_client}
      
    - join: static_demographics_custom
      from: client_custom
      fields: [static_demographics_custom.client_custom_fields*]
      sql_on:  ${static_demographics.id} = ${static_demographics_custom.ref_client_demographics}

    - join: agencies 
      from: agencies
      fields: [id, coc, name, county]
      sql_on: ${client_assessments.ref_agency} = ${agencies.id}
      
    - join: counties
      fields: []
      sql_on: ${counties.id} = ${agencies.ref_county}      
      
    - join: client_assessments
      sql_on: ${client.id} = ${client_assessments.ref_client} and  ( ${client_assessments.deleted} is null OR ${client_assessments.deleted} =0 ) 
      required_joins: client_assessment_scores

    - join: client_last_assessment
      fields: []
      sql_on: ${client_assessments.id} = ${client_last_assessment.id}
      
    - join: client_assessment_scores
      fields: []
#      type: inner  #-- commented out until the yspdat processor is really per JS request.
      sql_on: ${client_assessments.id} = ${client_assessment_scores.ref_assessment}
      
    - join: screens
      fields: []
      type: inner
      sql_on: ${screens.id} = ${client_assessments.ref_assessment}
      
    - join: client_assessment_custom
      sql_on: ${client_assessments.id} =${client_assessment_custom.ref_client_assessment_demographics}     

    - join: referrals
      sql_on: ${client.id} = ${referrals.ref_client}  and ${client_assessments.id} = ${referrals.assessment_id} and ${referrals.deleted} is NULL
     # sql_on: ${client_assessments.id} = ${referrals.ref_assessment}
     
    
    - join: referring_agencies
      from: agencies
      fields: []
      sql_on: ${referrals.ref_agency} = ${referring_agencies.id}  
      
    - join: referral_history
      sql_on: ${referrals.id} = ${referral_history.ref_referral}  

    - join: referto_program
      from: programs
      fields: [ref_agency, name, project_type_code, id,  added_date, description, geocode, availability, tracking_method, count]
      sql_on: ${referrals.ref_program} = ${referto_program.id}  

    - join: referto_agencies
      view_label: 'Referto Program'
      from: agencies
      fields: [name, agency_id]
      sql_on: ${referto_agencies.id} = ${referto_program.ref_agency} 
      
    - join: referto_program_openings
      from: program_openings
      sql_on: ${referto_program_openings.id} = ${referrals.ref_opening} 
      
    - join: program_openings_history
      view_label: "Program Opening History (Beta)"
      sql_on: ${program_openings_history.ref_program} = ${referto_program.id} 
      
    - join: enrollments
      fields: [id, date_filter, end_date, start_date, ref_client_group, head_of_household, ref_household, days_since_start, days_since_start_tier, average_duration, still_in_program, is_latest_enrollment, is_latest_system_enrollment, is_first_enrollment, is_first_system_enrollment, count]
      sql_on: ${client.id} = ${enrollments.ref_client} and CASE WHEN '{{ _access_filters["agencies.id"]] }}'  = '>0'  THEN ${enrollments.ref_agency} >0 ELSE ${enrollments.ref_agency} < 0 END and ${enrollments.deleted} is null  #this was added to prevent non admins from getting enrollments

    - join: client_last_program
      fields: []
      sql_on: ${client_last_program.id} = ${enrollments.id}     
      
    - join: client_last_system_program_enrollment
      fields: []
      sql_on: ${client_last_system_program_enrollment.id} = ${enrollments.id}          

    - join: client_first_program
      fields: []
      sql_on: ${client_first_program.id} = ${enrollments.id}     
      
    - join: client_first_system_enrollment
      fields: []
      sql_on: ${client_first_system_enrollment.id} = ${enrollments.id}    

    - join: base
      from: client_program_screening_base
      fields: []
      sql_on: ${base.ref_program} = ${enrollments.id}
      
    - join: entry_screen
      view_label: 'Entry Screen (Beta)'
      sql_on: ${base.first_entry_screen_id} = ${entry_screen.id}  
      type: inner
    
    - join: household_entry_screen
      view_label: 'Entry Screen (Beta)'
      type: inner
      sql_on:  ${enrollments.ref_household} =  ${household_entry_screen.household_id}     

      
#     - join: entry_custom
#       type: inner
#       fields: [entry_custom_fields*]
#       sql_on: ${entry_custom.ref_client_program_demographics} = ${entry_screen.id} 
#         
#     - join: last_screen
#       sql_on: ${base.last_screening_to_analyze} = ${last_screen.id}
#       type: left_outer
#       
#     - join: last_custom
#       type: left_outer
#       view_label: 'Update/Exit Custom'
#       fields: [last_custom_fields*]
#       sql_on: ${last_screen.id} = ${last_custom.ref_client_program_demographics}          
      
      
      
      

    - join: members
      fields: []
      sql_on: ${enrollments.ref_user} = ${members.ref_user}    
      
    - join: programs
      fields: [ref_agency, name, project_type_code,  id, added_date, description, geocode, tracking_method,  program_applicability, status, ref_target_b,  count]
      sql_on: ${enrollments.ref_program} = ${programs.id}      

    - join: enrollment_agencies
      from: agencies
      fields: [agency_id, coc, name, status, zip, count]
      sql_on: ${enrollment_agencies.id} = ${programs.ref_agency}             
      
      
- explore: agencies
  label: 'Project Descriptor Model'
  access_filter_fields: [agencies.id, agencies.coc, agencies.county]
  sql_always_where:  agencies.status = 1
  joins:

    - join: counties
      fields: []
      sql_on: ${counties.id} = ${agencies.ref_county}  
      
    - join: department
      sql_on: ${department.ref_agency} = ${agencies.id}        
      
    - join: programs
      from: programs
      relationship: one_to_many
      sql_on: ${agencies.id} = ${programs.ref_agency} and  ( programs.deleted is null OR programs.deleted =0 )  

    - join: program_funding_sources
      view_label: "Program Funding Sources"
      sql_on: ${programs.id} = ${program_funding_sources.ref_program}
      
    - join: program_inventory
      view_label: "Program Bed Inventory"
      relationship: one_to_many
      sql_on: ${programs.id} = ${program_inventory.ref_program} and  ( program_inventory.deleted is null OR  program_inventory.deleted =0 )  
      
#       join: program_service_items
#       fields: []
#       sql_on: ${programs.id} = ${program_service_items.ref_program}
      
    - join: program_openings
      sql_on: ${program_openings.ref_program} = ${programs.id}  
      
    - join: program_openings_history
      view_label: "Program Opening History (Beta)"
      fields: [first_posted, last_posted, first_reserved, last_reserved]
      sql_on: ${program_openings_history.ref_program} = ${programs.id}      
            
    - join: funding
      sql_on: ${funding.ref_agency} = ${agencies.id}


    - join: program_templates
      fields: []
      sql_on: ${programs.ref_template} = ${program_templates.id}
      
      
    - join: program_scoring_eligibility
      view_label: "Program Scoring Tier Eligibility"
      type: inner
      sql_on: ${programs.id} = ${program_scoring_eligibility.ref_program}    
      
    - join: agency_assessments
      fields: []
      sql_on: ${agencies.id} = ${agency_assessments.ref_agency}

    - join: screens
      type: inner
      sql_on: ${screens.id} = ${agency_assessments.ref_assessment}
      
    - join: screens_default_profile
      from: screens
      fields: []
      sql_on: ${screens_default_profile.id} = ${agencies.ref_profile_screen}   

    - join: questions
      sql_on: ${screens.id} = ${questions.ref_screen}
      
    - join: fields
      fields: []
      sql_on: ${fields.id} = ${questions.ref_field}
      
    - join: members
      sql_on: ${agencies.id} = ${members.ref_agency} 
    
    - join: users
      fields: []
      required_joins: [department_user]
      sql_on: ${users.id} = ${members.ref_user}

    - join: member_activity_logs
      sql_on: ${members.id} = ${member_activity_logs.ref_user}          
      
      
    - join: department_user
      fields: []
      sql_on: ${members.id} = ${department_user.ref_user}      

    - join: member_departments
      from: department
      sql_on: ${department_user.ref_department} = ${member_departments.id}      

      
    - join: user_agencies
      fields: []
      sql_on: ${users.id} = ${user_agencies.ref_user}
      
    - join: member_additional_agencies
      fields: [name, county, id, coc]
      from: agencies
      sql_on: ${user_agencies.ref_agency} = ${member_additional_agencies.id}    
            
      
    - join: user_groups
      fields: []
      sql_on: ${users.ref_user_group} = ${user_groups.id}     
      
    - join: agency_services
      from: agency_services
      type: inner
      sql_on: ${agencies.id} = ${agency_services.ref_agency}  and ${agency_services.id} NOT IN (select ref_service from program_services)
      
      
    - join: program_services
      fields: []
      sql_on: ${program_services.ref_program} = ${programs.id} 

    - join: project_services
      from: agency_services
      type: inner
      sql_on: ${project_services.id} = ${program_services.ref_service}
      
    - join: project_service_bed_inventories
      from: service_items_housing
      type: inner
      sql_on: ${project_services.service_item_id} = ${project_service_bed_inventories.ref_service_item}
      sql_always_where: deleted = 0 or deleted is null
      
    - join: sharing_group_agency
      fields: []
      sql_on: ${sharing_group_agency.ref_agency} = ${agencies.id}   
      
    - join: sharing_group
      fields: [name, count]
      sql_on: ${sharing_group.id} = ${sharing_group_agency.ref_sharing_group}   
    
    - join: program_sites
      fields: []
      sql_on: ${programs.id} = ${program_sites.ref_program}
      
    - join: sites
      sql_on: ${sites.id}=${program_sites.ref_site}
      sql_always_where: deleted = 0 or deleted is null


#- explore: import_files
#  label: 'Data Import Analysis'
#  access_filter_fields: [agencies.id]
#  always_join: [programs]
#  sql_always_where:  agencies.status = 1
#  joins:
#
#    - join: import_client_map
#      sql_on: ${import_client_map.ref_file} = ${import_files.id} 
