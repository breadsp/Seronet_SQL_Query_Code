select nv.Research_Participant_ID, nv.Primary_Cohort, nv.Normalized_Visit_Index, sc.Date_Of_Event, a.Aliquot_ID, bp.Biorepository_ID, bp.`Material Type`, bp.`Vial Status`, bp.Volume
	from Normalized_Visit_Vaccination as nv
join Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index
join Biospecimen as bio
	on nv.Visit_Info_ID = bio.Visit_Info_ID
join Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`
where bp.`Material Type` = 'Serum'