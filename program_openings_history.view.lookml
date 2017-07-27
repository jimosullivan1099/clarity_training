- view: program_openings_history
  derived_table:

    sql: |
      SELECT 
      po.note as opening, 
      po.date as date_posted, 
      r.date as date_reserved, 
      po.ref_program,
      r.ref_opening,
      r.deleted as ref_deleted,
      min(po.date) as first_posted,
      max(po.date) as last_posted,
      min(r.date) as first_reserved,
      max(r.date) as last_reserved
      FROM program_openings po
      INNER JOIN programs p on p.id = po.ref_program
      LEFT JOIN referrals r on po.id = r.ref_opening
      INNER JOIN agencies a on p.ref_agency = a.id
      GROUP BY po.note, r.date
      
    
      
  fields:
    - dimension: opening
      label: 'Program Opening'
      description: 'Unique Identifier for Opening'
      sql: ${TABLE}.opening
      
    - dimension: date_posted
      label: 'Date Posted'
      description: 'Date Opening Posted'
      sql: ${TABLE}.date_posted
      
    - dimension: date_reserved
      label: 'Date Reserved'
      description: 'Date Opening Reserved'
      sql: ${TABLE}.date_reserved
      
    - dimension: ref_program
      hidden: true
      type: number
      sql: ${TABLE}.ref_program
      
    - dimension: ref_opening
      label: 'Opening Id'
      type: number
      sql: ${TABLE}.ref_opening
      
    - dimension: ref_deleted
      label: 'Deleted'
      type: number
      sql: ${TABLE}.ref_deleted
      
    - dimension: first_posted
      label: 'First Posted'
      sql: ${TABLE}.first_posted
      
    - dimension: last_posted
      label: 'Last Posted'
      sql: ${TABLE}.last_posted
      
    - dimension: first_reserved
      label: 'First Reserved'
      sql: ${TABLE}.first_reserved
      
    - dimension: last_reserved
      label: 'Last Reserved'
      sql: ${TABLE}.last_reserved
      
    
      
    - measure: opening_count
      label: 'Opening Count'
      type: sum
      sql: ${opening}

