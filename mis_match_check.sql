SELECT bp.Biorepository_ID, a.Aliquot_ID, a.Samples_Not_Useable
 FROM `seronetdb-Vaccine_Response`.BSI_Parent_Aliquots as bp
join Aliquot as a
on bp.`Current Label` = a.Aliquot_ID
where a.Samples_Not_Useable is not NULL;

update Aliquot
set Samples_Not_Useable = NULL
where Aliquot_ID in ('14_MA5624_102_01', '41_101488_100_01', '14_M26070_102_04')