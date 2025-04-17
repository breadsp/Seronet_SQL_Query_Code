SELECT pc.Research_Participant_ID, pc.Old_Cohort_Name, pc.SeroNet_Cohort,  	
	case when GROUP_CONCAT(distinct concat(cc.Cancer, " (", cc.Cancer_Provenance, ")")  SEPARATOR " | " )  is NULL then "No" else "Yes" end as 'Has Cancer Cohort Data',
    case when GROUP_CONCAT(distinct concat(ncc.Cancer, " (", ncc.Cancer_Provenance, ")")  SEPARATOR " | " )  is NULL then "No" else "Yes" end as 'Non Cancerous Data',
    
	case when GROUP_CONCAT( distinct `Organ Transplant` SEPARATOR  " | ") is NULL then "No" else "Yes" end as 'Has Tranplant Cohort Data',
    case when GROUP_CONCAT( distinct hc.Visit_Info_ID SEPARATOR  " | ") is NULL then "No" else "Yes" end as 'Has HIV Cohort Data',
    case when GROUP_CONCAT( distinct ac.Autoimmune_Condition SEPARATOR  " | ") is NULL then "No" else "Yes" end as 'Has Autoimmune Cohort Data',
    
    case when Cancerco = 0 then "No" else "Yes" end as 'Cancer Comorbidity'
    
    
	FROM `seronetdb-Vaccine_Response_v2`.Participant_Cohort as pc
left join Cancer_Cohort as cc
	on pc.Research_Participant_ID = left(cc.Visit_Info_ID,9)
left join HIV_Cohort as hc
	on pc.Research_Participant_ID = left(hc.Visit_Info_ID,9)
left join AutoImmune_Cohort as ac
	on pc.Research_Participant_ID = left(ac.Visit_Info_ID,9)
left join Non_Cancer_Cohort as ncc
	on pc.Research_Participant_ID = left(ncc.Visit_Info_ID,9)
    
left join (SELECT Visit_Info_ID, Cancer_Description_Or_ICD10_codes FROM Participant_Comorbidities_Names
	where Cancer_Description_Or_ICD10_codes not in ('No', 'Unknown', 'Not Reported', 'N/A', 'Status Unknown')) as Comorbid_Cancer
	on pc.Research_Participant_ID = left(Comorbid_Cancer.Visit_Info_ID,9)

left join (Select * from Participant_Other_Condition_Names
	where Organ_Transplant_Description_Or_ICD10_codes not in ('No', 'Unknown', 'Not Reported', 'N/A', 'Status Unknown')) as pon
	on pc.Research_Participant_ID = left(pon.Visit_Info_ID , 9)
left join Organ_Transplant_Cohort as otc
	on pc.Research_Participant_ID = left(otc.Visit_Info_ID, 9)

left join Withdrawn_List as wl
	on pc.Research_Participant_ID = wl.Research_Participant_ID
    
#left join (SELECT left(Visit_Info_ID,9) as 'Part_ID' , sum(case when Cancer in ('Yes', 'New Condition') then 1 else 0 end) as 'Cancerco'
#	 FROM `seronetdb-Vaccine_Response_v2`.Participant_Comorbidities_Status
#	 group by left(Visit_Info_ID,9) ) as has_Cancer
# on has_Cancer.Part_ID = pc.Research_Participant_ID

where wl.Research_Participant_ID is NULL
group by pc.Research_Participant_ID, pc.Old_Cohort_Name, pc.SeroNet_Cohort