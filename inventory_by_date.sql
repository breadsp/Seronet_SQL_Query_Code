SELECT av.Primary_Cohort, av.Research_Participant_ID, av.Visit_Number, nv.Accrual_Visit_Num, 
	Date_add(ap.Sunday_Prior_To_Visit_1, INTERVAL av.Visit_Date_Duration_From_Visit_1 DAY) as "Date of Collection",
    month(Date_add(ap.Sunday_Prior_To_Visit_1, INTERVAL av.Visit_Date_Duration_From_Visit_1 DAY)) as "Month of Collection",
    year(Date_add(ap.Sunday_Prior_To_Visit_1, INTERVAL av.Visit_Date_Duration_From_Visit_1 DAY)) as "Year of Collection",
    collect_s.Visit_Info_ID, collect_s.Biospecimen_ID as 'Serum_ID',
    case when collect_s.`Serum Volume Collected` is NULL then  av.Serum_Volume_For_FNL else collect_s.`Serum Volume Collected` end as 'Total Serum Volume Collected',
    case when collect_s.`Serum Vials Received` is NULL then  0 #no data
		when collect_s.`Serum Vials Received` = 0 and collect_s.Submission_Index is NULL then 0  #have data and manifest
		when collect_s.`Serum Vials Received` = 0 and collect_s.Submission_Index >= 172 then 1  #have data and manifest
		else 1 end as 'Serum_Vials Received',
	
    collect_p.Visit_Info_ID, collect_p.Biospecimen_ID as 'PBMC_ID',
    case when collect_p.`PBMC Vials Collected` is NULL then  av.Num_PBMC_Vials_For_FNL else collect_p.`PBMC Vials Collected` end as 'Total PBMC Vials Collected',
    case when collect_p.`PBMC Vials Received` is NULL then  0 #no data
		when collect_p.`PBMC Vials Received` = 0 and collect_p.Submission_Index is NULL then 0  #have data and manifest
		when collect_p.`PBMC Vials Received` = 0 and collect_p.Submission_Index >= 172 then 1  #have data and manifest
		else 1 end as 'PMBC_Vials Received'

    FROM `seronetdb-Vaccine_Response`.Accrual_Visit_Info as av
join Accrual_Participant_Info as ap
	on av.Research_Participant_ID = ap.Research_Participant_ID
left join Normalized_Visit_Vaccination as nv
	on av.Research_Participant_ID = nv.Research_Participant_ID and av.Visit_Number = nv.Accrual_Visit_Num
left join (select bio.Visit_Info_ID, bio.Biospecimen_ID, # a.Samples_Not_Useable, a.Aliquot_Volume , bp.Biorepository_ID, a.Aliquot_ID
		sum(case when a.Samples_Not_Useable is NULL then 1 else 0 end) as 'Submitted_Samples',
        round(sum(case when a.Samples_Not_Useable is NULL then a.Aliquot_Volume else 0 end),2) as 'Serum Volume Collected',
		sum(case when a.Samples_Not_Useable is NULL and bp.Biorepository_ID is not NULL then 1 else 0 end) as 'Serum Vials Received', ship.Submission_Index
    from Biospecimen as bio
    join Aliquot as a
		on bio.Biospecimen_ID = a.Biospecimen_ID
	left join Shipping_Manifest as ship
		on a.Aliquot_ID = ship.`Current Label`
    left join BSI_Parent_Aliquots as bp
		on a.Aliquot_ID = bp.`Current Label`
    where bio.Biospecimen_Type = 'Serum'# and bio.Visit_Info_ID = '27_200011 : B01'
    group by bio.Visit_Info_ID) as collect_s
on nv.Visit_Info_ID = collect_s.Visit_Info_ID

left join (
	select bio.Visit_Info_ID, bio.Biospecimen_ID, count(a.Aliquot_Volume) as 'PBMC Vials Collected',
		count(bp.Biorepository_ID) as 'PBMC Vials Received', ship.Submission_Index
    from Biospecimen as bio
    join Aliquot as a
		on bio.Biospecimen_ID = a.Biospecimen_ID
	left join Shipping_Manifest as ship
		on a.Aliquot_ID = ship.`Current Label`
    left join BSI_Parent_Aliquots as bp
		on a.Aliquot_ID = bp.`Current Label`
    where bio.Biospecimen_Type = 'PBMC' and a.Samples_Not_Useable is NULL
    group by bio.Visit_Info_ID) as collect_p
on nv.Visit_Info_ID = collect_p.Visit_Info_ID
    
where av.Research_Participant_ID like '27_%'