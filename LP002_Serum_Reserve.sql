SELECT left(CBC_Biospecimen_Aliquot_ID,9) as 'Part ID',
	round(sum(case when `Parent FNL Reserve Flag`  = 'No' then 1 else 0 end), 0) as 'Community Vials',
    round(sum(case when `Parent FNL Reserve Flag`  = 'No' and a.Aliquot_Volume < 100 then (a.Aliquot_Volume) 
				   when `Parent FNL Reserve Flag`  = 'No' and a.Aliquot_Volume >= 100 then (a.Aliquot_Volume)/1000
		   		else 0 end), 0) as 'Community: Total Volume',
    round(sum(case when `Parent FNL Reserve Flag`  = 'Yes' then 1 else 0 end), 0) as 'FNL Vials',
    
     round(sum(case when `Parent FNL Reserve Flag`  = 'Yes' and a.Aliquot_Volume < 100 then (a.Aliquot_Volume) 
				   when `Parent FNL Reserve Flag`  = 'Yes' and a.Aliquot_Volume >= 100 then (a.Aliquot_Volume)/1000
		   		else 0 end), 0) as  'FNL: Total Volume'

FROM `seronetdb-Validated`.BSI_Parent_Aliquots as bp
	join `seronetdb-Validated`.Aliquot as a
on a.Aliquot_ID =  bp.CBC_Biospecimen_Aliquot_ID
where `Material Type` = 'Serum'
group by left(CBC_Biospecimen_Aliquot_ID,9)
