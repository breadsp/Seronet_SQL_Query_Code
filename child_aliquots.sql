select * from 

(select nv.Research_Participant_ID, nv.SeroNet_Cohort, nv.Normalized_Visit_Index, samp.*
  from Normalized_Visit_Info as nv

left join(
SELECT #nv.Research_Participant_ID, nv.Normalized_Visit_Index, 
	bio.Visit_Info_ID, count(bc.CGR_Aliquot_ID) as 'Child Vials', sum(bc.Volume) as 'Child Volume',
    sum(case when bc.Volume < 50 then 1 else 0 end) as 'To Small',
    sum(case when bc.Volume >= 50 and bc.Volume < 100 then 1 else 0 end) as '50ul vial',
    sum(case when bc.Volume >= 100 and bc.Volume < 150 then 1 else 0 end) as '100ul vial',
    sum(case when bc.Volume >= 150 and bc.Volume < 200 then 1 else 0 end) as '150ul vial',
    sum(case when bc.Volume >= 200 and bc.Volume < 250 then 1 else 0 end) as '200ul vial',
    sum(case when bc.Volume >= 250 and bc.Volume < 300 then 1 else 0 end) as '250ul vial',
    sum(case when bc.Volume >= 300 and bc.Volume < 350 then 1 else 0 end) as '300ul vial',
	sum(case when bc.Volume >= 350 and bc.Volume < 400 then 1 else 0 end) as '350ul vial',
    sum(case when bc.Volume >= 400 and bc.Volume < 450 then 1 else 0 end) as '400ul vial',
    sum(case when bc.Volume >= 450 and bc.Volume < 500 then 1 else 0 end) as '450ul vial',
    sum(case when bc.Volume >= 500 and bc.Volume < 550 then 1 else 0 end) as '500ul vial',
	sum(case when bc.Volume >= 550 and bc.Volume < 600 then 1 else 0 end) as '550ul vial',
    sum(case when bc.Volume >= 600 and bc.Volume < 650 then 1 else 0 end) as '600ul vial',
    sum(case when bc.Volume >= 650 and bc.Volume < 700 then 1 else 0 end) as '650ul vial',
    sum(case when bc.Volume >= 700 and bc.Volume < 1000 then 1 else 0 end) as '700ul vial'
    
FROM BSI_Child_Aliquots as bc
	join BSI_Parent_Aliquots as bp
on bp.Biorepository_ID = bc.Biorepository_ID
	join Aliquot as a
on bp.`Current Label` = a.Aliquot_ID
	join Biospecimen as bio
on a.Biospecimen_ID = bio.Biospecimen_ID
#	join Normalized_Visit_Info as nv
#on bio.Visit_Info_ID = nv.Visit_Info_ID
where bc.`Vial Reserved For FNL` = 'No: Available to Community'
group by bio.Visit_Info_ID) as samp
on nv.Visit_Info_ID  = samp.Visit_Info_ID
where samp.Visit_Info_ID is not NULL) as samples