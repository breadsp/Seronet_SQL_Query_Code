# 	Primary Cohort	Visit Info ID	SARS-CoV-2 Vaccine Type	Vaccination Status	Duration Between Vaccine and Visit
select p.Research_Participant_ID, p.Age, p.Sex_At_Birth, p.Race, nv.Primary_Cohort, nv.Visit_Info_ID, 
	nv.`SARS-CoV-2_Vaccine_Type`, nv.Vaccination_Status, nv.Duration_Between_Vaccine_and_Visit, bp.Biorepository_ID, bp.`Vial Status`
    from Participant as p
join Normalized_Visit_Vaccination as nv
	on p.Research_Participant_ID = nv.Research_Participant_ID
join Biospecimen as bio
	on nv.Visit_Info_ID = bio.Visit_Info_ID
join Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`
#where p.Research_Participant_ID = '27_201545'
where p.Age >= (35-5) and p.age <= (35+5) and
	p.Sex_At_Birth = 'Male' and
    p.Race = 'White' and 
    nv.Primary_Cohort = 'Healthy Control' and
    nv.`SARS-CoV-2_Vaccine_Type` = 'Pfizer' and
    nv.Vaccination_Status = 'Dose 2 of 2' #and
   # nv.Duration_Between_Vaccine_and_Visit >= (97-15) and nv.Duration_Between_Vaccine_and_Visit <= (97+15)