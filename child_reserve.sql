select Visit_Info_ID,
	 round(sum(case when `Parent Status` in ('Out') and all_samp.`Total Child Volume` is NULL then `Remining Parent Volume`
				 when `Parent Status` in ('Out') and all_samp.`Total Child Volume` is not NULL then `Total Child Volume`
                 when all_samp.`Total Child Volume` is NULL then `Remining Parent Volume`
				 else `Total Child Volume` + `Remining Parent Volume` end),1) as 'Total Volume Received',
	 
     round(sum(case when `Parent Status` in ('In', 'Reserved') and `Total Child Volume` is NULL then `Remining Parent Volume` else 0 end),1) as 'Unaliquoted Parent Volume',
     
     sum(case when all_samp.`Used by FNL` is NULL and `Parent Status` = 'Out' then 0 + `Remining Parent Volume`
			  when all_samp.`Used by FNL` is NULL then 0 
			  else `Used by FNL` end) as 'Volume Used by FNL',
     sum(case when all_samp.`Available to FNL` is NULL then 0 else `Available to FNL` end) as 'Volume Available to FNL',
     sum(case when all_samp.`Used by Investigators` is NULL then 0 else `Used by Investigators` end) as 'Volume Used by Investigators',
     sum(case when all_samp.`Available to Investigators` is NULL then 0 else `Available to Investigators` end) as 'Volume Available to Investigators'

from
(
SELECT bio.Visit_Info_ID,  bp.Biorepository_ID as 'Parent ID', bp.`Current Label`, bp.`Vial Status` as 'Parent Status',
case #when bp.`Vial Status` in ('Empty', 'Out')  then 0
	 when bp.Volume < 50 then bp.Volume*1000 
	 else bp.Volume end as 'Remining Parent Volume', bc.*
FROM `seronetdb-Vaccine_Response_v2`.BSI_Parent_Aliquots as bp

left join(
SELECT 
	Biorepository_ID, sum( case when `Vial Status` = 'Destroyed/Broken' then 0 else Volume end) as 'Total Child Volume',
	sum(case when `Vial Status` = 'Out' and `Vial Reserved For FNL` like '%Shipped to FNL%' then Volume else 0 end) as 'Used by FNL',
    sum(case when `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` like 'Yes%' then Volume else 0 end) as 'Available to FNL',
    sum(case when `Vial Status` in ('Out') and `Vial Reserved For FNL` like 'No: Shipped%' and `Vial Reserved For FNL` not like '%Shipped to FNL%' then Volume else 0 end) as 'Used by Investigators',
    sum(case when `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'No' then Volume else 0 end) as 'Available to Investigators'

FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots
group by Biorepository_ID) as bc
	on bp.Biorepository_ID = bc.Biorepository_ID

join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
join Biospecimen as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID

where bp.`Material Type` = 'Serum' and bp.`Vial Status` in ('In', 'Out', 'Empty', 'Reserved') and bp.`FNL_Reserve_Group` not in  ('Group 9: Data Errors')
    and bp.`Current Label` like '%' ) as all_samp
where Visit_Info_ID in ('27_300742 : F06', '27_410065 : F04')
group by Visit_Info_ID