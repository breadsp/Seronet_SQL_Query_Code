select * from 

	(select p.Research_Participant_ID, p.Seronet_Participant_ID, p.Age, p.Race, p.Gender, bio.Biospecimen_ID, bio.Biospecimen_Type, bp.`Vial Status` as 'Parent Vial Status',  bp.Biorepository_ID,
		 bc.`Vial Status` as 'Child Vial Status', bc.CGR_Aliquot_ID, bc.Volume, Is_Symptomatic, Symptoms_Resolved, Covid_Disease_Severity,
         case when comorbid.Research_Participant_ID is NULL then 0 else 1 end as 'Has_Comorbid', test.`Test Result`,
		 COUNT(bio.Biospecimen_ID) OVER (PARTITION BY bio.Biospecimen_ID order by bc.CGR_Aliquot_ID) as 'vial_index'
		 
	from  `seronetdb-Validated`.Participant as p
		left join `seronetdb-Validated`.Reference_Panel_Data as panel
	on p.Research_Participant_ID = panel.`Participant ID`
		left join `seronetdb-Validated`.Biospecimen as bio
	on p.Research_Participant_ID = bio.Research_Participant_ID
		left join `seronetdb-Validated`.Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
		left join `seronetdb-Validated`.BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.CBC_Biospecimen_Aliquot_ID
		left join `seronetdb-Validated`.BSI_Child_Aliquots as bc
	on bp.Biorepository_ID = bc.Biorepository_ID
		left join (Select distinct Research_Participant_ID from `seronetdb-Validated`.Participant_Comorbidity_Reported) as comorbid
	on p.Research_Participant_ID = comorbid.Research_Participant_ID
		left join  `seronetdb-Validated`.Prior_Covid_Outcome as pc
	on p.Research_Participant_ID = pc.Research_Participant_ID
		left join (
			SELECT Research_Participant_ID,  sum(case when lower(Interpretation) like 'positive' then 10 else -1 end) as 'Test Result'
				from `seronetdb-Validated`.Confirmatory_Clinical_Test
			where Assay_Target_Organism like 'SARS%'
			group by Research_Participant_ID) as test
	on p.Research_Participant_ID = test.Research_Participant_ID

	where p.Age >= 18    #particicipants at 18 or older
	and p.Race in ('White', 'Black or African American')  #only include white or black/africian race
    and panel.`Participant ID` is NULL   #remove any participant that was part of the reference panel
	and comorbid.Research_Participant_ID is NULL #remove any participant with a reported comorbidity
	and ((bio.Biospecimen_Type = 'Serum' and bc.`Vial Status` = 'In') or (bio.Biospecimen_Type = 'PBMC' and bp.`Vial Status` = 'In' and `Parent FNL Reserve Flag` = 'No'))   #vial is not FNL reserve and child vial is in BSI
    ) as sample
where sample.`Vial_Index` <= 2