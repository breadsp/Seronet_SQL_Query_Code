Select `Vial Status`, `Vial Reserved For FNL`, `Last Req ID`, count(Biorepository_ID) as 'Child Vial Count', 
		sum(case when `Vial Warnings` = 'Vial Reserved for FNL Research' then 1 else 0 end) as 'Has Reserved Flag'
from
	(Select `Vial Status`, `Vial Reserved For FNL`, `Vial Warnings`,
			case when `Vial Status` = 'Out' then  `Last Requisition ID` else "" end as 'Last Req ID',  Biorepository_ID
	FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots) t
group by `Vial Status`, `Vial Reserved For FNL`, `Last Req ID`
order by `Vial Status`, `Vial Reserved For FNL`, `Last Req ID`;