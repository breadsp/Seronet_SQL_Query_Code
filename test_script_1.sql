SELECT 
	sub.Submission_Index as 'Data Submitted' , sub.Submission_Time, sub.Submission_CBC_Name, nv.Research_Participant_ID, nv.Normalized_Visit_Index, nv.Visit_Info_ID, nv.Data_Status,
    a.Aliquot_ID, bp.Biorepository_ID, sm.Submission_Index as 'Shipping Manifest Submission', bio.Biospecimen_Type, bp.`Date Entered`
	from Normalized_Visit_Vaccination as nv
left join Participant_Visit_Info as pv
	on nv.Visit_Info_ID = pv.Visit_Info_ID
left join Submission as sub
	on pv.Submission_Index = sub.Submission_Index
left join Biospecimen as bio
	on bio.Visit_Info_ID = nv.Visit_Info_ID
left join Aliquot as a
	on a.Biospecimen_ID = bio.Biospecimen_ID
left join Shipping_Manifest as sm
	on a.Aliquot_ID = sm.`Current Label`
#left join Biospecimen as bio
#	on a.Biospecimen_ID = bio.Biospecimen_ID
left join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`
where a.Samples_Not_Useable is NULL
	and (sub.Submission_CBC_Name = 'Arizona State University'  or nv.Research_Participant_ID like '32_%')
	#and (sub.Submission_CBC_Name = 'Icahn School Of  Medicine At Mount Sinai' or nv.Research_Participant_ID like '14_%')
	#and (sub.Submission_CBC_Name = 'University of Minnesota'  or nv.Research_Participant_ID like '27_%')
	#and (sub.Submission_CBC_Name = 'Feinstein Institutes for Medical Research'  or nv.Research_Participant_ID like '41_%')
#	and bp.`Date Entered` is NULL and sm.Submission_Index < 140 and Submission_CBC_Name in ('University of Minnesota') # and Biospecimen_Type = 'PBMC' and  bio.Biospecimen_ID = '14_I11895_201'
#group by sm.Submission_Index , bio.Biospecimen_Type,  sub.Submission_CBC_Name, bp.`Date Entered`