SELECT av.Primary_Cohort, av.Research_Participant_ID, av.Visit_Number,
	Date_add(ap.Sunday_Prior_To_Visit_1, INTERVAL av.Visit_Date_Duration_From_Visit_1 DAY) as "Date of Collection",
    month(Date_add(ap.Sunday_Prior_To_Visit_1, INTERVAL av.Visit_Date_Duration_From_Visit_1 DAY)) as "Month of Collection",
    year(Date_add(ap.Sunday_Prior_To_Visit_1, INTERVAL av.Visit_Date_Duration_From_Visit_1 DAY)) as "Year of Collection",
    case when serum.`Serum_Vials_Collected` > 0 then serum.`Serum_Vials_Collected` 
		 when av.Serum_Volume_For_FNL then 1   #assume 1 vial per visit if only on accrual
		 else 0 end as 'Serum Vials Collected',  #if accrual is N/A then no vial collected
    case when serum.`Serum Volume Received` > 0 then serum.`Serum Volume Received` else av.Serum_Volume_For_FNL end as 'Serum Volume Collected',
    serum.Biospecimen_ID as 'Serum_ID', serum.`Serum Volume Received`, serum.Submission_Index
    
    FROM `seronetdb-Vaccine_Response`.Accrual_Visit_Info as av
join Accrual_Participant_Info as ap
	on av.Research_Participant_ID = ap.Research_Participant_ID
left join Normalized_Visit_Vaccination as nv
	on av.Research_Participant_ID = nv.Research_Participant_ID and av.Visit_Number = nv.Accrual_Visit_Num
    
left join (select bio.Visit_Info_ID, bio.Biospecimen_ID,Submission_Index, 
		sum(case when a.Samples_Not_Useable is NULL  then 1 else 0 end) as 'Serum_Vials_Collected',
        round(sum(case when a.Samples_Not_Useable is NULL  and bp.Biorepository_ID is not NULL then a.Aliquot_Volume else 0 end),2) as 'Serum Volume Received'
    from Biospecimen as bio
    join Aliquot as a
		on bio.Biospecimen_ID = a.Biospecimen_ID
    left join BSI_Parent_Aliquots as bp
		on a.Aliquot_ID = bp.`Current Label`
	left join Shipping_Manifest as sm
		on a.Aliquot_ID = sm.`Current Label`
    where bio.Biospecimen_Type = 'Serum' and bio.Visit_Info_ID like '32_%'
		and (bp.`Vial Status` is NULL or bp.`Vial Status` in ('In', 'Empty', 'Out', 'Reserved'))
    group by bio.Visit_Info_ID) as serum
on serum.Visit_Info_ID = nv.Visit_Info_ID
where av.Research_Participant_ID like '32_%'