
SELECT av.Research_Participant_ID, av.Visit_Number, nv.Primary_Cohort, date_add(Sunday_Prior_To_Visit_1,  Interval av.Visit_Date_Duration_From_Visit_1 day) as 'Date_Collected',nv.Data_Status,
	case when av.Serum_Volume_For_FNL < spec.Serum_Volume  then  spec.Serum_Volume else av.Serum_Volume_For_FNL end as Serum_Volume_For_FNL , 
    case when av.Num_PBMC_Vials_For_FNL < spec.PBMC_Vials  then  spec.PBMC_Vials else av.Num_PBMC_Vials_For_FNL end as Num_PBMC_Vials_For_FNL, spec.*
FROM `seronetdb-Vaccine_Response`.Accrual_Visit_Info as av
	join Accrual_Participant_Info as ap
on av.Research_Participant_ID = ap.Research_Participant_ID
	left join Normalized_Visit_Vaccination as nv
on av.Research_Participant_ID = nv.Research_Participant_ID and av.Visit_Number = nv.Accrual_Visit_Num
left join (
	select bio.Visit_Info_ID, sum(case when bio.Biospecimen_Type = 'Serum' then a.Aliquot_Volume else 0 end) as 'Serum_Volume',
							  sum(case when bio.Biospecimen_Type = 'PBMC' then 1 else 0 end) as 'PBMC_Vials',
                              sum(case when bio.Biospecimen_Type = 'Serum' and bp.Biorepository_ID is not NULL then a.Aliquot_Volume else 0 end) as 'Serum_Volume_Rec',
							  sum(case when bio.Biospecimen_Type = 'PBMC' and bp.Biorepository_ID is not NULL then 1 else 0 end) as 'PBMC_Vials_Rec',
                              
                              sum(case when bio.Biospecimen_Type = 'Serum' and a.Samples_Not_Useable is not NULL then a.Aliquot_Volume else 0 end) as 'Serum_errors',
							  sum(case when bio.Biospecimen_Type = 'PBMC' and a.Samples_Not_Useable is not NULL then a.Aliquot_Volume else 0 end) as 'PBMC_errors'
                              
    from Biospecimen as bio
    join Aliquot as a
    on bio.Biospecimen_ID = a.Biospecimen_ID
    left join BSI_Parent_Aliquots as bp
		on a.Aliquot_ID = bp.`Current Label`
	#where a.Samples_Not_Useable is NULL
    group by bio.Visit_Info_ID) as spec
on nv.Visit_Info_ID = spec.Visit_Info_ID
#where av.Research_Participant_ID like '41_%';