SELECT bio.Visit_Info_ID, a.Aliquot_ID, bp.Biorepository_ID,  bp.`Material Type`, bp.`Vial Reserved For FNL`  as 'Parent Vial Resered',
	bp.`Vial Reserved For FNL`, bp.`FNL_Reserve_Cat`, # Subaliquot_Location,
    #count(bp.Biorepository_ID) as 'Number of Samples',

	case when bp.`Vial Status` = 'Discrepant' then 'Vial not Useable: Discrepant'
		 when bp.`Vial Reserved For FNL` = 'No' then 'Available'
		 when bp.`Vial Reserved For FNL` like 'No%' and bp.`Vial Reserved For FNL` != 'No' then 'Vial has been Used'
		 when bp.`Vial Reserved For FNL` = 'Yes' then 'FNL_Reserve' 
		 when bp.`Vial Reserved For FNL` like 'Yes%' and bp.`Vial Reserved For FNL` != 'Yes' then 'Vial has been Used'
		 else 'Other case' end
		 as 'Vial_Status',
    
	(case when bc.res_vials is NULL then 0 else bc.res_vials end) as 'Average Resereved Child Vials',
    (case when bc.res_volume is NULL then 0 else bc.res_volume end) as 'Average Reserved Child Volume'
	FROM `seronetdb-Vaccine_Response_v2`.BSI_Parent_Aliquots as bp
left join (SELECT Biorepository_ID, 
	sum(case when `Vial Reserved For FNL` not like '%No%' then 1 else 0 end) as res_vials,  
    sum(case when `Vial Reserved For FNL` not like '%No%' then Volume else 0 end) as res_volume,
    sum(case when `Vial Reserved For FNL` = 'No' then 1 else 0 end) as avl_vials,  
    sum(case when `Vial Reserved For FNL` = 'No' then Volume else 0 end) as avl_volume 
            FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots
			group by Biorepository_ID) as bc
	on bp.Biorepository_ID = bc.Biorepository_ID
left join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
left join Biospecimen as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID