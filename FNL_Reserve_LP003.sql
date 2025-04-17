SELECT distinct bio.Research_Participant_ID, bio.Visit_Info_ID, #bp.*
	#round(sum(case when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'Yes' and Volume < 100 then Volume
	#	when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'Yes' and Volume >= 100 then Volume/1000 else 0 end), 2) as 'Serum Volume for FNL',
    
    #round(sum(case when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'No' and Volume < 100 then Volume
	#	when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') and `Parent FNL Reserve Flag` = 'No' and Volume >= 100 then Volume / 1000 else 0 end), 2) as 'Serum Volume for Community',
    
    sum(case when `Material Type` = 'PBMC'  then 1 else 0 end ) as 'Total PBMC Vials',
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('Out')  then 1 else 0 end) as 'PMBCs Previously Used',
    
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'Yes' then 1 else 0 end) as 'PMBC Vials for FNL',
    round(sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'Yes' and a.Aliquot_Concentration > 100 then a.`Aliquot_Concentration`
			 when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'Yes' and a.Aliquot_Concentration < 100 then a.`Aliquot_Concentration`* 1e6
			 else 0 end), 0) as 'PMBC Cells for FNL',
    
    sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'No' then 1 else 0 end) as 'PMBC Vials for Community',
    round(sum(case when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'No' and a.Aliquot_Concentration > 100 then a.`Aliquot_Concentration`
			 when `Material Type` = 'PBMC' and `Vial Status` in ('In', 'Reserved') and `Vial Reserved For FNL` = 'No' and a.Aliquot_Concentration < 100 then a.`Aliquot_Concentration`* 1e6
			 else 0 end), 0) as 'PMBC Cells for Community'
	from BSI_Parent_Aliquots as bp
left join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
left join Biospecimen as bio    
    on bio.Biospecimen_ID = a.Biospecimen_ID

#where `Material Type` = 'PBMC' and`Vial Status` in ('In', 'Reserved', 'Out') and bio.Research_Participant_ID is NULL

#left join BSI_Parent_Aliquots as bp


group by bio.Visit_Info_ID