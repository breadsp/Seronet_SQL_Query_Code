#Biospecimen_ID	SARS-CoV-2_Vaccine_Type	Vaccination_Status	Duration_Between_Vaccine_and_Visit	Expected Serum Volume (Sample at CBC)	Total Serum Volume In BSI


SELECT av.Research_Participant_ID, nv.Primary_Cohort, nv.Normalized_Visit_Index, sc.Date_Of_Event, nv.Duration_From_Visit_1, nv.Visit_Info_ID,	nv.Data_Status,
	samp.Biospecimen_ID, nv.`SARS-CoV-2_Vaccine_Type`, nv.Vaccination_Status,
    case when nv.Vaccination_Status in ("Unvaccinated", "N/A") then "Pre_Vacc"
		 when nv.Vaccination_Status in ("Dose 1 of 1", "Dose 2 of 2") then "Primary Series"
         when nv.Vaccination_Status in ("Dose 3", "Dose 3:Bivalent") then "Dose 3"
         else LEFT(nv.Vaccination_Status,9) end as "Vaccine Cat",
    
    nv.Duration_Between_Vaccine_and_Visit,
	case when Data_Status = 'Accrual Data: Future' then av.Serum_Volume_For_FNL
		when Data_Status = 'Submitted_Data: Current' and samp.Sub_Vol > 0 then samp.Sub_Vol 
        when Data_Status = 'Submitted_Data: Current' and samp.Sub_Vol is NULL and av.Serum_Volume_For_FNL > 0 then av.Serum_Volume_For_FNL
        else 0 end as 'Expected Serum Volume (Sample at CBC)',
	round(case when samp.FNL_Vial is NULL then 0 else FNL_Vial end, 2) as 'Volumne at FNL',
	round(case when samp.`Parent Vol` is not NULL then samp.`Parent Vol` else 0 end ,2) as 'Parental Volume (needs aliquoting)',
    round(case when samp.`Child_Vol` is not NULL then samp.`Child_Vol` else 0 end ,2) as 'Child Volume (Aliquoting already done)'
    
    #round(case when samp.`Parent Vol` is not NULL and samp.`Child_Vol` is Not NULL then  samp.`Parent Vol` + samp.`Child_Vol` 
	#	 when samp.`Parent Vol` is not NULL and samp.`Child_Vol` is NULL then  samp.`Parent Vol` 
	#	 when samp.`Parent Vol` is NULL and samp.`Child_Vol` is Not NULL then samp.`Child_Vol` 
     #    ELSE 0 end ,2)   AS 'Total Serum Volume In BSI'
FROM `seronetdb-Vaccine_Response`.Accrual_Visit_Info as av
join Normalized_Visit_Vaccination as nv
	on av.Research_Participant_ID = nv.Research_Participant_ID and av.Visit_Number = nv.Accrual_Visit_Num
left join Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index

left join(
select bio.Visit_Info_ID, bio.Biospecimen_ID,
	sum(case when bp.Biorepository_ID is NULL then a.Aliquot_Volume else 0 end) as 'Sub_Vol',
	sum(case when bp.Volume > 100  then bp.Volume/ 1000 
			when bp.Volume < 100  then bp.Volume
		    else 0 end) as 'Parent Vol', 
	sum(case when bp.Volume > 100 and bp.`Vial Status` in ('Out') then bp.Volume/ 1000 
			when bp.Volume < 100 and bp.`Vial Status` in ('Out') then bp.Volume
		    else 0 end) as 'FNL_Vial', 
	sum(bc.Volume)/1000 as 'Child_Vol'
	from Biospecimen as bio
	left join (select * from Aliquot where Samples_Not_Useable is NULL) as a
		on bio.Biospecimen_ID = a.Biospecimen_ID
	left join BSI_Parent_Aliquots as bp
		on a.Aliquot_ID = bp.`Current Label`
	left join BSI_Child_Aliquots as bc
		on bp.Biorepository_ID = bc.Biorepository_ID
	where bio.Biospecimen_Type = 'Serum' and 
		 #(bp.`Vial Status` in ('In', 'Empty', 'Out') or bp.`Vial Status` is NULL) and 
         (bc.`Vial Status` in ('In') or bc.`Vial Status` is NULL) 
	 group by bio.Visit_Info_ID
    ) as samp
on nv.Visit_Info_ID = samp.Visit_Info_ID
where av.Research_Participant_ID like '32_%'