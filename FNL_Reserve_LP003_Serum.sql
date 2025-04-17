SELECT distinct bio.Research_Participant_ID, bio.Visit_Info_ID, #bp.*
	round(sum(case when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved')  and Volume < 100 then Volume
		when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved')  and Volume >= 100 then Volume/1000 else 0 end), 2) as 'Parent Volume (ml)',
        sum(child.`Child: FNL Reserve`) as 'Child: FNL Reserve (ul)',
        sum(child.`Child: Community (used)`) as 'Child: Community (used) (ul)', 
        sum(child.`Child: Community (available)`) as 'Child: Community (available) (ul)'
        
    from BSI_Parent_Aliquots as bp
left join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
left join Biospecimen as bio    
    on bio.Biospecimen_ID = a.Biospecimen_ID

left join (SELECT Biorepository_ID,
		sum(case when `Vial Reserved For FNL` like 'Yes%' then Volume else 0 end) as 'Child: FNL Reserve',
		sum(case when `Vial Reserved For FNL` like 'No%' and `Vial Status` in ('Out')  then Volume else 0 end) as 'Child: Community (used)',
        sum(case when `Vial Reserved For FNL` like 'No%' and `Vial Status` in ('In', 'Reserved')  then Volume else 0 end) as 'Child: Community (available)'

	FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots
	group by Biorepository_ID) as child
on bp.Biorepository_ID = child.Biorepository_ID

where Research_Participant_ID is not NULL
group by bio.Visit_Info_ID