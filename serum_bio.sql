select distinct samp.* from Biospecimen as bio
left join(
SELECT bio.Visit_Info_ID, nv.Normalized_Visit_Index, nv.Visit_Duration_From_Baseline,
	sum(case when FNL_Reserve_Cat is NULL then 1 else 0 end) as 'Not Catagorized', 
    sum(case when FNL_Reserve_Cat like 'Group 0%' then 1 else 0 end) as 'Samples not Aliquoted', 
    sum(case when FNL_Reserve_Cat like 'Group 1%' then 1 else 0 end) as 'Samples under 1ml', 
	sum(case when FNL_Reserve_Cat like 'Group 2%' then 1 else 0 end) as 'Samples have 1ml reserved', 
    sum(case when FNL_Reserve_Cat like 'Group 3%' then 1 else 0 end) as 'Samples Aliquoted but already used', 
    sum(case when FNL_Reserve_Cat like 'Group 8%' then 1 else 0 end) as 'Samples Aliquoted but unable to catagorize', 
    sum(case when FNL_Reserve_Cat like 'Group 9%' then 1 else 0 end) as 'Data errors'
	FROM `seronetdb-Vaccine_Response_v2`.BSI_Parent_Aliquots as bp
left join (SELECT Biorepository_ID, 
	sum(case when `Vial Reserved For FNL` not like '%No%' then 1 else 0 end) as res_vials,  
    sum(case when `Vial Reserved For FNL` not like '%No%' then Volume else 0 end) as res_volume,
    sum(case when `Vial Reserved For FNL` = 'No' then 1 else 0 end) as avl_vials,  
    sum(case when `Vial Reserved For FNL` = 'No' then Volume else 0 end) as avl_volume 
			
            FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots
			#where `Vial Reserved For FNL` not like '%No%'
			group by Biorepository_ID) as bc
	on bp.Biorepository_ID = bc.Biorepository_ID
left join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
left join Biospecimen as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID
left join `seronetdb-Vaccine_Response_v2`.Normalized_Visit_Info as nv 
	on bio.Visit_Info_ID = nv.Visit_Info_ID
where bp.`Material Type` = 'Serum' # and bio.Visit_Info_ID like '41_100001%'
group by  bio.Visit_Info_ID
order by bio.Visit_Info_ID) as samp
	on bio.Visit_Info_ID = samp.Visit_Info_ID
#where samp.`Not Catagorized` > 0