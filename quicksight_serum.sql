SELECT case when bp.`Current Label` like '14_%' then 'MSSM'
	        when bp.`Current Label` like '27_%' then 'UMN'
			when bp.`Current Label` like '32_%' then 'ASU'
			when bp.`Current Label` like '41_%' then 'FIMR'
			else 'UNKWN' end 	as 'CBC_ID',  
		bio.Visit_Info_ID, 
		case when new_cat.`Visit has not yet been catagorized` = 0 then 'No' else 'Yes' end as 'Visit has not yet been catagorized', 
		case when new_cat.`Has Unaliquoted Sample` = 0 then 'No' else 'Yes' end as 'Has Unaliquoted Sample', 
		case when new_cat.`Has samples under 1ml` = 0 then 'No' else 'Yes' end as 'Has samples under 1ml', 
		case when new_cat.`Has 1ml or more sample` = 0 then 'No' else 'Yes' end as 'Has 1ml or more sample', 
		case when new_cat.`All other groups` = 0 then 'No' else 'Yes' end as 'All other groups', 


		nv.Normalized_Visit_Index, nv.Visit_Duration_From_Baseline,nv.Duration_Window_Catagory, nv.SeroNet_Cohort,
		  a.Aliquot_ID, bp.Biorepository_ID,
	bp.`Vial Reserved For FNL`, bp.`FNL_Reserve_Cat`,
 
	case when bp.`FNL_Reserve_Cat` like 'Group 0%' then "Group 0: No Aliquots"
		 when bp.`FNL_Reserve_Cat` like 'Group 1%' then "Group 1: Reserved Aliquots under 1ml"
		 when bp.`FNL_Reserve_Cat` like 'Group 2%' then "Group 2: Has 1ml Reserved"
		 when bp.`FNL_Reserve_Cat` like 'Group 3%' then "Group 3: Slightly over 1ml Reserve"
		 when bp.`FNL_Reserve_Cat` like 'Group 4%' then "Group 4: Addational Aliquots: Not Reserevd"
		 when bp.`FNL_Reserve_Cat` like 'Group 5%' then "Group 5: Aliquoted Samples, unable to Reserve"
		 when bp.`FNL_Reserve_Cat` like 'Group 9%' then "Group 9: Data Errors"
		 else "Unknown group" end as 'Aliquot Grouping',
	
	(case when bc.res_vials is NULL then 0 else bc.res_vials end) as 'Average Resereved Child Vials',
    (case when bc.res_volume is NULL then 0 else bc.res_volume end) as 'Average Reserved Child Volume'
    #(case when bc.avl_vials is NULL then 0 else bc.avl_vials end) as 'Average Avaialble Child Vials',
    #(case when bc.avl_volume is NULL then 0 else bc.avl_volume end) as 'Average Avaiable Child Volume'
	FROM `seronetdb-Vaccine_Response_v2`.BSI_Parent_Aliquots as bp
left join (SELECT Biorepository_ID, 
	sum(case when `Vial Reserved For FNL` = 'nan' then 0
			 when `Vial Reserved For FNL` not like '%No%' then 1 
			else 0 end) as res_vials,  
    sum(case when `Vial Reserved For FNL` = 'nan' then 0
			 when `Vial Reserved For FNL` not like '%No%' then Volume
             else 0 end) as res_volume
    #sum(case when `Vial Reserved For FNL` = 'No' then 1 else 0 end) as avl_vials,  
    #sum(case when `Vial Reserved For FNL` = 'No' then Volume else 0 end) as avl_volume 
			
            FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots
			group by Biorepository_ID) as bc
	on bp.Biorepository_ID = bc.Biorepository_ID
left join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
left join Biospecimen as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID
left join `seronetdb-Vaccine_Response_v2`.Normalized_Visit_Info as nv 
	on bio.Visit_Info_ID = nv.Visit_Info_ID 


left join (SELECT bio.Visit_Info_ID, 
		sum(case when bp.`FNL_Reserve_Cat` is NULL then 1 else 0 end) as  'Visit has not yet been catagorized',
		sum(case when bp.`FNL_Reserve_Cat` like 'Group 0%' then 1 else 0 end) as  'Has Unaliquoted Sample',
		sum(case when bp.`FNL_Reserve_Cat` like 'Group 1%' then 1 else 0 end) as  'Has samples under 1ml',
		sum(case when bp.`FNL_Reserve_Cat` like 'Group 2%' then 1 else 0 end) as  'Has 1ml or more sample',
		sum(case when bp.`FNL_Reserve_Cat` not like 'Group 0%' and 
					bp.`FNL_Reserve_Cat` not like 'Group 1%' and 
					bp.`FNL_Reserve_Cat` not like 'Group 2%'then 1 else 0 end) as  'All other groups'
		
		FROM `seronetdb-Vaccine_Response_v2`.Biospecimen as bio
	left join Aliquot as a	
		on bio.Biospecimen_ID = a.Biospecimen_ID
	left join BSI_Parent_Aliquots as bp
		on a.Aliquot_ID = bp.`Current Label`
	where bio.Biospecimen_Type = 'Serum'
	group by bio.Visit_Info_ID) as new_cat
	on bio.Visit_Info_ID = new_cat.Visit_Info_ID
	
where bp.`Material Type` = 'Serum'