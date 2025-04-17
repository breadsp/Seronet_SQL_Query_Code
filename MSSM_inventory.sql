SELECT pv.Submission_Index, Biospecimen_Type, a.Aliquot_ID, sm.Submission_Index, bp.`Current Label`, bp.`Date Entered` ,cv.Visit_Info_ID


	#group_concat(distinct case when Biospecimen_Type = 'Serum' then bio.Biospecimen_ID end) as 'Bio_Serum',
    #group_concat(distinct case when Biospecimen_Type = 'Serum' then a.Aliquot_ID end) as 'Aliquot_Serum',
    #group_concat(distinct case when Biospecimen_Type = 'Serum' then sm.Submission_Index end) as 'Shipping_Serum',
    #group_concat(distinct case when Biospecimen_Type = 'Serum' then bp.`Current Label` end) as 'BSI_Serum'
    
    
    #group_concat(distinct case when Biospecimen_Type = 'PBMC' then bio.Biospecimen_ID  end) as 'Bio_PBMC'
    
	FROM Participant_Visit_Info as pv
join Biospecimen as bio
	on pv.Visit_Info_ID = bio.Visit_Info_ID
join Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
left join (select distinct Visit_Info_ID from Covid_Vaccination_Status) as cv
	on bio.Visit_Info_ID = cv.Visit_Info_ID
left join Shipping_Manifest as sm	
	on sm.`Current Label` = a.Aliquot_ID
left join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`
where pv.Submission_Index >= 306 and a.Samples_Not_Useable is NULL
#group by pv.Visit_Info_ID