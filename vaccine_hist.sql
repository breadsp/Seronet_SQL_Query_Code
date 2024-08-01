# 	Date of vaccine	

Select p.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Visit_Info_ID, nv.Normalized_Sample_Index as 'Sample Collected for Visit',   cv.Vaccination_Status, 
	case when cv.Vaccination_Status like '%Bivalent' then left(cv.Vaccination_Status, length(cv.Vaccination_Status)-9)
		 when cv.Vaccination_Status like '%Monovalent XBB.1.5' then left(cv.Vaccination_Status, length(cv.Vaccination_Status)-19)
         when cv.Vaccination_Status in ("", "No vaccination event reported", "Unvaccinated") then "No vaccination event reported"
         when cv.Vaccination_Status is NULL then "No vaccination event reported"
		 else  cv.Vaccination_Status end as 'New Vaccine Cat', cv.`SARS-CoV-2_Vaccine_Type`,  
       
         date_add(p.Sunday_Prior_To_First_Visit, interval  (pv.Visit_Date_Duration_From_Index - vo.Offset_Value) day) as 'Date_of_visit',
         date_add(p.Sunday_Prior_To_First_Visit, interval  (cv.`SARS-CoV-2_Vaccination_Date_Duration_From_Index` - vo.Offset_Value) day) as 'Date_of_vaccine'
         
         
         #cv.`SARS-CoV-2_Vaccination_Date_Duration_From_Index`, cv.Covid_Vaccination_Status_Comments,
		 #vo.Offset_Value, p.Sunday_Prior_To_First_Visit
	from Participant as p
left join Participant_Visit_Info as pv
	on p.Research_Participant_ID = pv.Research_Participant_ID
left join Covid_Vaccination_Status as cv
	on pv.Visit_Info_ID = cv.Visit_Info_ID
left join Visit_One_Offset_Correction as vo
	on p.Research_Participant_ID = vo.Research_Participant_ID
left join Normalized_Visit_Vaccination as nv
	on pv.Visit_Info_ID = nv.Visit_Info_ID
where Covid_Vaccination_Status_Comments not in ('Vaccine Status does not exist, input error', 'Record previously submitted in error.', 'Record previously submitted: Duplicated.')
			or Covid_Vaccination_Status_Comments is NULL