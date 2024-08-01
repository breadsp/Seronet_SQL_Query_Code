SELECT distinct 
	 p.Age , p.Race, p.Ethnicity,
    case when p.Sex_At_Birth is not NULL and p.Sex_At_Birth in ('Male', 'Female') then p.Sex_At_Birth
         else "Unknown/Not Reported" end  as 'Reported Sex',  p.Sunday_Prior_To_First_Visit as "Sunday Prior to Baseline Visit",
	
    month(p.Sunday_Prior_To_First_Visit) as 'Month of Baseline Visit',
    Year(p.Sunday_Prior_To_First_Visit) as 'Year of Baseline Visit',
    nv.Research_Participant_ID as 'Participant Count',
    nv.*, 
    
    case when p.Sunday_Prior_To_First_Visit is NULL then NULL else sc.Date_Of_Event end as Date_Of_Visit
##############################################################################################################################################################################
from `seronetdb-Vaccine_Response`.Participant as p			#take all participants that have data submitted

join `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination as nv
	on p.Research_Participant_ID = nv.Research_Participant_ID

join `seronetdb-Vaccine_Response`.Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index

group by nv.Research_Participant_ID, nv.Normalized_Visit_Index