SELECT  nv.Research_Participant_ID, nv.Primary_Cohort, #, nv.Normalized_Visit_Index, nv.Visit_Info_ID, nv.Data_Status, sc.Date_Of_Event #, bio.`Serum Data`, bio.`PBMC Data`
	nv.Vaccination_Status, nv.`SARS-CoV-2_Vaccine_Type`, nv.Duration_Between_Vaccine_and_Visit
FROM `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination as nv
	join Participant as p
on nv.Research_Participant_ID = p.Research_Participant_ID
left join Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index
#left join (select Visit_Info_ID, sum(case when Biospecimen_Type = 'Serum' then 1 else 0 end) as 'Serum Data',
#								 sum(case when Biospecimen_Type = 'PBMC' then 1 else 0 end) as 'PBMC Data'
#	from Biospecimen
#    where Biospecimen_Comments not in ('Previously submitted in error', 'Vials were mislabeled in initial submission.') or Biospecimen_Comments is NULL
#    group by Visit_Info_ID) as bio
#on nv.Visit_Info_ID = bio.Visit_Info_ID
#where p.Sunday_Prior_To_First_Visit is not NULL and p.Research_Participant_ID not in ('32_441133', '32_221138', '32_331044') and nv.Data_Status like 'Submitted%' 
#	and Vaccination_Status = 'Unvaccinated' and `SARS-CoV-2_Vaccine_Type` not in ('N/A')