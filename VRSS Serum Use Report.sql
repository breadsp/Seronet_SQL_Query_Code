select  *, `Parent Volume Remaining` + `Total Child Volume` as 'Total Volume',
	case 
		  when (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) > 1000 then 'Need to work: To Much Reserved'
          
          when (`Pending Request for ASU: MISPA` < 250) and (`Parent Volume Remaining` + `Total Child Volume`) >= (3050 + `Child Volume: Used by FNL` + `Child Volume: Used by Investigators`) then 'Need to Aliquot for ASU'
          when (`Pending Request for ASU: MISPA` >= 250 and (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) < 1000) 
				and (`Parent Volume Remaining` + `Total Child Volume`) >= (4000 + `Child Volume: Used by FNL` + `Child Volume: Used by Investigators`) then 'Need to Aliquot for Community'
          
  ################ NO samples remaining to share, either none collected or all have been used  #########################  
		  when `Parent Volume Remaining` = 0 and `Total Child Volume` = 0 then 'No Serum Samples Collected'
		  when `Parent Volume Remaining` = 0 and `Total Child Volume` = (`Child Volume: Used by FNL` + `Child Volume: Used by Investigators`) then 'All Samples Previously Used'

###############   Parent Vials (total under 3ml) need to aliquot, but either no child or all children have been used ####################    
		 when `Parent Volume Remaining` > 0 and `Parent Volume Remaining` <= 3050 and `Total Child Volume` = 0 then 'Parent Volume only: All Samples For FNL'
         #when `Parent Volume Remaining` > 0 and `Parent Volume Remaining` <= 3050 and `Total Child Volume` = (`Child Volume: Used by FNL` + `Child Volume: Used by Investigators`) then 'All Samples Previously Used'

###############   Parent Vials (over 3ml) need to aliquot, but either no child or all children have been used ####################    
		 when `Parent Volume Remaining` > 0 and `Parent Volume Remaining` > 3250 and `Total Child Volume` = 0 then 'Need to Aliquot for ASU'
		 when `Parent Volume Remaining` > 0 and `Parent Volume Remaining` > 3250 and `Total Child Volume` = (`Child Volume: Used by FNL` + `Child Volume: Used by Investigators`) then 'Need to Aliquot for ASU'

		 when `Parent Volume Remaining` > 0 and `Parent Volume Remaining` > 3050 and `Total Child Volume` = 0 then 'Parent Volume only: Need to Aliquot'
		 when `Parent Volume Remaining` > 0 and `Parent Volume Remaining` > 3050 and `Total Child Volume` = (`Child Volume: Used by FNL` + `Child Volume: Used by Investigators`) then 'Parent Volume only: Need to Aliquot'
###############  Total Volume is under 3050 (plus what was previously used, all samples are FNL Reserve ####################    
         when (`Parent Volume Remaining` + `Total Child Volume`) < (3050 + `Child Volume: Used by Investigators`) and `Pending Request for ASU: MISPA` = 0 and `Available for Investigators` = 0 then 'All Samples for FNL'
		 
###############  Total Volume is over 4000, give 1000 to community ####################             
		 when (`Parent Volume Remaining` + `Total Child Volume`) >= 4000 and (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) = 1000 then 'FNL Reserve,  ASU, and Community'

###############  Total Volume is over 3050 but under 4000 ####################             
		 when (`Parent Volume Remaining` + `Total Child Volume`) >= 3050 and (`Parent Volume Remaining` + `Total Child Volume`) < 4000
			   and (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) <= ((`Parent Volume Remaining` + `Total Child Volume`) - 3000)  
               and `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` = 0 then 'FNL Reserve and ASU only (no community vials)'
		when (`Parent Volume Remaining` + `Total Child Volume`) >= 3050 and (`Parent Volume Remaining` + `Total Child Volume`) < 4000
			   and (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) <= ((`Parent Volume Remaining` + `Total Child Volume`) - 3000)  
               and `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` > 0  then 'FNL Reserve,  ASU, and Community'
               
		when (`Parent Volume Remaining` + `Total Child Volume`) >= 3050 and (`Parent Volume Remaining` + `Total Child Volume`) <= 3300
			and `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` = 0  then 'FNL Reserve and ASU only (no community vials)'
		
        when (`Parent Volume Remaining`) >= 3000 and (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators` + `Child Volume: Used by FNL`) = `Total Child Volume`
			 and `Total Child Volume` < 1000 and `Child Volume: Reserved for FNL` = 0
			 and `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` = 0  then 'FNL Reserve and ASU only (no community vials)'
		
        when (`Parent Volume Remaining`) >= 3000 and (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators` + `Child Volume: Used by FNL`) = `Total Child Volume`
			 and `Total Child Volume` < 1000 and `Child Volume: Reserved for FNL` = 0
			 and `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` > 0  then 'FNL Reserve,  ASU, and Community'

		when (`Parent Volume Remaining` + `Total Child Volume`) >= 4000
			and (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) > 850
			and `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` > 0  then 'FNL Reserve,  ASU, and Community'

	    when ((`Parent Volume Remaining` + `Total Child Volume`) - (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) > 3000) and
			 ((`Parent Volume Remaining` + `Total Child Volume`) - (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) < 3200) 
             and `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` > 0  then 'FNL Reserve,  ASU, and Community'
	
		when ((`Parent Volume Remaining` + `Total Child Volume`) - (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) > 3000) and
			 ((`Parent Volume Remaining` + `Total Child Volume`) - (`Child Volume: Used by Investigators` +`Pending Request for ASU: MISPA` + `Available for Investigators`) < 3200) 
             and `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` = 0  then 'FNL Reserve and ASU only (no community vials)'

		when  `Pending Request for ASU: MISPA` = 0 and `Available for Investigators` = 0  then 'All Samples for FNL'
		when  `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` = 0  then 'FNL Reserve and ASU only (no community vials)'
        when  `Pending Request for ASU: MISPA` > 0 and `Available for Investigators` > 0  then 'FNL Reserve,  ASU, and Community'

         
         
					else 'Need to work: No Category' end as 'Serum Status'
from

(
SELECT pv.Research_Participant_ID, pv.Visit_Info_ID, (pv.Visit_Date_Duration_From_Index - vo.Offset_Value) as 'Visit Duration from Baseline',
	round(sum(case when bp.`Vial Status` not in ('In') then 0
				   when bp.`Vial Status` = 'In' and bp.Volume > 100 then bp.Volume else bp.Volume*1000  end) ,2) as 'Parent Volume Remaining',
	sum(case when bc.Volume is NULL then 0 else bc.Volume end) as 'Total Child Volume',
    
	round(sum(case when bc.`Vial Status` = 'Reserved' or bc.`Vial Reserved For FNL` like 'Yes: Shipped%' then bc.Volume  else 0  end) ,2) as 'Child Volume: Used by FNL',
    round(sum(case when bc.`Vial Status` = 'In' and bc.`Vial Reserved For FNL` = 'Yes' then bc.Volume  else 0  end) ,2) as 'Child Volume: Reserved for FNL',
    round(sum(case when bc.`Vial Status` = 'Out' and bc.`Vial Reserved For FNL` like 'No: Shipped%' then bc.Volume  else 0  end) ,2) as 'Child Volume: Used by Investigators',
    round(sum(case when bc.`Vial Status` = 'In' and bc.`Vial Reserved For FNL` = 'No: ASU Sample Request' then bc.Volume  else 0  end) ,2) as 'Pending Request for ASU: MISPA',
    round(sum(case when bc.`Vial Status` = 'In' and bc.`Vial Reserved For FNL` = 'No: Available to Community' then bc.Volume  else 0  end) ,2) as 'Available for Investigators'

	FROM `seronetdb-Vaccine_Response_v2`.Biospecimen as bio 
join Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`
left join BSI_Child_Aliquots as bc
	on bp.Biorepository_ID = bc.Biorepository_ID
left join Participant_Visit_Info as pv
	on bio.Visit_Info_ID = pv.Visit_Info_ID
left join Visit_One_Offset_Correction as vo
	on pv.Research_Participant_ID = vo.Research_Participant_ID
where Biospecimen_Type = 'Serum' and bp.`Material Type` = 'Serum' and a.Samples_Not_Useable is NULL

group by pv.Research_Participant_ID, pv.Visit_Info_ID
order by pv.Research_Participant_ID,  (pv.Visit_Date_Duration_From_Index - vo.Offset_Value)) as t

where (`Parent Volume Remaining` + `Total Child Volume`) > 0  #remove visits with no samples collected
#where (`Child Volume: Used by Investigators` + `Pending Request for ASU: MISPA` + `Available for Investigators`) > 1000