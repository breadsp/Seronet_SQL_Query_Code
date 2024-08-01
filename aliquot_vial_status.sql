SELECT bio.Biospecimen_Type as 'Material Type', bio.Visit_Info_ID, a.Biospecimen_ID, a.Aliquot_ID, bp.`Current Label`,  bp.Biorepository_ID, 
	case when bp.Biorepository_ID is NULL and sm.Submission_Index < 195 then 'Sample at CBC: On Manifest not Received'
		 when bp.Biorepository_ID is NULL and sm.Submission_Index >= 195 then 'Shipment in Process'
         when bp.Biorepository_ID is NULL and sm.Submission_Index is NULL then 'Sample at CBC: No Shipping Manifest'
		 when bp.Biorepository_ID is not NULL then 'Sample in BSI'
         else 'Unknown Status' end as 'Sample Status'
FROM `seronetdb-Vaccine_Response`.Aliquot as a
join Biospecimen as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID
left join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`
left join Shipping_Manifest as sm
	on a.Aliquot_ID = sm.`Current Label`
where a.Samples_Not_Useable is NULL

