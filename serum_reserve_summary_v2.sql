

SELECT `FNL_Reserve_Group`, `FNL_Reserve_Sub_Cat`, count(bp.Biorepository_ID) as 'Parent Vials', 
    round(avg( `Child Vol Reserve`),2) as 'Average Reserved Volume', round(avg(`Available Volume`),2) as 'Average Available Volume'
    
    #round(avg(`Child Vials Reserve`),2) as 'Reserve Vials (Avg)' , round(avg(`Child Vol Reserve`),2) as 'Reserve Volume (Avg)', round(avg(`Available Volume`),2) as 'Available Volume (Avg)'
   from BSI_Parent_Aliquots as bp
left join(
	select Biorepository_ID, 
		sum(case when `Vial Reserved For FNL` like 'Yes%' then 1 end) as 'Child Vials Reserve',
		sum(case when `Vial Reserved For FNL` like 'Yes%' then Volume end) as 'Child Vol Reserve',
        sum(case when `Vial Reserved For FNL` = 'No' then Volume end) as 'Available Volume'
        from BSI_Child_Aliquots
        group by Biorepository_ID) as child
on bp.Biorepository_ID = child.Biorepository_ID

   
where  `Material Type` = 'Serum' #and FNL_Reserve_Group like 'Group 2%'
group by   `FNL_Reserve_Group`, `FNL_Reserve_Sub_Cat`
order by   `FNL_Reserve_Group`, `FNL_Reserve_Sub_Cat`;



update BSI_Parent_Aliquots 
set `FNL_Reserve_Group` = 'Group 0: No Child Aliquots', `FNL_Reserve_Sub_Cat` = 'Visit Has Other Aliquoted Vials'
where FNL_Reserve_Group = 'Group 4:Extra Vials Not Reserved' and `FNL_Reserve_Sub_Cat` = 'No Aliquoted Vials'


