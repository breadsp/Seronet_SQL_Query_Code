SELECT  left(nv.Research_Participant_ID,2) as 'CBC_ID', nv.Research_Participant_ID, nv.Primary_Cohort, nv.Normalized_Visit_Index, sc.Date_Of_Event,
	case when nv.Accrual_Visit_Num is NULL then -1 else nv.Accrual_Visit_Num end as Accrual_Visit_Num,  #data submitted but not in accural gets a -1 flag
	nv.Visit_Info_ID, bio.Biospecimen_ID, bio.Biospecimen_Type, a.Aliquot_ID, a.Aliquot_Volume, bp.Biorepository_ID, sm.Submission_Index, a.Samples_Not_Useable,
	case when Biospecimen_Type = 'PBMC' then 0
		 when Aliquot_Volume > 0 and Biospecimen_Type = 'Serum' then Aliquot_Volume
		 when av.Serum_Volume_For_FNL is NULL then 0
	 	 when av.Serum_Volume_For_FNL = 'N/A' then 0
         #when Biospecimen_Type is NULL and sc.Date_Of_Event < '2023-10-01' then 0
		 else av.Serum_Volume_For_FNL end as Serum_Volume_For_FNL,
    
    case when Biospecimen_Type = 'Serum' then 0
		 when Biospecimen_Type = 'PBMC' then 1
         when av.Num_PBMC_Vials_For_FNL is NULL then 0
	 	 when av.Num_PBMC_Vials_For_FNL = 'N/A' then 0 
         #when Biospecimen_Type is NULL and sc.Date_Of_Event < '2023-10-01' then 0
		 else av.Num_PBMC_Vials_For_FNL end as Num_PBMC_Vials_For_FNL
          
	FROM `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination as nv
left join  `seronetdb-Vaccine_Response`.Accrual_Visit_Info as av
	on av.Research_Participant_ID = nv.Research_Participant_ID and av.Visit_Number = nv.Accrual_Visit_Num
left join Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index
left join Biospecimen as bio
	on nv.Visit_Info_ID = bio.Visit_Info_ID
left join Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
left join (select * from BSI_Parent_Aliquots
	group by  `Current Label`) as bp
	on a.Aliquot_ID = bp.`Current Label`
left join Shipping_Manifest as sm
	on a.Aliquot_ID = sm.`Current Label`
where nv.Research_Participant_ID like '%'  #sm.Submission_Index = 220 and
	
    and (a.Aliquot_ID is not NULL) or (a.Aliquot_ID is NULL and Biospecimen_Type is NULL)
    #and a.Samples_Not_Useable is NULL  	
	#(nv.Visit_Info_ID is not NULL or (nv.Visit_Info_ID is NULL and sc.Date_Of_Event >= '2023-11-01') )
    
    #and bp.Biorepository_ID is NULL and Biospecimen_Type = 'PBMC'  and  sm.Submission_Index is NULL
    #Aliqouts without any errors
    #(bio.Biospecimen_Type = 'Serum' or (bio.Biospecimen_Type is NULL and av.Serum_Volume_For_FNL > 0)) and      #either has specimen or an accural value
	#(nv.Visit_Info_ID is NULL or (bio.Visit_Info_ID is not NULL and a.Aliquot_ID is not NULL))  				#if has visit then has to have aliquot
