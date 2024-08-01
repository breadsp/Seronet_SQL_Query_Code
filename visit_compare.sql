select ap.Research_Participant_ID, acc_data.Acc_Visits, sub_data.Submitted_Visits
from Accrual_Participant_Info as ap
left join(
	SELECT Research_Participant_ID, count(Visit_Number) as "Acc_Visits"
	FROM `seronetdb-Vaccine_Response`.Accrual_Visit_Info as av
	where (Serum_Shipped_To_FNL not in ('N/A') or PBMC_Shipped_To_FNL not in ('N/A'))
	group by Research_Participant_ID) as acc_data
on ap.Research_Participant_ID = acc_data.Research_Participant_ID

left join (SELECT Research_Participant_ID, count(Visit_Number) as "Submitted_Visits"
	FROM `seronetdb-Vaccine_Response`.Participant_Visit_Info
    where Unscheduled_Visit not in ('Yes')
	group by  Research_Participant_ID) as sub_data
on ap.Research_Participant_ID = sub_data.Research_Participant_ID
where ap.Research_Participant_ID like '41_%'