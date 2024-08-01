SELECT left(bp.CBC_Biospecimen_Aliquot_ID,9) as 'Part ID',
    sum(case when bp.`Material Type` = 'Serum' and bp.`Vial Status` = 'In' then 1 else 0 end) as 'Serum Parent Vials: In BSI',
    round(sum(case when bp.`Material Type` = 'Serum' and bp.`Vial Status` = 'In' and bp.Volume <= 10 then bp.Volume 
			 when bp.`Material Type` = 'Serum' and bp.`Vial Status` = 'In' and bp.Volume > 10 then bp.Volume/1000
			 else 0 end),2) as 'Serum Parent Volume(ml): In BSI ',
	case when child.`Child Vials 50ul: In BSI` is NULL then 0 else child.`Child Vials 50ul: In BSI` end as 'Child Vials 50ul: In BSI', 
    #case when child.`Child Vials 300ul: In BSI` is NULL then 0 else child.`Child Vials 300ul: In BSI` end as 'Child Vials 300ul: In BSI', 
    case when child.`Child Volume (ml)` is NULL then 0 else child.`Child Volume (ml)` end as 'Child Volume (ml)',

    
    sum(case when bp.`Material Type` = 'PBMC' and bp.`Vial Status` = 'In' then 1 else 0 end) as 'PBMC Vials: In BSI'
FROM `seronetdb-Validated`.BSI_Parent_Aliquots as bp

left join (SELECT Biorepository_ID, 
	sum(case when `Vial Status` = 'In' and Volume = 50 then 1 else 0 end) as 'Child Vials 50ul: In BSI',
    sum(case when `Vial Status` = 'Out' and Volume = 50 then 1 else 0 end) as 'Child Vials 50ul: Used',
    sum(case when `Vial Status` = 'In' and Volume = 300 then 1 else 0 end) as 'Child Vials 300ul: In BSI',
	sum(case when `Vial Status` = 'Out' and Volume = 300 then 1 else 0 end) as 'Child Vials 300ul: Used',
    round(sum(case when `Vial Status` = 'In' then Volume/1000 else 0 end),2) as 'Child Volume (ml)'
	FROM `seronetdb-Validated`.BSI_Child_Aliquots
group by Biorepository_ID) as child
on bp.Biorepository_ID = child.Biorepository_ID

where bp.`Vial Status` not in ('Discrepant') 
group by left(bp.CBC_Biospecimen_Aliquot_ID,9)