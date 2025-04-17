SELECT nv.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Visit_Info_ID, 
	count(Aliquot_ID) as 'Parent Serum Vials',
    sum(case when child.`Total Volume` > 0 then 0 else samp.Volume end) as 'BSI_Parent Volume',
    
    sum(case when child.`Child Vials` > 0 then child.`Child Vials` else 0 end) as 'BSI_Child Vials',
    sum(case when child.`Total Volume` > 0 then child.`Total Volume` else 0 end) as 'BSI_Child Volume'
    
from Normalized_Visit_Info as nv
left join (
	select Visit_Info_ID, Aliquot_ID, bp.Biorepository_ID, bp.Volume
    from Biospecimen as bio 
	join Aliquot as a
		on bio.Biospecimen_ID = a.Biospecimen_ID
	join BSI_Parent_Aliquots as bp
		on a.Aliquot_ID = bp.`Current Label`
	where bio.Biospecimen_Type = 'Serum') as samp
on samp.Visit_Info_ID = nv.Visit_Info_ID

left join(
	SELECT Biorepository_ID, count(CGR_Aliquot_ID) as 'Child Vials', sum(Volume) as 'Total Volume'
	FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots
	where `Vial Status`  not in ('Destroyed/Broken')
	group by Biorepository_ID) as child
on samp.Biorepository_ID = child.Biorepository_ID

group by nv.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Visit_Info_ID