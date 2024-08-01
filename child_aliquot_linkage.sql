select nv.Visit_Info_ID, nv.Normalized_Visit_Index, bio.Visit_Info_ID, a.Aliquot_ID, bio.Biospecimen_Type, bp.Biorepository_ID, bp.Volume, bc.`Child_Aliquots`
from Normalized_Visit_Vaccination as nv
join Biospecimen as bio
	on nv.Visit_Info_ID = bio.Visit_Info_ID	       #link visit vaccine table to biospecimen
join Aliquot as a
    on bio.Biospecimen_ID = a.Biospecimen_ID       #link biospecimen to aliquot
left join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`	       #link aliquot to BSI parent data 
left join( select Biorepository_ID, count(CGR_Aliquot_ID) as 'Child_Aliquots' from BSI_Child_Aliquots group by Biorepository_ID) as bc
	on bp.Biorepository_ID = bc.Biorepository_ID  #link BSI parent to Child aliquot (CGR, ATCC, FNL)
where a.Samples_Not_Useable is NULL               #remove aliquot data in which samples do not exist