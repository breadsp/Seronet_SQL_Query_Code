select  bio.Visit_Info_ID, 
		sum(`Parent Volume`) as 'Parent Volume', sum(`Child Volume`) as 'Child Volume', sum(`FNL Used`) as'FNL Used',  sum(`Child Used`) as 'Child Used'
	from Biospecimen as bio

	left join (
		SELECT left(`Current Label`,13) as 'Bio_ID', #bp.Biorepository_ID,
			sum(case when bp.`Vial Status` = 'Out' then 0
				when bc.`Child Available` is NULL and bp.`Volume` > 100 then bp.`Volume`
				when bc.`Child Available` is NULL and bp.`Volume` < 100 then bp.`Volume`*1000
				when bc.`Child Available` is not NULL then 0 else -1 end) as 'Parent Volume', 
				
                sum(bc.`Child Available`) as 'Child Volume',
                sum(bc.`FNL Reserve`) as 'FNL Used',
				sum(bc.`Child Used`) as 'Child Used'
				
				
			FROM BSI_Parent_Aliquots as bp
		left join ( Select Biorepository_ID, sum(case when `Vial Reserved For FNL` = 'No' and `Vial Status` = 'In'  then Volume else 0 end) as 'Child Available' ,
											 sum(case when `Vial Reserved For FNL` like 'Yes%' then Volume else 0 end) as 'FNL Reserve' ,
                                             sum(case when `Vial Reserved For FNL` like 'No%' and `Vial Status` = 'Out'  then Volume else 0 end) as 'Child Used' 

			from BSI_Child_Aliquots group by Biorepository_ID)  as bc
			on bp.Biorepository_ID = bc.Biorepository_ID
		where bp.`Material Type` = 'Serum' and FNL_Reserve_Group not in ('Group 9: Data Errors')
		group by left(`Current Label`,13)) as BSI_Serum

	on bio.Biospecimen_ID = BSI_Serum.Bio_ID
	group by bio.Visit_Info_ID