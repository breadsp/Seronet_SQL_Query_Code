SELECT sm.Submission_Index,  sub.Submission_CBC_Name,  sm.`Material Type`, sub.Submission_Time, 
	(case when a.Aliquot_ID is not NULL then 1 else 0 end) as 'Aliquot Data',
    (sm.Submission_Index) as 'Samples on Manifest', 
	sm.`Current Label`,
	(case when bp.Biorepository_ID is Not NULL then 1 else 0 end) as 'Samples in BSI',
    (Date_Received),
    
    (case when a.Samples_Not_Useable is Not NULL then 1 else 0 end) as 'Samples do not Exist'
	FROM `seronetdb-Vaccine_Response`.Shipping_Manifest as sm
left join Submission as sub
	on sub.Submission_Index = sm.Submission_Index
left join 
	(select *, case when `Date Entered` is NULL then '0000-00-00' else `Date Entered` end as 'Date_Received'
	from BSI_Parent_Aliquots) as bp
	on sm.`Current Label` = bp.`Current Label`
left join Aliquot as a
	on sm.`Current Label` = a.Aliquot_ID
where 
#Submission_CBC_Name = 'Icahn School Of  Medicine At Mount Sinai' and
	   a.Samples_Not_Useable is NULL and 
       sub.Submission_Time >= '2024-01-01'
       #and Date_Received is NULL and sm.Submission_Index not in (227, 222, 219)
#group by sub.Submission_CBC_Name, sm.Submission_Index, bp.`Date_Received`
#order by  sub.Submission_CBC_Name, bp.`Date_Received`