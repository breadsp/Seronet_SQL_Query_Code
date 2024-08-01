SELECT left(nv.Research_Participant_ID,2) as 'CBC_ID', 
		nv.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Accrual_Visit_Num, sc.Date_Of_Event,  sc.Num_PBMC_Vials_For_FNL,  #,sc.Serum_Volume_For_FNL, 
		bio.Biospecimen_Type, bio.Biospecimen_ID,  a.Biospecimen_ID,  
		a.Aliquot_ID, a.Aliquot_Volume, a.Samples_Not_Useable, sm.Submission_Index, bp.Biorepository_ID
	FROM `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination as nv
left join `seronetdb-Vaccine_Response`.Biospecimen as bio
	on nv.Visit_Info_ID = bio.Visit_Info_ID
left join `seronetdb-Vaccine_Response`.Aliquot as a
	on a.Biospecimen_ID = bio.Biospecimen_ID
left join  `seronetdb-Vaccine_Response`.Shipping_Manifest as sm
	on a.Aliquot_ID = sm.`Current Label`
left join (select `Current Label`, Biorepository_ID  from  BSI_Parent_Aliquots  group by `Current Label`)as bp
	on a.Aliquot_ID = bp.`Current Label`
left join `seronetdb-Vaccine_Response`.Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index

where nv.Research_Participant_ID like '%' and (bio.Biospecimen_Type = 'PBMC' or
	(bio.Biospecimen_Type is NULL and sc.Date_Of_Event >= '2023-08-01' and sc.Num_PBMC_Vials_For_FNL > 0)) # and  sc.Serum_Volume_For_FNL > 0))






#left join  `seronetdb-Vaccine_Response`.Accrual_Visit_Info as av
#	on av.Research_Participant_ID = nv.Research_Participant_ID and av.Visit_Number = nv.Accrual_Visit_Num
