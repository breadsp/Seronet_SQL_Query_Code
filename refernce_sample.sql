SELECT left(CBC_Biospecimen_Aliquot_ID, 13) as 'Bio_ID',
	sum(case when `Vial Status` = 'Empty' then 1 else NULL end) as 'Number Vials Empty',
    group_concat(case when `Vial Status` = 'Empty' then Biorepository_ID else NULL end, " " ) as 'Vials Empty',
    
    sum(case when `Vial Status` = 'Out' then 1 else NULL end) as 'Number Vials Out',
    group_concat(case when `Vial Status` = 'Out' then Biorepository_ID else NULL end, " " ) as 'Vials Out',

	sum(case when `Vial Status` = 'In' then 1 else NULL end) as 'Number Vials In',
    group_concat(case when `Vial Status` = 'In' then Biorepository_ID else NULL end, " " ) as 'Vials In'
 FROM `seronetdb-Validated`.BSI_Parent_Aliquots
 where `Material Type` = 'Serum'
 group by left(CBC_Biospecimen_Aliquot_ID, 13)