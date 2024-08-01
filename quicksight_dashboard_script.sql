SELECT distinct 
	case when p.age is NULL then ap.Age else p.Age end as 'Age', 
    case when p.Race is NULL then ap.Race else p.Race end as 'Race',
    case when p.Ethnicity is NULL then ap.Ethnicity else p.Ethnicity end as 'Ethnicity',
    case when p.Sex_At_Birth is not NULL and p.Sex_At_Birth in ('Male', 'Female') then p.Sex_At_Birth
         when p.Sex_At_Birth is NULL and ap.Sex_At_Birth in ('Male', 'Female') then ap.Sex_At_Birth
         else "Unknown/Not Reported" end  as 'Reported Sex',
 
    case when Comorbidities.Diabetes = 'Yes' then '  Yes'  when Comorbidities.Diabetes = 'No' then ' No' 
        when Comorbidities.Diabetes = "Unknown" then "Not Reported" else  Comorbidities.Diabetes end as "Diabetes",
    case when Comorbidities.Obesity like "Class%" then Comorbidities.Obesity else  concat(" ", Comorbidities.Obesity) end as "Obesity",
    case when Comorbidities.Chronic_Lung_Disease = 'Yes' then '  Yes'  when Comorbidities.Chronic_Lung_Disease = 'No' then ' No' 
         when Comorbidities.Chronic_Lung_Disease = "Unknown" then "Not Reported" else  Comorbidities.Chronic_Lung_Disease end as "Chronic_Lung_Disease",
    case when Comorbidities.Chronic_Kidney_Disease = 'Yes' then '  Yes'  when Comorbidities.Chronic_Kidney_Disease = 'No' then ' No' 
         when Comorbidities.Chronic_Kidney_Disease = "Unknown" then "Not Reported" else  Comorbidities.Chronic_Kidney_Disease end as "Chronic_Kidney_Disease",
    case when Comorbidities.Chronic_Liver_Disease = 'Yes' then '  Yes'  when Comorbidities.Chronic_Liver_Disease = 'No' then ' No' 
         when Comorbidities.Chronic_Liver_Disease = "Unknown" then "Not Reported" else  Comorbidities.Chronic_Liver_Disease end as "Chronic_Liver_Disease",
    case when Comorbidities.Chronic_Neurological_Condition = 'Yes' then '  Yes'  when Comorbidities.Chronic_Neurological_Condition = 'No' then ' No' 
         when Comorbidities.Chronic_Neurological_Condition = "Unknown" then "Not Reported" else  Comorbidities.Chronic_Neurological_Condition end as "Chronic_Neurological_Condition",
    case when Comorbidities.Chronic_Oxygen_Requirement = 'Yes' then '  Yes'  when Comorbidities.Chronic_Oxygen_Requirement = 'No' then ' No' 
         when Comorbidities.Chronic_Oxygen_Requirement = "Unknown" then "Not Reported" else  Comorbidities.Chronic_Oxygen_Requirement end as "Chronic_Oxygen_Requirement",
    case when Comorbidities.Immunosuppressive_Condition = 'Yes' then '  Yes'  when Comorbidities.Immunosuppressive_Condition = 'No' then ' No' 
         when Comorbidities.Immunosuppressive_Condition = "Unknown" then "Not Reported" else  Comorbidities.Immunosuppressive_Condition end as "Immunosuppressive_Condition",
    case when Comorbidities.Autoimmune_Disorder = 'Yes' then '  Yes'  when Comorbidities.Autoimmune_Disorder = 'No' then ' No' 
         when Comorbidities.Autoimmune_Disorder = "Unknown" then "Not Reported" else  Comorbidities.Autoimmune_Disorder end as "Autoimmune Disorder",

    case when Comorbidities.Hypertension = 'Yes' then '  Yes'  when Comorbidities.Hypertension = 'No' then ' No'
         when Comorbidities.Hypertension = "Unknown" then "Not Reported" else  Comorbidities.Hypertension end as "Hypertension",
    case when Comorbidities.Cardiovascular_Disease = 'Yes' then '  Yes'  when Comorbidities.Cardiovascular_Disease = 'No' then ' No'
         when Comorbidities.Cardiovascular_Disease = "Unknown" then "Not Reported" else  Comorbidities.Cardiovascular_Disease end as "Cardiovascular Disease",
    case when Comorbidities.Inflammatory_Disease = 'Yes' then '  Yes'  when Comorbidities.Inflammatory_Disease = 'No' then ' No'
         when Comorbidities.Inflammatory_Disease = "Unknown" then "Not Reported" else  Comorbidities.Inflammatory_Disease end as "Inflammatory Disease",
    case when Comorbidities.Viral_Infection = 'Yes' then '  Yes'  when Comorbidities.Viral_Infection = 'No' then ' No'
         when Comorbidities.Viral_Infection = "Unknown" then "Not Reported" else  Comorbidities.Viral_Infection end as "Viral Infection",
    case when Comorbidities.Bacterial_Infection = 'Yes' then '  Yes'  when Comorbidities.Bacterial_Infection = 'No' then ' No'
         when Comorbidities.Bacterial_Infection = "Unknown" then "Not Reported" else  Comorbidities.Bacterial_Infection end as "Bacterial Infection",
    case when Comorbidities.Cancer = 'Yes' then '  Yes'  when Comorbidities.Cancer = 'No' then ' No'
         when Comorbidities.Cancer = "Unknown" then "Not Reported" else  Comorbidities.Cancer end as "Cancer",

    nv.Research_Participant_ID as 'Participant Count',
    nv.*, 
    month(ap.Sunday_Prior_To_Visit_1) as "Month",
    year(ap.Sunday_Prior_To_Visit_1) as "Year", 
    
    case when left(nv.Research_Participant_ID, 2) = 14 then "Icahn School Of  Medicine At Mount Sinai"
         when left(nv.Research_Participant_ID, 2) = 27 then "University of Minnesota"
         when left(nv.Research_Participant_ID, 2) = 32 then "Arizona State University"
         when left(nv.Research_Participant_ID, 2) = 41 then "Feinstein Institutes for Medical Research"
         else "Unknown CBC" end as "CBC Name",
    case when p.BMI is NULL then 0 else p.BMI end as BMI, 

    case when nv.Serum_Volume_For_FNL > 0 and nv.Num_PBMC_Vials_For_FNL > 1 and Data_Status = 'Accrual Data: Future' then "Serum and PBMC"
         when nv.Serum_Volume_For_FNL > 0 and nv.Num_PBMC_Vials_For_FNL <= 1 and Data_Status = 'Accrual Data: Future' then "Serum Only"
         when nv.Serum_Volume_For_FNL = 0 and nv.Num_PBMC_Vials_For_FNL > 1 and Data_Status = 'Accrual Data: Future' then "PBMC Only"
         when BSI_Data.`Serum Available` > 0 and BSI_Data.`PBMC Available` > 1 and Data_Status = 'Submitted_Data: Current' then "Serum and PBMC"
         when BSI_Data.`Serum Available` > 0 and BSI_Data.`PBMC Available` <= 1 and Data_Status = 'Submitted_Data: Current' then "Serum Only"
         when BSI_Data.`Serum Available` = 0 and BSI_Data.`PBMC Available` > 1 and Data_Status = 'Submitted_Data: Current' then "PBMC Only"
         else "No Samples Available" end as "Samples Collected",


	case when sum(case when ch.Breakthrough_COVID = 'yes' then 100 when ch.Breakthrough_COVID = 'no' then -10 else 0 end) > 0 then "Yes"
		 when sum(case when ch.Breakthrough_COVID = 'yes' then 10 when ch.Breakthrough_COVID = 'no' then -10 else 0 end) < 0 then "No"
         else "No Covid Test Reported" end as "Breakthrough Infection",
    case when Vaccination_Status like "Dose%" then concat(" ", Vaccination_Status) else Vaccination_Status end as "Vaccination Dosage",
    case when `SARS-CoV-2_Vaccine_Type` not like "N/A" then concat(" ", `SARS-CoV-2_Vaccine_Type`) 
         when `SARS-CoV-2_Vaccine_Type` = 'pfizer' then ' Pfizer' 
         else `SARS-CoV-2_Vaccine_Type` end as "Vaccination Type",

    case when Duration_Between_Vaccine_and_Visit is NULL and `Vaccination_Status` = 'Unvaccinated' then -30 
         when Duration_Between_Vaccine_and_Visit is NULL and `Vaccination_Status` = 'No Vaccination Data' then -15
         when Duration_Between_Vaccine_and_Visit < 1000 then Duration_Between_Vaccine_and_Visit 
         else NULL end as "Duration", 
         
    case when `SEER_Category` is NULL then 'Not Reported' else `SEER_Category` end as  `SEER Category`,

	case when bio_table.Assay_Target is NULL then " No Assay Preformed" else bio_table.Assay_Target end as Assay_Target,
    case when bio_table.Assay_Target_Sub_Region is NULL then " No Assay Preformed" 
		 when bio_table.Assay_Target_Sub_Region = "" then "No Subregion"  
         when bio_table.Assay_Target_Sub_Region = "spike protein receptor-binding domain" then "RBD"
		 else bio_table.Assay_Target_Sub_Region end as Assay_Target_Sub_Region,
    case when bio_table.Measurand_Antibody is NULL then "No Assay Preformed" else bio_table.Measurand_Antibody end as Measurand_Antibody,
    case when bio_table.`SARS_CoV-2 Test Result: IgG` is NULL then " No Assay Preformed" else bio_table.`SARS_CoV-2 Test Result: IgG` end as 'SARS_CoV-2 Test Result: IgG',
    case when bio_table.`SARS_CoV-2 Test Result: IgM` is NULL then " No Assay Preformed" else bio_table.`SARS_CoV-2 Test Result: IgM` end as 'SARS_CoV-2 Test Result: IgM',
    case when bio_table.`SARS_CoV-2 Test Result: Total` is NULL then " No Assay Preformed" else bio_table.`SARS_CoV-2 Test Result: Total` end as 'SARS_CoV-2 Test Result: Total',

    case when organ.`Organ Transplant` is NULL then "No Transplant Receieved" else organ.`Organ Transplant` end as 'Organ Transplant',
    case when organ.Number_Of_Solid_Organ_Transplants is NULL then 0 else organ.Number_Of_Solid_Organ_Transplants end as Number_Of_Solid_Organ_Transplants,
    case when organ.Number_of_Hematopoietic_Cell_Transplants is NULL then 0 else organ.Number_of_Hematopoietic_Cell_Transplants end as Number_of_Hematopoietic_Cell_Transplants,
    
    vacc_series.Unvacc,              case when vacc_series.Unvacc > 0 then 'Yes' else 'No' end as 'Has Unvaccinated Visit',
    vacc_series.Primary,             case when vacc_series.`Primary` > 0 then 'Yes' else 'No' end as 'Has Primary Series Visit',
    vacc_series.Mono_Booster,        case when vacc_series.Mono_Booster > 0 then 'Yes' else 'No' end as 'Has Monovalent Booster Series Visit',
    vacc_series.Bivalent_Booster,    case when vacc_series.Bivalent_Booster > 0 then 'Yes' else 'No' end as 'Has Bivalent Booster Series Visit',

    case when symptoms.`Covid Test` is NULL then " No Test Reported" else symptoms.`Covid Test` end as 'Covid Test',
    case when symptoms.`Severity Defination` is NULL then "  No Test Reported" else symptoms.`Severity Defination` end as 'Severity Defination',
    case when can.Cancer_Type like 'Number of Cancers' then can.Cancer_Type else concat(' ', can.Cancer_Type) end as Cancer_Type,
    can.`Harmonized Cancer Name`

from `seronetdb-Vaccine_Response`.Participant as p

right join (
	select nv.*, sc.Date_Of_Event, sc.Serum_Volume_For_FNL,  sc.Submitted_PBMC_Vials, sc.Num_PBMC_Vials_For_FNL, sc.Submitted_Serum_Volume,
    sc.Serum_Volume_Received, sc.PBMC_Vials_Received
	from `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination as nv
    left join `seronetdb-Vaccine_Response`.Sample_Collection_Table as sc
	on sc.Research_Participant_ID = nv.Research_Participant_ID and sc.Normalized_Visit_Index = nv.Normalized_Visit_Index) as nv
on p.Research_Participant_ID = nv.Research_Participant_ID

left join `seronetdb-Vaccine_Response`.Accrual_Participant_Info as ap
on nv.Research_Participant_ID = ap.Research_Participant_ID
 
left Join `seronetdb-Vaccine_Response`.Participant_Visit_Info as v
on nv.Visit_Info_ID = v.Visit_Info_ID
left Join `seronetdb-Vaccine_Response`.Covid_History as ch
on v.Visit_Info_ID = ch.Visit_Info_ID

left join (
     SELECT b.Visit_Info_ID, 
	sum(case when bp.`Material Type` = 'Serum' then 1 else 0 end) as 'Serum Available',
     sum(case when bp.`Material Type` = 'PBMC' then 1 else 0 end) as 'PBMC Available'
     FROM `seronetdb-Vaccine_Response`.BSI_Parent_Aliquots as bp
     join `seronetdb-Vaccine_Response`.Aliquot as a
     on a.Aliquot_ID = bp.`Current Label`
     join `seronetdb-Vaccine_Response`.Biospecimen as b
     on a.Biospecimen_ID = b.Biospecimen_ID
     where bp.`Vial Status` in ('In', 'Empty')
     group by b.Visit_Info_ID) as BSI_Data
on BSI_Data.Visit_Info_ID = v.Visit_Info_ID

left join (
	select *
	from `seronetdb-Vaccine_Response`.Participant_Comorbidities as cm
    where Visit_Info_ID like '%B01') as Comorbidities
on v.Research_Participant_ID = left(Comorbidities.Visit_Info_ID, 9)

left join (select Visit_Info_ID, Cancer_Type, `Harmonized Cancer Name`,
	case when `SEER Category` like '%|%' then "Multiple Cancers"
			when `SEER Category` is NULL then 'Not Reported'
            else `SEER Category` end as `SEER_Category`
	 FROM `seronetdb-Vaccine_Response`.Normalized_Cancer_Names_v2 ) as can
on v.Visit_Info_ID  = can.Visit_Info_ID

left JOIN(
	Select b.Visit_Info_ID, b.Assay_Target, b.Assay_Target_Sub_Region, b.Measurand_Antibody,
		case when sum(case when lower(b.Interpretation) like '%positive%' and Measurand_Antibody = 'IgG' then 1 else 0 end) = 0 then "Negative" 
			 when sum(case when lower(b.Interpretation) like '%positive%' and Measurand_Antibody = 'IgG' then 1 else 0 end) > 0 then "Positive" 
			 else "No Assay Preformed" end as 'SARS_CoV-2 Test Result: IgG',
        case when sum(case when lower(b.Interpretation) like '%positive%' and Measurand_Antibody = 'IgM' then 1 else 0 end) = 0 then "Negative" 
			 when sum(case when lower(b.Interpretation) like '%positive%' and Measurand_Antibody = 'IgM' then 1 else 0 end) > 0 then "Positive" 
			 else "No Assay Preformed" end as 'SARS_CoV-2 Test Result: IgM',
        case when sum(case when lower(b.Interpretation) like '%positive%' and Measurand_Antibody = 'Total antibodies' then 1 else 0 end) = 0 then "Negative" 
			 when sum(case when lower(b.Interpretation) like '%positive%' and Measurand_Antibody = 'Total antibodies' then 1 else 0 end) > 0 then "Positive" 
			 else "No Assay Preformed" end as 'SARS_CoV-2 Test Result: Total'

	from `seronetdb-Vaccine_Response`.Biospecimen_Test_Results as b
    where Assay_Target not in ('Nucleocapsid (N) antigen')
	group by b.Visit_Info_ID) as bio_table
on v.Visit_Info_ID = bio_table.Visit_Info_ID

left join(
    SELECT Visit_Info_ID, `Organ Transplant`, Number_of_Hematopoietic_Cell_Transplants, Number_Of_Solid_Organ_Transplants
    FROM `seronetdb-Vaccine_Response`.Organ_Transplant_Cohort
    where Visit_Info_ID like '%B01') as organ
on v.Visit_Info_ID = organ.Visit_Info_ID

left join(
    SELECT nv.Research_Participant_ID,
     	sum(case when Vaccination_Status = 'Unvaccinated' and 
			(sc.Submitted_Serum_Volume > 0 or sc.Submitted_PBMC_Vials > 1) and (nv.Data_Status = 'Submitted_Data: Current') then 1 else 0 end) as 'Unvacc',
		sum(case when (Vaccination_Status = 'Dose 2 of 2' or Vaccination_Status = 'Dose 1 of 1' or Vaccination_Status = 'Dose 3') and 
            (sc.Submitted_Serum_Volume > 0 or sc.Submitted_PBMC_Vials > 1) and (nv.Data_Status = 'Submitted_Data: Current') then 1 else 0 end) as 'Primary',
      sum(case when Vaccination_Status like 'Booster%' and Vaccination_Status not like '%Bivalent%' and 
            (sc.Submitted_Serum_Volume > 0 or sc.Submitted_PBMC_Vials > 1) and (nv.Data_Status = 'Submitted_Data: Current') then 1 else 0 end) as 'Mono_Booster',
        sum(case when Vaccination_Status like 'Booster%' and Vaccination_Status like '%Bivalent%' and 
            (sc.Submitted_Serum_Volume > 0 or sc.Submitted_PBMC_Vials > 1) and (nv.Data_Status = 'Submitted_Data: Current') then 1 else 0 end) as 'Bivalent_Booster'

    FROM `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination as nv
    join `seronetdb-Vaccine_Response`.Sample_Collection_Table as sc 
    on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index
    group by nv.Research_Participant_ID) as vacc_series
on nv.Research_Participant_ID = vacc_series.Research_Participant_ID

left join(
    SELECT Visit_Info_ID,	COVID_Status, Average_Duration_Of_Test,  Symptomatic_COVID, Disease_Severity,

case when COVID_Status = "No COVID data collected" then " No Test Reported"
	 when COVID_Status = "No COVID event reported" then " No Test Reported"
     when COVID_Status not like '%Positive%' then "Negative Test"
     when COVID_Status like '%Likely COVID Positive%' then "No Test: Likely Positive"
     else "Positive" end as "Covid Test",
case when Disease_Severity = 'Not Reported' and COVID_Status in ('No COVID event reported', 'No COVID data collected') then "  No Test Reported"
	 when Disease_Severity = 'Not Reported' and COVID_Status not in ('No COVID event reported', 'No COVID data collected') then "Disease Severity Not Reported"
	 when Disease_Severity = 0 then " No clinical or virological evidence of infection"
	 when Disease_Severity = 1 then " No Symptoms"
     when Disease_Severity = 2 then "Mild Symptoms"
     when Disease_Severity >=3 then "Went to Hospital"
     else "  No Test Reported" end as "Severity Defination"
     
 FROM `seronetdb-Vaccine_Response`.Covid_History
) as symptoms 
on v.Visit_Info_ID = symptoms.Visit_Info_ID

where nv.Research_Participant_ID is not NULL and (Duration_Between_Vaccine_and_Visit < 1000 or Duration_Between_Vaccine_and_Visit is NULL) and
      (nv.Data_Status = 'Submitted_Data: Current' ) and (ap.Sunday_Prior_To_Visit_1 is not NULL) and (BSI_Data.`Serum Available` > 0 or BSI_Data.`PBMC Available` > 1 ) and
      nv.Research_Participant_ID not in ('27_300089', '27_300106', '27_300168', '27_300537', '27_400094')


group by nv.Research_Participant_ID, nv.Normalized_Visit_Index