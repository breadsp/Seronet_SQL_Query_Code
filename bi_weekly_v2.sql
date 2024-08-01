select nv.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Primary_Cohort, sc.Date_Of_Event, nv.Data_Status, 
    case when Serum_Volume_Rec > 0 then Serum_Volume_Rec
         when (spec.`Serum_Volume Submitted` - spec.`Serum_errors`)  > 0 then (spec.`Serum_Volume Submitted` - spec.`Serum_errors`)
         when (av.Serum_Volume_For_FNL - spec.`Serum_errors`) < 0 then 0
         else (av.Serum_Volume_For_FNL - spec.`Serum_errors`) end as 'FNL_Serum_Accrual',
	case when Serum_Volume_Rec > 0 then Serum_Volume_Rec
         else (spec.`Serum_Volume Submitted` - spec.`Serum_errors`) end as 'Serum_Volume Submitted', 
		spec.`Serum_Volume_Rec`, spec.`Serum_errors`, spec.Serum_Manifest, spec.`Serum_Volume_on_Manifest`,
        
	case when PBMC_Vials_Rec > 0 then PBMC_Vials_Rec
         when (spec.`PBMC_Vials_Rec` - spec.`PBMC_errors`)  > 0 then (spec.`PBMC_Vials_Rec` - spec.`PBMC_errors`)
         when (av.Num_PBMC_Vials_For_FNL - spec.`PBMC_errors`) < 0 then 0
         else (av.Num_PBMC_Vials_For_FNL - spec.`PBMC_errors`) end as 'FNL_PBMC_Accrual',
	case when PBMC_Vials_Rec > 0 then PBMC_Vials_Rec
         else (spec.`PBMC_Vials Submitted` - spec.`PBMC_errors`) end as 'PBMC Vials Submitted', 
		spec.`PBMC_Vials_Rec`, spec.PBMC_Manifest, spec.`PBMC_Vials_on_Manifest`
    
from  Normalized_Visit_Vaccination as nv
join Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index
left join Accrual_Visit_Info as av
	on nv.Research_Participant_ID = av.Research_Participant_ID and nv.Accrual_Visit_Num = av.Visit_Number
left join(
		select bio.Visit_Info_ID, a.Aliquot_ID, bio.Biospecimen_Type,
							  sum(case when bio.Biospecimen_Type = 'Serum' then a.Aliquot_Volume else 0 end) as 'Serum_Volume Submitted',
							  sum(case when bio.Biospecimen_Type = 'Serum' and bp.Biorepository_ID is not NULL then a.Aliquot_Volume else 0 end) as 'Serum_Volume_Rec',
                              sum(case when bio.Biospecimen_Type = 'Serum' and a.Samples_Not_Useable is not NULL then a.Aliquot_Volume else 0 end) as 'Serum_errors',
                              (case when bio.Biospecimen_Type = 'Serum' then sm.Submission_Index end) as 'Serum_Manifest',
                              sum(case when bio.Biospecimen_Type = 'Serum' and sm.Submission_Index > 0 then a.Aliquot_Volume else 0 end) as 'Serum_Volume_on_Manifest',
                              
                              sum(case when bio.Biospecimen_Type = 'PBMC' then 1 else 0 end) as 'PBMC_Vials Submitted',
							  sum(case when bio.Biospecimen_Type = 'PBMC' and bp.Biorepository_ID is not NULL then 1 else 0 end) as 'PBMC_Vials_Rec',
							  sum(case when bio.Biospecimen_Type = 'PBMC' and a.Samples_Not_Useable is not NULL then a.Aliquot_Volume else 0 end) as 'PBMC_errors',
                              (case when bio.Biospecimen_Type = 'PBMC' then sm.Submission_Index end) as 'PBMC_Manifest',
                              sum(case when bio.Biospecimen_Type = 'PBMC' and sm.Submission_Index > 0 then a.Aliquot_Volume else 0 end) as 'PBMC_Vials_on_Manifest'

    from Biospecimen as bio
    join Aliquot as a
    on bio.Biospecimen_ID = a.Biospecimen_ID
    left join BSI_Parent_Aliquots as bp
		on a.Aliquot_ID = bp.`Current Label`
	left join Shipping_Manifest as sm
		on a.Aliquot_ID = sm.`Current Label`
	where a.Samples_Not_Useable is NULL
    group by bio.Visit_Info_ID) as spec
on nv.Visit_Info_ID = spec.Visit_Info_ID
where nv.Research_Participant_ID like '27_414744%'

