SELECT left(nv.Research_Participant_ID,2) as 'CBC_ID', 
		nv.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Visit_Info_ID, nv.Date_Of_Event,
		bio.Biospecimen_Type, bio.Biospecimen_ID,  a.Biospecimen_ID,  
		a.Aliquot_ID, a.Aliquot_Volume, a.Samples_Not_Useable, sm.Submission_Index, bp.Biorepository_ID
	FROM `seronetdb-Vaccine_Response_v2`.Normalized_Visit_Info as nv
left join `seronetdb-Vaccine_Response_v2`.Biospecimen as bio
	on nv.Visit_Info_ID = bio.Visit_Info_ID
left join `seronetdb-Vaccine_Response_v2`.Aliquot as a
	on a.Biospecimen_ID = bio.Biospecimen_ID
left join  `seronetdb-Vaccine_Response_v2`.Shipping_Manifest as sm
	on a.Aliquot_ID = sm.`Current Label`
left join (select `Current Label`, Biorepository_ID  from  `seronetdb-Vaccine_Response_v2`.BSI_Parent_Aliquots  group by `Current Label`)as bp
	on a.Aliquot_ID = bp.`Current Label`
 
#where nv.Research_Participant_ID like '14_%' and (bio.Biospecimen_Type = 'Serum')
where nv.Research_Participant_ID like '%' and (bio.Biospecimen_Type = 'Serum') and a.Samples_Not_Useable is NULL
#left join `seronetdb-Vaccine_Response`.Sample_Collection_Table as sc
#	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index

#where nv.Research_Participant_ID like '%' and (bio.Biospecimen_Type = 'Serum' or
#	(bio.Biospecimen_Type is NULL and sc.Date_Of_Event >= '2023-08-01' and  sc.Serum_Volume_For_FNL > 0)) #and sc.Num_PBMC_Vials_For_FNL > 0)) #






#left join  `seronetdb-Vaccine_Response`.Accrual_Visit_Info as av
#	on av.Research_Participant_ID = nv.Research_Participant_ID and av.Visit_Number = nv.Accrual_Visit_Num
