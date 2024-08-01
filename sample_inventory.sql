SELECT left(nv.Research_Participant_ID, 2) as CBC_ID, nv.Primary_Cohort, nv.Research_Participant_ID, nv.`SARS-CoV-2_Vaccine_Type`,
	nv.Duration_Between_Vaccine_and_Visit, sc.Date_Of_Event, sum(case when bio.Biospecimen_Type = 'Serum' then 1 else 0 end) as 'Serum Samples',
    sum(case when bio.Biospecimen_Type = 'PBMC' then 1 else 0 end) as 'PBMC Samples',
   case when nv.Duration_Between_Vaccine_and_Visit is NULL then "No Vaccine"
		when  nv.`SARS-CoV-2_Vaccine_Type`= 'No Vaccination Data Reported' then "No Vaccine"
		when nv.Duration_Between_Vaccine_and_Visit >= (30-15) and nv.Duration_Between_Vaccine_and_Visit < (30+45) then "30 day window"
        when nv.Duration_Between_Vaccine_and_Visit >= (60-15) and nv.Duration_Between_Vaccine_and_Visit < (60+45) then "60 day window"
        when nv.Duration_Between_Vaccine_and_Visit >= (90-15) and nv.Duration_Between_Vaccine_and_Visit < (90+45) then "90 day window"
		when nv.Duration_Between_Vaccine_and_Visit >= (180-15) and nv.Duration_Between_Vaccine_and_Visit < (180+45) then "180 day window"
		when nv.Duration_Between_Vaccine_and_Visit >= (360-15) and nv.Duration_Between_Vaccine_and_Visit < (360+45) then "360 day window"
        when nv.Duration_Between_Vaccine_and_Visit >= (540-15) and nv.Duration_Between_Vaccine_and_Visit < (540+45) then "540 day window"
        else "out of window" end as 'Time window'
        
	FROM `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination as nv
join Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index
join Biospecimen as bio
	on nv.Visit_Info_ID = bio.Visit_Info_ID
join Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
where sc.Date_Of_Event <= '2023-09-30' and nv.Research_Participant_ID = '14_P42902'
group by nv.Primary_Cohort,	nv.Research_Participant_ID,	nv.`SARS-CoV-2_Vaccine_Type`,	nv.Duration_Between_Vaccine_and_Visit,	sc.Date_Of_Event

