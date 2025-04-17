SELECT bio.Visit_Info_ID, 
	count(distinct case when bp.`Material Type` = 'SERUM' and bp.FNL_Reserve_Group not like 'Group 9%' then bp.`Biorepository_ID` else NULL end) as 'Serum Vials Received',
    count(distinct case when bp.`Material Type` = 'PBMC' then bp.`Biorepository_ID` else NULL end) as 'PBMC Vials Received',
    
    #group_concat(distinct (case when bp.`Vial Status` in ('Out') and bp.`Material Type` = 'PBMC' then bp.`Biorepository_ID`  else NULL end) ORDER BY bp.`Biorepository_ID` , "  ") as 'PBMC Vials: Previously Used',
    #group_concat(distinct (case when bp.`Material Type` = 'PBMC' and (bp.`Vial Status` in ('Destroyed/Broken')  or bp.`Vial Reserved For FNL` in ('No: No Aliquot Data', 'No: Material Type Mismatch', 'No: Duplicated ID in BSI'))
	#	then bp.`Biorepository_ID` else NULL end) ORDER BY bp.`Biorepository_ID` , "  ") as 'PBMC Vials: Data Issues',
	#group_concat(distinct (case when bp.`Material Type` = 'PBMC' and bp.`Vial Status` in ('In') and  bp.`Vial Reserved For FNL` in ('Yes') then bp.`Biorepository_ID` else NULL end) ORDER BY bp.`Biorepository_ID` , "  ") as 'PBMC Vials: Reserved FNL',
	
    
    group_concat(distinct (case when bp.`Material Type` = 'PBMC' and bp.`Vial Status` in ('In') and  bp.`Vial Reserved For FNL` in ('No') then bp.`Biorepository_ID` else NULL end) ORDER BY bp.`Biorepository_ID` , "  ") as 'PBMC Vials: BSI_ID',
    count(distinct case when bp.`Material Type` = 'PBMC' and bp.`Vial Status` in ('In') and  bp.`Vial Reserved For FNL` in ('No') then bp.`Biorepository_ID` else NULL end) as 'PBMC Vials: Available Community'

    
    
	
	#group_concat(distinct (case when bp.`Vial Status` in ('In', 'Reserved') then bp.`Biorepository_ID` else NULL end) ORDER BY bp.`Biorepository_ID` , "  ") as 'BSI IDS: Not Aliquoted ',
    #group_concat(distinct (case when bp.`Vial Status` in ('In', 'Reserved') then bp.FNL_Reserve_Group else NULL end) ORDER BY bp.FNL_Reserve_Group , "  ") as 'BSI IDS: FNL Reserve Group ',
    #group_concat(distinct (case when bp.`Vial Status` in ('In', 'Reserved') then bp.FNL_Reserve_Sub_Cat else NULL end) ORDER BY bp.FNL_Reserve_Sub_Cat , "  ") as 'BSI IDS: FNL Reserve Cat ',
    #group_concat(distinct (case when bp.`Vial Status` in ('In', 'Reserved') then bp.`Vial Reserved For FNL` else NULL end) ORDER BY bp.`Vial Reserved For FNL` , "  ") as 'Reserved: Vial Stauts ',
    #round(sum(case when bp.`Vial Status` in ('In', 'Reserved') then bp.Volume else 0 end), 2) as 'Parent Volume Remaining',
    
    #group_concat(distinct (case when bp.`Vial Reserved For FNL` like 'No:%' then bp.`Biorepository_ID` else NULL end) ORDER BY bp.`Biorepository_ID` , "  ") as 'BSI IDS: Used / Shipped, No Aliquots',
    #group_concat(distinct (case when bp.`Vial Reserved For FNL` like 'No:%' then bp.`Vial Reserved For FNL` else NULL end) ORDER BY bp.`Vial Reserved For FNL` , "  ") as 'Used: Vial Stauts ',
    
    #group_concat(distinct (case when bp.`Vial Status` in ('Out', 'Empty') and bp.`Vial Reserved For FNL` = 'No' then bp.`Biorepository_ID` else NULL end)  ORDER BY bp.`Biorepository_ID` , "  ") as 'BSI IDS: Already Aliquoted ',
	
    
	#count(bc.CGR_Aliquot_ID) as 'Child Aliquots',
    #round(sum(bc.Volume),2)  as 'Total Child Volume'
    
	FROM Biospecimen as bio
	join Aliquot as a
on a.Biospecimen_ID = bio.Biospecimen_ID
	join BSI_Parent_Aliquots as bp
on bp.`Current Label` = a.Aliquot_ID
	left join BSI_Child_Aliquots as bc
on bp.Biorepository_ID = bc.Biorepository_ID
	
#where bp.`Vial Status` in ('In', 'Reserved') and 
#where bp.`Material Type` = 'SERUM' and
#	bp.FNL_Reserve_Group not like 'Group 9%'
group by bio.Visit_Info_ID