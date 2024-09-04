SELECT bio.Visit_Info_ID, a.Aliquot_ID, bp.Biorepository_ID,
	 bp.`FNL_Reserve_Cat`, # Subaliquot_Location,
    #count(bp.Biorepository_ID) as 'Number of Serum Samples',
    #sum(case when bio.Visit_Info_ID is NULL then 1 else 0 end) as 'Missing Visit Data',
    
    #round(avg(case when bc.res_vials is NULL then 0 else bc.res_vials end), 2) as 'Average Resereved Child Vials',
    #round(avg(case when bc.res_volume is NULL then 0 else bc.res_volume end), 2) as 'Average Reserved Child Volume'
    #round(avg(case when bc.avl_vials is NULL then 0 else bc.avl_vials end), 4) as 'Average Avaialble Child Vials',
    #round(avg(case when bc.avl_volume is NULL then 0 else bc.avl_volume end),4) as 'Average Avaiable Child Volume'
    
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
			#where `Vial Reserved For FNL` not like '%No%'
			group by Biorepository_ID) as bc
	on bp.Biorepository_ID = bc.Biorepository_ID
left join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
left join Biospecimen as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID
where bp.`Material Type` = 'Serum' 
and FNL_Reserve_Cat like 'Group 9: Data Errors: No Aliquot Data%' #and bio.Visit_Info_ID in ('41_101047 : F14',
	#	'41_101112 : F11','41_101043 : F10','14_I84197 : F09','41_101067 : F15','14_M96679 : F02')
	#and `FNL_Reserve_Cat` is NULL
#	and `FNL_Reserve_Cat` = 'Group 2C: (8*50ul + 2*300ul) (Single Parent) '
#group by  `FNL_Reserve_Cat`# , Subaliquot_Location
#order by bp.FNL_Reserve_Cat #, Subaliquot_Location
