SELECT left(CBC_Biospecimen_Aliquot_ID, 9) as 'Participant_ID',
	round(sum(case when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'Yes' and Volume < 100 then Volume
		when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'Yes' and Volume >= 100 then Volume/1000 else 0 end), 2) as 'Serum Volume for FNL',
    
    round(sum(case when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'No' and Volume < 100 then Volume
		when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'No' and Volume >= 100 then Volume / 1000 else 0 end), 2) as 'Serum Volume for Community',
    
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') then 1 else 0 end ) as 'Total PBMC Vials',
    
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'Yes' then 1 else 0 end) as 'PMBC Vials for FNL',
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'Yes' then a.`Aliquot_Concentration (cells/mL)` else 0 end) as 'PMBC Cells for FNL',
    
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'No' then 1 else 0 end) as 'PMBC Vials for Community',
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'No' then a.`Aliquot_Concentration (cells/mL)` else 0 end) as 'PMBC Cells for Community'

	FROM `seronetdb-Validated`.BSI_Parent_Aliquots as bp
join `seronetdb-Validated`.Aliquot as a
	on bp.CBC_Biospecimen_Aliquot_ID = a.Aliquot_ID
join `seronetdb-Validated`.Participant as p
	on p.Research_Participant_ID = left(bp.CBC_Biospecimen_Aliquot_ID, 9)
group by left(CBC_Biospecimen_Aliquot_ID, 9)