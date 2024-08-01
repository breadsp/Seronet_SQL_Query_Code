# Research Participant ID	Primary Cohort	Normalized Visit Index	Serum Status	Volume Available	Location	Date Of Event	SARS-CoV-2 Vaccine Type	Vaccination Status	Duration Between Vaccine and Visit	Cardiovascular Disease	Cardiovascular Disease Description Or ICD10 codes	Symptoms	Long COVID symptoms	Other Long COVID symptoms	Viral Infection ICD10 codes Or Agents	IgG Interpretation	IgG Derived Result Units	IgG Derived Result Units	IgM Interpretation	IgM Derived Result Units	IgM Derived Result Units	Data Status	Sample Status
#Symptoms	Long COVID symptoms	Other Long COVID symptoms	Viral Infection ICD10 codes Or Agents


SELECT nv.Research_Participant_ID, nv.Primary_Cohort, nv.Normalized_Visit_Index, p.Location, sc.Date_Of_Event, nv.`SARS-CoV-2_Vaccine_Type`, 
	nv.Vaccination_Status, nv.Duration_Between_Vaccine_and_Visit,   cardio.Cardiovascular_Disease, cardio.Cardiovascular_Disease_Description_Normalized,
    ch.Symptoms, ch.`Long_COVID_symptoms`,	ch.`Other_Long_COVID_symptoms`,	cn.`Viral_Infection_ICD10_codes_Or_Agents`,
    IgG.`IgG Interpretation`, IgM.`IgM Interpretation`,
    bp.`Vial Status` as "Sample_At_BSI", bp.Volume, bp.`Volume Unit`
    
	#	IgG Interpretation	IgG Derived Result Units	IgM Interpretation	IgM Derived Result Units
	FROM `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination as nv
left join Participant  as p
	on nv.Research_Participant_ID = p.Research_Participant_ID
left join Sample_Collection_Table as sc
	on nv.Research_Participant_ID = sc.Research_Participant_ID and nv.Normalized_Visit_Index = sc.Normalized_Visit_Index
left join Covid_History as ch
	on nv.Visit_Info_ID = ch.Visit_Info_ID
left join Comorbidities_Names as cn
	on nv.Visit_Info_ID = cn.Visit_Info_ID
    
left join (
	SELECT left(pc.Visit_Info_ID,9) as "Part_ID", pc.Cardiovascular_Disease, Cardiovascular_Disease_Description_Normalized
	FROM `seronetdb-Vaccine_Response`.Participant_Comorbidities as pc
	join `seronetdb-Vaccine_Response`.Normalized_Comorbidity_Names as nc
		on pc.Visit_Info_ID = nc.Visit_Info_ID
	where pc.Visit_Info_ID like '%B01') as cardio
	on nv.Research_Participant_ID = cardio.Part_ID
left join(
	SELECT Visit_Info_ID, Interpretation as 'IgG Interpretation',  Derived_Result as 'IgG Derived Result',  Derived_Result_Units as 'IgG Derived Result Units'
	FROM `seronetdb-Vaccine_Response`.Biospecimen_Test_Results
	where Measurand_Antibody = 'IgG') as IgG
on nv.Visit_Info_ID = IgG.Visit_Info_ID
left join(
	SELECT Visit_Info_ID, Interpretation as 'IgM Interpretation',  Derived_Result as 'IgM Derived Result',  Derived_Result_Units as 'IgM Derived Result Units'
	FROM `seronetdb-Vaccine_Response`.Biospecimen_Test_Results
	where Measurand_Antibody = 'IgM') as IgM
on nv.Visit_Info_ID = IgM.Visit_Info_ID

    
    
left join  Biospecimen as bio 
	on nv.Visit_Info_ID = bio.Visit_Info_ID
left join Aliquot as a
	on bio.Biospecimen_ID = a.Biospecimen_ID
left join BSI_Parent_Aliquots as bp
	on a.Aliquot_ID = bp.`Current Label`
where nv.Research_Participant_ID like '32_44%' 
	 and nv.Primary_Cohort = 'HIV' and Biospecimen_Type = 'Serum' and bp.Volume >= 3.0
order by nv.Research_Participant_ID, nv.Duration_From_Visit_1