SELECT p.Research_Participant_ID, bsi.*
	FROM `seronetdb-Validated`.Participant as p
	left join `seronetdb-Validated`.Reference_Panel_Data as rp
on p.Research_Participant_ID = rp.`Participant ID`
	
left join(
SELECT left(CBC_Biospecimen_Aliquot_ID,9) as 'Particiapnt',
    sum(case when bp.`Vial Status` in ('In') then 1 else 0 end) as  'Parent Vial Available',
    round(sum(case when bp.`Vial Status` in ('In') and bp.Volume < 10 then bp.Volume 
				   when bp.`Vial Status` in ('In') and bp.Volume > 10 then bp.Volume/1000
			else 0 end),2) as  'Parent Volume Available',
    
    
    child.`Child Vials`, child.`Child Volume`

	FROM `seronetdb-Validated`.BSI_Parent_Aliquots as bp
    left join (SELECT Biorepository_ID, 
		sum(case when `Vial Status` = 'In' then 1 else 0 end) as 'Child Vials',
		sum(case when `Vial Status` = 'In' then volume else 0 end) as 'Child Volume'
		FROM `seronetdb-Validated`.BSI_Child_Aliquots
	group by Biorepository_ID) as child
	on bp.Biorepository_ID = child.Biorepository_ID
    
group by left(CBC_Biospecimen_Aliquot_ID,9)) as bsi
	on p.Research_Participant_ID = bsi.`Particiapnt`
where rp.`Participant ID` is NULL