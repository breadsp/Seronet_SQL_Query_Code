
# Research_Participant_ID	Normalized_Visit_Index	Visit_Info_ID	Date_Of_Event	Biospecimen_Type	Aliquot_ID	Samples_Not_Useable	Biorepository_ID	Vial Status	Material Type

select nv.Research_Participant_ID,	nv.Normalized_Visit_Index,	nv.Visit_Info_ID, sc.Date_Of_Event, bio.Biospecimen_Type, a.Aliquot_ID, a.Samples_Not_Useable,
	bp.Biorepository_ID,	bp.`Vial Status`, 	bp.`Material Type`, bp.`Last Requisition ID` as 'Parent Shipped', bc.CGR_Aliquot_ID, bc.`Vial Status`,  bc.Volume, bc.`Last Requisition ID` as 'Child_Shipped'
	from Normalized_Visit_Vaccination as nv
left join Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index
left join Biospecimen as bio
	on nv.Visit_Info_ID = bio.Visit_Info_ID
left join Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
left join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`
left join BSI_Child_Aliquots as bc
	on bp.Biorepository_ID = bc.Biorepository_ID
#where nv.Research_Participant_ID = '41_101104'
where a.Samples_Not_Useable is NULL and (bc.`Vial Status` is  NULL or bc.`Vial Status` not in ('Empty')) and bp.Biorepository_ID in ('LP31796 0001',
'LP36330 0001','LP31961 0001','LP36679 0001','LP25481 0001','LP36328 0001','LP31883 0001','LP31884 0001','LP36469 0001',
'LP31830 0001','LP31831 0001','LP31832 0001','LP32002 0001','LP32005 0001','LP32006 0001','LP45560 0001')