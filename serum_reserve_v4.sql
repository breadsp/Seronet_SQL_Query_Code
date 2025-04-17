select nv.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Visit_Info_ID, 

	group_concat(bsi.FNL_Reserve_Group) as 'Group_names',
	sum(bsi.`Parent Volume`) as 'Parent Volume',
    sum(bsi.`Total Volume`) as 'Total Child Volume',
    sum(bsi.`Used by FNL`) as 'Used by FNL',
    sum(bsi.`Used by Investigators`) as 'Used by Investigators',
    sum(bsi.`Reserved For FNL`) as 'Reserved For FNL',
    sum(bsi.`Avaialble to Community`) as 'Avaialble to Community'
    
from Biospecimen as bio
	left join Aliquot as a
on bio.Biospecimen_ID = a.Biospecimen_ID
	left join Normalized_Visit_Info as nv
on bio.Visit_Info_ID = nv.Visit_Info_ID

left join (
select bp.FNL_Reserve_Group,  bp.`Current Label`, bp.Biorepository_ID as 'Parent BSI _ID', 
case when child.`Total Volume` is NULL then  bp.`Vial Status` else 'Empty/Used' end as 'Parent Status',
case when child.`Total Volume` is NULL then  bp.`Volume` else 0 end as 'Parent Volume', child.*
FROM `seronetdb-Vaccine_Response_v2`.BSI_Parent_Aliquots as bp
left join(
SELECT Biorepository_ID,  sum(Volume) as 'Total Volume',
	sum(case when `Vial Reserved For FNL` like '%Shipped to FNL%' then Volume else 0 end) as 'Used by FNL', 
	sum(case when `Vial Reserved For FNL` like '%No: Shipped%' and `Vial Reserved For FNL` not like '%Shipped to FNL%' then Volume else 0 end) as 'Used by Investigators', 
	sum(case when `Vial Reserved For FNL` = 'Yes' then Volume else 0 end) as 'Reserved For FNL',
    sum(case when `Vial Reserved For FNL` = 'No' then Volume else 0 end) as 'Avaialble to Community'
FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots
where `Vial Status`  not in ('Destroyed/Broken')
group by Biorepository_ID) as child
on bp.Biorepository_ID = child.Biorepository_ID
where bp.`Material Type` = 'Serum' and bp.`Vial Status` not in ('Destroyed/Broken')) as bsi
on a.Aliquot_ID = bsi.`Current Label`
group by nv.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Visit_Info_ID