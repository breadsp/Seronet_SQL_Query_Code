select `Material Type`, `Vial Status`,   `Vial Reserved For FNL`,  count(`Vial Reserved For FNL`) 
	from `seronetdb-Vaccine_Response_v2`.BSI_Parent_Aliquots
where `Material Type` = 'PBMC'
	group by `Material Type`, `Vial Status` , `Vial Reserved For FNL` 
order by `Material Type`, `Vial Status`,   `Vial Reserved For FNL`;


