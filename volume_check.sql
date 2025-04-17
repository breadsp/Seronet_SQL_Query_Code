select Visit_Info_ID, sum(`Serum Volume`) as 'Total Serum Volume', count(`CGR_Aliquot_ID`) as 'Total Child Vials', sum(`50ul`) as '50ul vials', sum(`300ul`) as '300ul vials', sum(`500ul`) as '500ul vials',
	sum(`Other Volumes`) as 'Other Volumes'

from 
(select bio.Visit_Info_ID, bc.*
        from Biospecimen as bio
    join Aliquot as a
        on a.Biospecimen_ID = bio.Biospecimen_ID
    join BSI_Parent_Aliquots as bp
        on bp.`Current Label` = a.Aliquot_ID
    join

    (select Biorepository_ID, CGR_Aliquot_ID, FLOOR(volume / 50) * 50 as 'Serum Volume', 
			case when FLOOR(volume / 50) * 50 = 50 then 1 else 0 end as '50ul',
            case when FLOOR(volume / 50) * 50 = 300 then 1 else 0 end as '300ul',   
            case when FLOOR(volume / 50) * 50 = 500 then 1 else 0 end as '500ul',
			case when FLOOR(volume / 50) * 50 not in (50, 300, 500) then 1 else 0 end as 'Other Volumes'
            
            from BSI_Child_Aliquots
        where `Vial Status` in ('In') and `Vial Reserved For FNL` = 'No: Available to Community') as bc
    on bp.Biorepository_ID = bc.Biorepository_ID) as t
where Visit_Info_ID like '32_4410%'
group by Visit_Info_ID
