SELECT pv.Research_Participant_ID, pv.Primary_Study_Cohort, p.Age, p.Sex_At_Birth, p.Race, pv.Visit_Info_ID, 
	nv.`SARS-CoV-2_Vaccine_Type`, nv.Vaccination_Status, nv.Duration_Between_Vaccine_and_Visit,
	bio.Biospecimen_ID, bp.`Current Label`, bp.Biorepository_ID, bp.`Material Type`, bp.`Vial Status`, bp.Volume, bp.`Volume Unit`, 
	case when bc.`# of child aliquots` is NULL then 0 else bc.`# of child aliquots` end as '# of child aliquots'
	FROM `seronetdb-Vaccine_Response`.BSI_Parent_Aliquots as bp
join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID			    #get the aliquot data and merge with the parent table
left join Biospecimen as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID		   #get biospecimen data and link to the aliquot data
left join Participant_Visit_Info as pv
	on bio.Visit_Info_ID = pv.Visit_Info_ID		     #use visit info table to get participant ID and visit id
left join Participant as p
	on pv.Research_Participant_ID = p.Research_Participant_ID  #use Participant table to get age, sex, race
left join Normalized_Visit_Vaccination as nv
	on pv.Visit_Info_ID = nv.Visit_Info_ID
    
left join (select Biorepository_ID, count(CGR_Aliquot_ID) as '# of child aliquots' from BSI_Child_Aliquots group by Biorepository_ID) as bc  #group the child data to show total number of child aliquots
	on bp.Biorepository_ID = bc.Biorepository_ID		#join the parent table with the child table

where `Material Type` = 'SERUM'