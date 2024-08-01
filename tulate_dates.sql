SELECT pv.Visit_Info_ID, date_add(p.Sunday_Prior_To_First_Visit, interval (pv.Visit_Date_Duration_From_Index - vo.Offset_Value) day) as 'Date_of_Visit', nv.Normalized_Visit_Index,
	nv.Duration_From_Visit_1, nv.`SARS-CoV-2_Vaccine_Type`, nv.Vaccination_Status, btr.Assay_ID,
    date_add(p.Sunday_Prior_To_First_Visit, interval (pv.Visit_Date_Duration_From_Index - vo.Offset_Value - nv.Duration_Between_Vaccine_and_Visit) day) as 'Date_of_Vaccination',
    btr.Assay_Target_Organism, btr.Assay_Target, btr.Assay_Target_Sub_Region, btr.Interpretation,
    ch.Average_Duration_Of_Test, ch.COVID_Status
	FROM `seronetdb-Vaccine_Response`.Participant_Visit_Info as pv
join Participant as p
	on pv.Research_Participant_ID = p.Research_Participant_ID
join Visit_One_Offset_Correction as vo
	on p.Research_Participant_ID = vo.Research_Participant_ID
join Normalized_Visit_Vaccination as nv
	on nv.Visit_Info_ID = pv.Visit_Info_ID
join Biospecimen_Test_Results as btr
	on nv.Visit_Info_ID = btr.Visit_Info_ID
left join Covid_History as ch
	on nv.Visit_Info_ID = ch.Visit_Info_ID
where pv.Research_Participant_ID = '14_M92328'