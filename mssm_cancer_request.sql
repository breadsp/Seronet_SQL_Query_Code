select distinct * from
	(SELECT p.Research_Participant_ID, p.Age, p.Sex_At_Birth, `SEER Category`, samp.*, pc.*
	FROM `seronetdb-Vaccine_Response_v2`.Normalized_Cancer_Names as ncn
    
		left join (SELECT left(Visit_Info_ID, 9) as 'Part_ID', group_concat( distinct Harmonized_Value SEPARATOR  ' | ') as 'Comorbidity'
		FROM `seronetdb-Vaccine_Response_v2`.Normalized_Comorbidity_Visits
	where Harmonized_Value not in ('Participant does not have Condition (answered No at baseline)', 'Participant did not answer question, Unable to determine if condition exists', 'Condition Not Described')
	group by left(Visit_Info_ID, 9) ) as pc
		
    on left(ncn.Visit_Info_ID, 9) = pc.Part_ID
	left join (
		SELECT  Visit_Info_ID as 'bio_visit', bp.Biorepository_ID, CGR_Aliquot_ID, bc.Volume, bc.`Vial Status`, bc.`Vial Reserved For FNL` ,
			COUNT(CGR_Aliquot_ID) OVER (PARTITION BY Biorepository_ID ORDER BY CGR_Aliquot_ID) AS cnt1,
			sum(bc.Volume) OVER (PARTITION BY Biorepository_ID ORDER BY CGR_Aliquot_ID) AS cumulative_volume 
		   
			FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots as bc
		join  BSI_Parent_Aliquots as bp
			on bp.Biorepository_ID = bc.Biorepository_ID
		join Aliquot as a
			 on a.Aliquot_ID = bp.`Current Label`
		 join Biospecimen as bio
			on bio.Biospecimen_ID = a.Biospecimen_ID
		where bc.`Vial Reserved For FNL` = 'No: Available to Community' and bc.`Vial Status` = 'In') as samp
	on ncn.Visit_Info_ID = samp.bio_visit
    left join Participant as p
		on p.Research_Participant_ID = left(ncn.Visit_Info_ID, 9)
	where `SEER Category` in ('Breast Cancer', 'Prostate Cancer', 'Colorectal Cancer', 'Lung Cancer')) as t
where `Comorbidity` is not NULL and cumulative_volume is not NULL
order by Research_Participant_ID ASC, cnt1 ASC