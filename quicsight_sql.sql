SELECT  p.*, 
	case when p.Sex_At_Birth in ('Male', 'Female') then concat(" ", p.Sex_At_Birth) else 'Birth Sex Not Provided' end as 'Sex At Birth',
	v.Visit_Info_ID, v.Visit_Number, nv.SeroNet_Cohort, nv.Normalized_Visit_Index, nv.Date_Of_Event,  
	month( nv.Date_Of_Event) as 'Month', year( nv.Date_Of_Event) as 'Year',  pc.SeroNet_Cohort as 'Correct Cohort',
	
	ROW_NUMBER() OVER (  PARTITION BY Visit_Info_ID   ORDER BY (SELECT NULL) ) as 'Dup_Rank',
 
	case when p.Location = 'Northeast' then 'NY' else p.Location end as 'Participant Location', 

	pcs.`Diabetes`, pcs.`Hypertension`,  
    case when pcs.`Obesity` = 'underweight' then 'Under Weight' when pcs.`Obesity` = 'overweight' then 'Over Weight' else pcs.`Obesity` end as Obesity,
    
    pcs.`Cardiovascular_Disease`, pcs.`Chronic_Lung_Disease`,pcs.`Chronic_Kidney_Disease`, pcs.`Chronic_Liver_Disease`, 
    pcs.`Acute_Liver_Disease`, pcs.`Immunosuppressive_Condition`, pcs.`Autoimmune_Disorder`, pcs.`Chronic_Neurological_Condition`,
    pcs.`Chronic_Oxygen_Requirement`, pcs.`Inflammatory_Disease`, pcs.`Viral_Infection`, pcs.`Bacterial_Infection`, pcs.`Cancer`,

	pcn.`Diabetes_Description_Or_ICD10_codes`,    pcn.`Hypertension_Description_Or_ICD10_codes`,    pcn.`Obesity_Description_Or_ICD10_codes`,
    pcn.`Cardiovascular_Disease_Description_Or_ICD10_codes`,    pcn.`Chronic_Lung_Disease_Description_Or_ICD10_codes`,    pcn.`Chronic_Kidney_Disease_Description_Or_ICD10_codes`,
    pcn.`Chronic_Liver_Disease_Description_Or_ICD10_codes`,    pcn.`Acute_Liver_Disease_Description_Or_ICD10_codes`,    pcn.`Immunosuppressive_Condition_Description_Or_ICD10_codes`,
    pcn.`Autoimmune_Disorder_Description_Or_ICD10_codes`,    pcn.`Chronic_Neurological_Condition_Description_Or_ICD10_codes`,    pcn.`Chronic_Oxygen_Requirement_Description_Or_ICD10_codes`,
    pcn.`Inflammatory_Disease_Description_Or_ICD10_codes`,    pcn.`Viral_Infection_ICD10_codes_Or_Agents`,    pcn.`Bacterial_Infection_ICD10_codes_Or_Agents`,    pcn.`Cancer_Description_Or_ICD10_codes`,

	case when nv.Duration_Between_Vaccine_and_Visit is NULL then -1 
		when nv.Duration_Between_Vaccine_and_Visit > 1200 then -1 
		else nv.Duration_Between_Vaccine_and_Visit end as 'Duration Between Vaccine and Visit',
	#nv_2.`Number of Visits`,

	case when nv.Normalized_Visit_Index = 1 then dur_win.min_date else NULL end as 'First Visit Date', 
	case when nv.Normalized_Visit_Index = 1 then dur_win.max_date else NULL end as 'Last Visit Date',
	case when nv.Normalized_Visit_Index = 1 then DATEDIFF(dur_win.max_date, dur_win.min_date) else NULL end as 'Duration In Study',
	#dur_win.visit_count as 'Number of Visits',
	nc.Split_List as 'All Cancer Names',
    
    case when child_samples.`50ul` is NULL then 0 else child_samples.`50ul` end as '50ul Vials',
    case when child_samples.`300ul` is NULL then 0 else child_samples.`300ul` end as '300ul Vials',
    case when child_samples.`500ul` is NULL then 0 else child_samples.`500ul` end as '500ul Vial',
    case when child_samples.`Other Volumes` is NULL then 0 else child_samples.`Other Volumes` end as 'Other Volumes',


    case when `PBMC Vials Available` is NULL then 0 else `PBMC Vials Available` end as 'Number of PBMC Vials Available',
	case when child_samples.`Total Serum Volume` is NULL then 0 else child_samples.`Total Serum Volume` end as 'Total Serum Volume Available',

	Case when (child_samples.`Total Serum Volume` is NuLL or child_samples.`Total Serum Volume` = 0) then 'No' else 'Yes'  end as 'Total Serum Vials Available',
	case when (`PBMC Vials Available` is NULL or  `PBMC Vials Available` = 0)  then 'No' else 'Yes' end as 'PBMC Vial Available', 

	
	case when (test_res.`Spike: IgM` + test_res.`Spike: IgG`  + test_res.`Spike: Total`) > 0 then "Positive"
		 when (test_res.`Spike: IgM` + test_res.`Spike: IgG`  + test_res.`Spike: Total`) < 0 then "Negative"
		 else "Test Not Performed" end as 'Overall Spike Test Results',

	case when (test_res.`Nucleocapsid: IgM` + test_res.`Nucleocapsid: IgG`  + test_res.`Nucleocapsid: Total`) > 0 then "Positive"
		 when (test_res.`Nucleocapsid: IgM` + test_res.`Nucleocapsid: IgG`  + test_res.`Nucleocapsid: Total`) < 0 then "Negative"
		 else "Test Not Performed" end as 'Overall Nucleocapsid Test Results',

	case when test_res.`Spike: IgM` > 0 then "Positive" 		 when test_res.`Spike: IgM` < 0 then "Negative" else "Test not Performed" end as "Spike: IgM",
	case when test_res.`Spike: IgG` > 0 then "Positive" 		 when test_res.`Spike: IgG` < 0 then "Negative" else "Test not Performed" end as "Spike: IgG",
	case when test_res.`Spike: Total` > 0 then "Positive" 		 when test_res.`Spike: Total` < 0 then "Negative" else "Test not Performed" end as "Spike: Total",

	case when test_res.`Nucleocapsid: IgM` > 0 then "Positive" 		 when test_res.`Nucleocapsid: IgM` < 0 then "Negative" else "Test not Performed" end as "Nucleocapsid: IgM",
	case when test_res.`Nucleocapsid: IgG` > 0 then "Positive" 		 when test_res.`Nucleocapsid: IgG` < 0 then "Negative" else "Test not Performed" end as "Nucleocapsid: IgG",
	case when test_res.`Nucleocapsid: Total` > 0 then "Positive" 		 when test_res.`Nucleocapsid: Total` < 0 then "Negative" else "Test not Performed" end as "Nucleocapsid: Total",

	case when treat.Visit_Info_ID is NULL then "Not Treatments Reported" else "Yes: Participant has Treatment Data" end as 'Participant Reported Treatment Received',
	case when treat.`Number of Treatmets` > 5 then "6 or more Treatments" else treat.`Number of Treatmets` end as 'Number of Treatmets Reported',

	cond_sum.Health_Condition_Or_Disease, cond_sum.Health_Condition_Frequency, cond_sum.`Cond Count`,
	treat_sum.`Harmonized Treatment`, treat_sum.Treatment_Frequency, treat_sum.`Treatment Count`,

	all_treat.`All Health Conditions`, 
	all_treat.`All Treatment Names`,

	cancer_sum.`Has Cancer`,

	case when cancer_sum.`Number of Cancers` = cancer_sum.`Does not have Cancer` then 'No'
		 when cancer_sum.`Has Cancer` = 0 and  cancer_sum.`Does not have Cancer` > 0 then 'No'
		 when cancer_sum.`Number of Cancers` = cancer_sum.`Term is Not Repoted` then 'Not Reported'
		 when cancer_sum.`Number of Cancers` = cancer_sum.`Term is not Cancer` then 'No'
	     when cancer_sum.`Has Cancer` > 0 then 'Yes'
		 else 'Not Reported' end as 'Cancer Status',

	case when cancer_sum.`Number of Cancers` = cancer_sum.`Does not have Cancer` then 'Does not have Cancer'
		 when cancer_sum.`Has Cancer` = 0 and  cancer_sum.`Does not have Cancer` > 0 then 'Does not have Cancer'
		 when cancer_sum.`Number of Cancers` = cancer_sum.`Term is Not Repoted` then 'Not Reported / Unknown'
		 when cancer_sum.`Number of Cancers` = cancer_sum.`Term is not Cancer` then 'Not Cancerous'
		 when  cancer_sum.`Has Cancer` > 0 then 'Has Cancer'
		 else 'Not Reported / Unknown' end as 'Reported Cancer'




    from Participant as p 

left join Participant_Visit_Info as v 
	on p.Research_Participant_ID = v.Research_Participant_ID    

left join (Select Visit_Info_ID, count(Visit_Info_ID) as 'Tests' from Biospecimen_Test_Results group by Visit_Info_ID) as bt
	on v.Visit_Info_ID  = bt.Visit_Info_ID 
 
left join (
	SELECT bio.Visit_Info_ID,
		sum(case when `Vial Status` = 'Out' then 1 else 0 end) as 'Vial is not Available',
		sum(case when `Vial Reserved For FNL` like 'Yes%' and `Vial Status` in ('In', 'Reserved') then 1 else 0 end) as 'Vial Reserved for FNL',
		sum(case when `Vial Status` = 'In' and `Vial Reserved For FNL` like 'No%' then 1 else 0 end) as 'Vial Available to Community'
	
	FROM BSI_Parent_Aliquots as bp
		join Aliquot as a
	on bp.`Current Label` = a.Aliquot_ID
		join Biospecimen as bio
	on a.Biospecimen_ID = bio.Biospecimen_ID
	where bp.`Material Type` = 'PBMC'  and `Vial Reserved For FNL` not in ('No: Duplicated ID in BSI', 'No: Duplicate IDs Found',  'No: Material Type Mismatch')
		and (bp.`Vial Warnings` not like 'Discrepant: Aliquot Data not provided%') and bp.`Vial Status` not in ('Destroyed/Broken') 
	group by bio.Visit_Info_ID) as BSI_PBMC
on BSI_PBMC.Visit_Info_ID = v.Visit_Info_ID



left join(
        select nv.Research_Participant_ID, p.Seronet_Participant_ID, nv.Normalized_Visit_Index, nv.Visit_Info_ID,
        sum(case when bio.Biospecimen_Type = 'PBMC' and bp.Biorepository_ID is not NULL and bp.`Vial Reserved For FNL` not like 'Yes%' and bp.`Vial Status` in ('In') then 1 else 0 end) as 'PBMC Vials Available'
            
        from Normalized_Visit_Info as nv
    left join Participant as p
        on nv.Research_Participant_ID = p.Research_Participant_ID
    left join Biospecimen as bio
        on nv.Visit_Info_ID = bio.Visit_Info_ID
    left join Aliquot as a
        on bio.Biospecimen_ID = a.Biospecimen_ID
    left join BSI_Parent_Aliquots as bp
        on a.Aliquot_ID = bp.`Current Label`
    group by  nv.Research_Participant_ID, p.Seronet_Participant_ID, nv.Normalized_Visit_Index) as collect
on collect.Visit_Info_ID = v.Visit_Info_ID

left join (select distinct Research_Participant_ID, SeroNet_Cohort from  Participant_Cohort) as pc  
	on v.Research_Participant_ID = pc.Research_Participant_ID
left join Normalized_Visit_Info as nv
	on v.Visit_Info_ID = nv.Visit_Info_ID
left join (select Visit_Info_ID,  group_concat(distinct case when `Split_List` != '' then `Split_List` else `Harmonized Cancer Name` end) as 'Split_List' 
	 from Normalized_Cancer_Names group by Visit_Info_ID) as nc 
	on v.Visit_Info_ID = nc.Visit_Info_ID

left join(SELECT Visit_Info_ID, count(Split_List) as 'Number of Cancers',
	sum(case when Split_List not in  ('Not Cancer', 'Not Reported', 'Unknown', 'Does not have Cancer') then 1 else 0 end) as 'Has Cancer',
	sum(case when Split_List = 'Not Cancer' then 1 else 0 end) as 'Term is not Cancer',
    sum(case when Split_List in ('Not Reported', 'Unknown') then 1 else 0 end) as 'Term is Not Repoted',
    sum(case when Split_List in ('Does not have Cancer') then 1 else 0 end) as 'Does not have Cancer'
    from (SELECT distinct Visit_Info_ID, Split_List 	FROM Normalized_Cancer_Names) v
	group by Visit_Info_ID) as cancer_sum
on v.Visit_Info_ID = cancer_sum.Visit_Info_ID

left join (select Research_Participant_ID, count(Normalized_Visit_Index) as 'Number of Visits'
			from  Normalized_Visit_Info
			group by Research_Participant_ID) as nv_2
	on p.Research_Participant_ID = nv_2.Research_Participant_ID

left join Withdrawn_List as wl
	 on p.Research_Participant_ID = wl.Research_Participant_ID
left join (select * from  Participant_Comorbidities_Status where Visit_Info_ID like '%B01') as pcs
	on pcs.Visit_Info_ID = v.Visit_Info_ID
left join (Select * from Participant_Comorbidities_Names  where Visit_Info_ID like '%B01') as pcn
	on pcn.Visit_Info_ID = v.Visit_Info_ID

left join(
	SELECT Visit_Info_ID, count(Visit_Info_ID) as 'Number of Treatmets'
		FROM Treatment_History
	group by Visit_Info_ID) as treat 
on v.Visit_Info_ID = treat.Visit_Info_ID

left join(
	SELECT Research_Participant_ID, min(Date_Of_Event) as min_date,max(Date_Of_Event) as max_date, count(Date_Of_Event) as visit_count
		FROM Normalized_Visit_Info
	group by Research_Participant_ID) as dur_win 
on p.Research_Participant_ID = dur_win.Research_Participant_ID

left join(
	SELECT Visit_Info_ID, 
		sum( case when lower(Assay_Target) like '%spike%' and Measurand_Antibody = 'IgG' and (lower(Interpretation) like '%positive%' or lower(Interpretation) = 'reactive') then 10
					when lower(Assay_Target) like '%spike%' and Measurand_Antibody = 'IgG' and(lower(Interpretation) like '%negative%' or lower(Interpretation) = 'non-reactive') then -1
					else 0 end) as 'Spike: IgG',
		sum( case when lower(Assay_Target) like '%spike%' and Measurand_Antibody = 'IgM' and (lower(Interpretation) like '%positive%' or lower(Interpretation) = 'reactive') then 10
					when lower(Assay_Target) like '%spike%' and Measurand_Antibody = 'IgM' and(lower(Interpretation) like '%negative%' or lower(Interpretation) = 'non-reactive') then -1
					else 0 end) as 'Spike: IgM',
		sum( case when lower(Assay_Target) like '%spike%' and Measurand_Antibody = 'Total antibodies' and (lower(Interpretation) like '%positive%' or lower(Interpretation) = 'reactive') then 10
					when lower(Assay_Target) like '%spike%' and Measurand_Antibody = 'Total antibodies' and(lower(Interpretation) like '%negative%' or lower(Interpretation) = 'non-reactive') then -1
					else 0 end) as 'Spike: Total',
					
		sum( case when lower(Assay_Target) like '%nucleocapsid%' and Measurand_Antibody = 'IgG' and (lower(Interpretation) like '%positive%' or lower(Interpretation) = 'reactive') then 10
					when lower(Assay_Target) like '%nucleocapsid%' and Measurand_Antibody = 'IgG' and(lower(Interpretation) like '%negative%' or lower(Interpretation) = 'non-reactive') then -1
					else 0 end) as 'Nucleocapsid: IgG',
		sum( case when lower(Assay_Target) like '%nucleocapsid%' and Measurand_Antibody = 'IgM' and (lower(Interpretation) like '%positive%' or lower(Interpretation) = 'reactive') then 10
					when lower(Assay_Target) like '%nucleocapsid%' and Measurand_Antibody = 'IgM' and(lower(Interpretation) like '%negative%' or lower(Interpretation) = 'non-reactive') then -1
					else 0 end) as 'Nucleocapsid: IgM',
		sum( case when lower(Assay_Target) like '%nucleocapsid%' and Measurand_Antibody = 'Total antibodies' and (lower(Interpretation) like '%positive%' or lower(Interpretation) = 'reactive') then 10
					when lower(Assay_Target) like '%nucleocapsid%' and Measurand_Antibody = 'Total antibodies' and(lower(Interpretation) like '%negative%' or lower(Interpretation) = 'non-reactive') then -1
					else 0 end) as 'Nucleocapsid: Total'
		FROM Biospecimen_Test_Results
		group by Visit_Info_ID) as test_res 
on v.Visit_Info_ID = test_res.Visit_Info_ID

left join(
	select nt.*,cond_summary.`Cond Count`,
		case when cond_summary.`Cond Count` >= 50 then 'Over 50 visits' else 'Under 50 Visits' end as Health_Condition_Frequency
	from  Normalized_Treatment_Visit_Info as nt
	left join(
		SELECT Health_Condition_Or_Disease, count(Health_Condition_Or_Disease) as 'Cond Count'
			FROM Normalized_Treatment_Visit_Info
		group by Health_Condition_Or_Disease) as cond_summary
	on nt.Health_Condition_Or_Disease = cond_summary.Health_Condition_Or_Disease
	where cond_summary.`Cond Count` >= 50
	group by Visit_Info_ID) as cond_sum 
on v.Visit_Info_ID = cond_sum.Visit_Info_ID

left join(
	select nt.*, treat_summary.`Treatment Count`,
		case when treat_summary.`Treatment Count` >= 200 then 'Over 200 visits' else 'Under 200 Visits' end as Treatment_Frequency
	from  Normalized_Treatment_Visit_Info as nt
	left join(
		SELECT `Harmonized Treatment`, count(`Harmonized Treatment`) as 'Treatment Count'
			FROM Normalized_Treatment_Visit_Info
			group by `Harmonized Treatment`) as treat_summary
		on nt.`Harmonized Treatment` = treat_summary.`Harmonized Treatment`
		where treat_summary.`Treatment Count` >= 200
		group by Visit_Info_ID) as treat_sum 
on v.Visit_Info_ID = treat_sum.Visit_Info_ID

left join (
	SELECT Visit_Info_ID, count(Visit_Info_ID),  
			Group_CONCAT(distinct Health_Condition_Or_Disease ORDER BY Health_Condition_Or_Disease SEPARATOR ' | ' ) as 'All Health Conditions', 
			Group_CONCAT(distinct `Harmonized Treatment` order by `Harmonized Treatment` SEPARATOR ' | ') as 'All Treatment Names'

	FROM Normalized_Treatment_Visit_Info
	group by Visit_Info_ID) as all_treat
on v.Visit_Info_ID	 = all_treat.Visit_Info_ID

left join (
    select Visit_Info_ID, sum(`Serum Volume`) as 'Total Serum Volume', count(`CGR_Aliquot_ID`) as 'Total Child Vials', sum(`50ul`) as '50ul', sum(`300ul`) as '300ul', sum(`500ul`) as '500ul',
	sum(`Other Volumes`) as 'Other Volumes'

	from 
	(select bio.Visit_Info_ID, bc.*
			from Biospecimen as bio
		join Aliquot as a
			on a.Biospecimen_ID = bio.Biospecimen_ID
		join BSI_Parent_Aliquots as bp
			on bp.`Current Label` = a.Aliquot_ID
		join

		(select Biorepository_ID, CGR_Aliquot_ID, FLOOR(volume / 50) * 50 as 'Serum Volume', 
				case when FLOOR(volume / 50) * 50 = 50 then 1 else 0 end as '50ul',
				case when FLOOR(volume / 50) * 50 = 300 then 1 else 0 end as '300ul',   
				case when FLOOR(volume / 50) * 50 = 500 then 1 else 0 end as '500ul',
				case when FLOOR(volume / 50) * 50 not in (50, 300, 500) then 1 else 0 end as 'Other Volumes'
				
				from BSI_Child_Aliquots
			where `Vial Status` in ('In') and `Vial Reserved For FNL` = 'No: Available to Community') as bc
		on bp.Biorepository_ID = bc.Biorepository_ID) as t
	group by Visit_Info_ID) as child_samples
on nv.Visit_Info_ID = child_samples.Visit_Info_ID

where wl.Research_Participant_ID is NULL and v.Submission_Index <= 305 and p.Seronet_Participant_ID !=  'No Specimens Collected' and p.Research_Participant_ID != '14_M67037'