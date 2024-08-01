SELECT c.CBC_Name, p.Research_Participant_ID, p.Sex_At_Birth, p.Sunday_Prior_To_First_Visit,
	   case when Primary_Cohort in ('IBD', 'Autoimmune') then 'Autoimmune'
		    when Primary_Cohort in ('Chronic Conditions', 'Convalescent', 'Inflammatory', 'Healthy Control') then 'Healthy Control'
            else Primary_Cohort end as Primary_Cohort, nv.Normalized_Visit_Index, pv.Visit_Info_ID,  pv.Type_Of_Visit, pv.Visit_Date_Duration_From_Index,
			vacc.*
	FROM `seronetdb-Vaccine_Response`.Participant as p
left join Participant_Visit_Info as pv
	on p.Research_Participant_ID = pv.Research_Participant_ID
left join CBC as c
	on left(pv.Visit_Info_ID, 2) = c.CBC_ID
left join Normalized_Visit_Vaccination as nv
	on pv.Visit_Info_ID = nv.Visit_Info_ID
    
left join (SELECT pv.Research_Participant_ID, pv.Vaccination_Status, pv.`SARS-CoV-2_Vaccination_Date_Duration_From_Index`, pv.Covid_Vaccination_Status_Comments
	FROM `seronetdb-Vaccine_Response`.Covid_Vaccination_Status as pv
where pv.`SARS-CoV-2_Vaccination_Date_Duration_From_Index` = '0' and (pv.Covid_Vaccination_Status_Comments is NULL or 
			pv.Covid_Vaccination_Status_Comments not in ('Vaccine Status does not exist, input error', 'Record previously submitted in error.'))
) as vacc
	on pv.Research_Participant_ID = vacc.Research_Participant_ID
where pv.Visit_Number = '1'

