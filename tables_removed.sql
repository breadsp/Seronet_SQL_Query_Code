
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Treatment_History;

DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Sample_Collection_Table;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Reagent;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Organ_Transplant_Cohort;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Normalized_Visit_Vaccination;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Normalized_Treatment_Names;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Normalized_Treatment_Dict;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Normalized_Comorbidity_Names;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Normalized_Comorbidity_Dictionary;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Normalized_Cancer_Names_v2;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Normalized_Cancer_Dictionary;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Non_SARS_Covid_2_Vaccination_Status;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.HIV_Cohort;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Equipment;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Drugs_And_Alcohol_Use;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Consumable;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Comorbidities_Names;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Comorbidities_Baseline_Provenance;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Cancer_Cohort;

DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Biospecimen_Type;

DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Biospecimen_Reagent;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Biospecimen_Consumable;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Biospecimen_Equipment;

DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.AutoImmune_Cohort;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Assay_Target;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Assay_Quality_Controls;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Assay_Organism_Conversion;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Assay_Metadata;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Assay_Calibration;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Assay_Bio_Target;

DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Accrual_Participant_Info;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Accrual_Vaccination_Status;
DROP TABLE if exists `seronetdb-Vaccine_Response_v2`.Accrual_Visit_Info;


INSERT INTO `seronetdb-Vaccine_Response_v2`.Accrual_Participant_Info
SELECT * FROM `seronetdb-Vaccine_Response`.Accrual_Participant_Info;
