SELECT Visit_Info_ID,
	round(sum(case when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'Yes' and Volume < 100 then Volume
				   when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'Yes' and Volume >= 100 then Volume/1000 else 0 end), 2) as 'Serum Volume for FNL',
    
    round(sum(case when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'No' and Volume < 100 then Volume
		when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'No' and Volume >= 100 then Volume / 1000 else 0 end), 2) as 'Serum Volume for Community',
    
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'Yes' then 1 else 0 end) as 'PMBC Vials for FNL',
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'Yes' then a.`Aliquot_Concentration` else 0 end) as 'PMBC Cells for FNL',
    
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'No' then 1 else 0 end) as 'PMBC Vials for Community',
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'No' then a.`Aliquot_Concentration` else 0 end) as 'PMBC Cells for Community'

	FROM BSI_Parent_Aliquots as bp
join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
join Biospecimen as bio
	on bio.Biospecimen_ID = a.Biospecimen_ID
group by bio.Visit_Info_ID