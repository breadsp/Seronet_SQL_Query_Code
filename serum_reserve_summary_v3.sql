select pv.Visit_Info_ID, `Parent Serum Vials Received`,
	`Parent Serum Vials not Aliquoted`, 	`Serum Parent Volume Remaining (ml)`,
`Resereve Flag: FNL Avialable`,	`Resereve Flag: FNL Used`,
`Used by the Community`,	`Community: Available`,	`Serum_Reserve_Cat`,	`PBMC Reserved: In BSI`, `PBMC Reserved: Used`	,`PBMC Available`								


from 
(SELECT pv.Visit_Info_ID, pv.Research_Participant_ID, bio.`Serum Collected`, bio.`PBMC Collected`
	FROM Participant_Visit_Info as pv
left join( select Visit_Info_ID, sum(case when Biospecimen_Type = 'Serum'  then 1 else 0 end) as 'Serum Collected',
			sum(case when Biospecimen_Type = 'PBMC'  then 1 else 0 end) as 'PBMC Collected'
            from  Biospecimen group by Visit_Info_ID) as bio
	on pv.Visit_Info_ID = bio.Visit_Info_ID
group by pv.Visit_Info_ID) as pv
left join Withdrawn_List as wl
	on pv.Research_Participant_ID = wl.Research_Participant_ID
left join
(
SELECT 
	bio.Visit_Info_ID, sum(case when `Material Type` = 'Serum' then 1 else 0 end) as 'Parent Serum Vials Received', 
    sum(case when FNL_Reserve_Group like 'Group 0%' then 1 else 0 end) as 'Parent Serum Vials not Aliquoted',
    round(sum(case when `Material Type` = 'Serum' and `Vial Status` in ('In', 'Reserved') then bp.Volume else 0 end),2) as 'Serum Parent Volume Remaining (ml)',
    
    sum(case when bc.`Resereve Flag: FNL Avialable` is NULL then 0 else bc.`Resereve Flag: FNL Avialable` end) as 'Resereve Flag: FNL Avialable',
	sum(case when bc.`Resereve Flag: FNL Used` is NULL then 0 else bc.`Resereve Flag: FNL Used` end) as 'Resereve Flag: FNL Used',
	sum(case when bc.`Previously Used Samples` is NULL then 0 else bc.`Previously Used Samples` end) as 'Used by the Community',
	sum(case when bc.`Community: Available` is NULL then 0 else bc.`Community: Available` end) as 'Community: Available',
    
    GROUP_CONCAT(distinct FNL_Reserve_Group  order by FNL_Reserve_Group, " ,  ")  as 'Serum_Reserve_Cat',    
    
    sum(case when `Material Type` = 'PBMC' and `Vial Reserved For FNL` = 'Yes' then 1 else 0 end) as 'PBMC Reserved: In BSI',
    sum(case when `Material Type` = 'PBMC' and `Vial Reserved For FNL` like 'Yes:%' then 1 else 0 end) as 'PBMC Reserved: Used',
    sum(case when `Material Type` = 'PBMC' and `Vial Reserved For FNL` = 'No' then 1 else 0 end) as 'PBMC Available'
    

    
FROM BSI_Parent_Aliquots as bp
	join Aliquot as a
on bp.`Current Label` = a.Aliquot_ID
	join  Biospecimen as bio
on a.Biospecimen_ID = bio.Biospecimen_ID

left join (
	SELECT Biorepository_ID,  
		sum(case when `Vial Reserved For FNL` like 'Yes' then Volume else 0 end) as 'Resereve Flag: FNL Avialable',
		sum(case when `Vial Reserved For FNL` like 'Yes: Shipped to FNL (Autoimmune Study)%' then Volume else 0 end) as 'Resereve Used: Autoimmune',
		sum(case when `Vial Reserved For FNL` like 'Yes: Shipped to FNL (Cancer Study)' then Volume else 0 end) as 'Resereve Used: Cancer',
		sum(case when `Vial Reserved For FNL` like 'Yes: Shipped to FNL (Extra Healthy Controls)' then Volume else 0 end) as 'Resereve Used: Controls',
		sum(case when `Vial Reserved For FNL` like 'Yes: Shipped to FNL (PBNA_Qual)' then Volume else 0 end) as 'Resereve Used: PBNA_Qual',
		sum(case when `Vial Reserved For FNL` like 'Yes: Shipped to FNL (Phase 2: ATCC)' then Volume else 0 end) as 'Resereve Used: ATCC',
		sum(case when `Vial Reserved For FNL` like 'Yes:%' then Volume else 0 end) as  'Resereve Flag: FNL Used',
		
		sum(case when `Vial Reserved For FNL` like 'No:%' then Volume else 0 end) as 'Previously Used Samples',
		sum(case when `Vial Reserved For FNL` like 'No' then Volume else 0 end) as 'Community: Available'
	FROM BSI_Child_Aliquots group by Biorepository_ID) as bc
on bp.Biorepository_ID = bc.Biorepository_ID

where `Vial Reserved For FNL` not in ('No: Missing Aliquot Data', 'No: Material Type Mismatch') #and bio.Visit_Info_ID like '27%'
group by bio.Visit_Info_ID) as bsi
on pv.Visit_Info_ID = bsi.Visit_Info_ID

where `Parent Serum Vials Received` > 0 # and pv.Visit_Info_ID = '27_200011 : B01'

#where `PBMC Reserved In BSI` = 0 and `PBMC Available` > 0

#where  ((((`Resereve Flag: FNL Avialable` + `Resereve Flag: FNL Used`) != 1000) and 
#	   ((`Resereve Flag: FNL Avialable` + `Resereve Flag: FNL Used`) < 1000 and `Community: Available` > 0) and 
#		(`Parent Serum Vials Received` > 0)) or ((`Resereve Flag: FNL Avialable` + `Resereve Flag: FNL Used`) > 1250))
#and pv.Visit_Info_ID in ('41_101002 : F02')