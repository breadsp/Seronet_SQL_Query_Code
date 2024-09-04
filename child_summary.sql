select nv.Research_Participant_ID, nv.SeroNet_Cohort, nv.Normalized_Visit_Index, nv.Date_Of_Event, nv.Visit_Info_ID, a.Aliquot_ID,
	bp.`Current Label` as 'Label_ID', bp.Biorepository_ID,  bp.`Material Type`, bp.FNL_Reserve_Cat, bc.*
	from BSI_Parent_Aliquots as bp
left join(
	SELECT Biorepository_ID, 
		sum(case when `Vial Status` = 'Out' and `Vial Reserved For FNL` = 'No: Shipped to FNL' then 1 else 0 end) as 'Vial Used: FNL',
		sum(case when `Vial Status` = 'Out' and `Vial Reserved For FNL` != 'No: Shipped to FNL' then 1 else 0 end) as 'Vial Used: Investigator',
		sum(case when `Vial Reserved For FNL` in ('No: Vial Destroyed/Broken', 'No: Data Issue') then 1 else 0 end) as 'Vial Not Useable',
		sum(case when `Vial Status` = 'In' and `Vial Reserved For FNL` in ('Yes') then 1 else 0 end) as 'Vial Reserved for FNL',
        sum(case when `Vial Status` = 'In' and `Vial Reserved For FNL` in ('Yes') then volume else 0 end) as 'Volume Reserved for FNL',
		sum(case when `Vial Status` = 'In' and `Vial Reserved For FNL` in ('No') then 1 else 0 end) as 'Vial Available for Seronet',
        sum(case when `Vial Status` = 'In' and `Vial Reserved For FNL` in ('No') then volume else 0 end) as 'Volume  Available for Seronet'

	#`Vial Status`, `Vial Reserved For FNL`,  count(Biorepository_ID)
		FROM `seronetdb-Vaccine_Response_v2`.BSI_Child_Aliquots
	group by Biorepository_ID) as bc
on bp.Biorepository_ID = bc.Biorepository_ID

left join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
left join Biospecimen  as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID
left join Normalized_Visit_Info as nv
	on bio.Visit_Info_ID = nv.Visit_Info_ID
where bp.`Material Type` = 'Serum'