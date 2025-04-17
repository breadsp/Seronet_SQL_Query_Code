Drop table if exists `seronetdb-Vaccine_Response`.`Normalized_Comorbidity_Dictionary`;

DROP Table if exists `seronetdb-Vaccine_Response`.`Shipping_Manifest`;

DROP Table if exists `seronetdb-Vaccine_Response`.`BSI_Child_Aliquots`;
DROP Table if exists `seronetdb-Vaccine_Response`.`BSI_Parent_Aliquots`;

DROP Table if exists `seronetdb-Vaccine_Response`.`Aliquot`;
DROP Table if exists `seronetdb-Vaccine_Response`.`Biospecimen_Test_Results`;
drop table if exists `seronetdb-Vaccine_Response`.`Biospecimen_Reagent`;
drop table if exists `seronetdb-Vaccine_Response`.`Reagent`;
drop table if exists `seronetdb-Vaccine_Response`.`Biospecimen_Equipment`;
drop table if exists `seronetdb-Vaccine_Response`.`Equipment`;

drop table if exists `seronetdb-Vaccine_Response`.`Biospecimen_Consumable`;
drop table if exists `seronetdb-Vaccine_Response`.`Consumable`;
DROP Table if exists `seronetdb-Vaccine_Response`.`Biospecimen`;

DROP Table if exists `seronetdb-Vaccine_Response`.`Covid_History`;
DROP Table if exists `seronetdb-Vaccine_Response`.`Covid_Vaccination_Status`;

Drop Table if exists `seronetdb-Vaccine_Response`.`Drugs_And_Alcohol_Use`;
Drop Table if exists `seronetdb-Vaccine_Response`.`Specimens_Collected`;
Drop table if exists `seronetdb-Vaccine_Response`.`Non_SARS_Covid_2_Vaccination_Status`;
DROP TABLE IF EXISTS `seronetdb-Vaccine_Response`.`Participant_Comorbidities`;
DROP TABLE IF EXISTS `seronetdb-Vaccine_Response`.`Comorbidities_Names`;
DROP TABLE IF EXISTS `seronetdb-Vaccine_Response`.`Treatment_History`;

#DROP TABLE IF EXISTS `seronetdb-Vaccine_Response`.`Participant_Visit_Info`;
#DROP Table if exists `seronetdb-Vaccine_Response`.`Submission`;
#DROP TABLE IF EXISTS `seronetdb-Vaccine_Response`.`Participant`;
DROP TABLE IF EXISTS `seronetdb-Vaccine_Response`.`Tube`;

drop table if exists  `seronetdb-Vaccine_Response`.`Biospecimen_Test_Results`;

#drop table if exists  `seronetdb-Vaccine_Response`.`Assay_Target`;
#drop table if exists  `seronetdb-Vaccine_Response`.`Assay_Quality_Controls`;
#drop table if exists  `seronetdb-Vaccine_Response`.`Assay_Organism_Conversion`;
#drop table if exists  `seronetdb-Vaccine_Response`.`Assay_Bio_Target`;
#drop table if exists  `seronetdb-Vaccine_Response`.`Assay_Calibration`;
#drop table if exists  `seronetdb-Vaccine_Response`.`Assay_Metadata`;

drop table if exists  `seronetdb-Vaccine_Response`.`Participant_Other_Conditions`;
drop table if exists  `seronetdb-Vaccine_Response`.`Participant_Other_Condition_Names`;
drop table if exists  `seronetdb-Vaccine_Response`.`AutoImmune_Cohort`;
drop table if exists  `seronetdb-Vaccine_Response`.`Cancer_Cohort`;
drop table if exists  `seronetdb-Vaccine_Response`.`HIV_Cohort`;
drop table if exists  `seronetdb-Vaccine_Response`.`Organ_Transplant_Cohort`;

drop table if exists  `seronetdb-Vaccine_Response`.`Participant_Visit_Info`;
drop table if exists  `seronetdb-Vaccine_Response`.`Participant`;

drop table if exists  `seronetdb-Vaccine_Response`.`Submission`;

-- -----------------------------------------------------
-- Schema seronetdb-Vaccine_Response
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `seronetdb-Vaccine_Response` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `seronetdb-Vaccine_Response` ;


CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Study_Design` (
-- Data comes from the study design template located in Box
	`Cohort_Index` INT Primary Key auto_increment,
	`Cohort_Name` varchar(255),
	`Index_Date` varchar(255),
	`Notes` varchar(255),
    `CBC_Name` varchar(255));

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`CBC` (
-- Data comes from the SeroNet_Org_IDs.xlsx file located in box
  `CBC_ID` varchar(255) PRIMARY KEY,
  `CBC_Name` varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Biospecimen_Type` (
  `Biospecimen_Type` varchar(255) PRIMARY KEY,
  `NCIT_Code` varchar(255),
  `caDSR_Code` varchar(255)
);

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Submission` (
-- Data comes from the submission file names located in S3, this is independant of the Data in the files
  `Submission_Index` INT NOT NULL,
  `Submission_CBC_Name` VARCHAR(255) NULL DEFAULT NULL,
  `Submission_CBC_ID` VARCHAR(255) NULL DEFAULT NULL,
  `Submission_Time` DATETIME NULL DEFAULT NULL,
  `Submission_File_Name` VARCHAR(255) NULL DEFAULT NULL,
  `Submission_S3_Path` VARCHAR(255) NOT NULL,
  `Date_Submission_Validated` DATETIME NULL DEFAULT NULL,
  `Submission_Intent` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`Submission_Index`, `Submission_S3_Path`));
-- ---------------------------------------------------------------------------------------------------
-- Baseline and Follow up Tables
-- ---------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Participant` (
-- Information comes from the baseline template
  `Research_Participant_ID` VARCHAR(50) NOT NULL,
  `Age` FLOAT NOT NULL,
  `Sex_At_Birth` VARCHAR(50) NULL DEFAULT NULL,
  `Race` VARCHAR(255) NULL DEFAULT NULL,
  `Ethnicity` VARCHAR(255) NULL DEFAULT NULL,
  `Height` Varchar(255) NULL DEFAULT NULL,
  `Weight` Varchar(255) NULL DEFAULT NULL,
  `BMI` Varchar(255) NULL DEFAULT NULL,
  `Location` VARCHAR(50) NULL DEFAULT NULL,
  `Submission_Index` INT,
  PRIMARY KEY (`Research_Participant_ID`, `Age`),
  CONSTRAINT `Participant_ibfk_1`
    FOREIGN KEY (`Submission_Index`)
    REFERENCES `seronetdb-Vaccine_Response`.`Submission` (`Submission_Index`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
  
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (
-- Data comes from baseline and followup templates
  `Visit_Info_ID` VARCHAR(50) NOT NULL,
  `Research_Participant_ID` VARCHAR(50) NOT NULL,
  `Cohort` VARCHAR(255) NOT NULL,
  `Type_Of_Visit` VARCHAR(50) NOT NULL,
  `Visit_Number` varchar(50) NOT NULL,
  `Unscheduled_Visit` varchar(50) NULL DEFAULT NULL,
  `Visit_Date_Duration_From_Index` FLOAT NULL DEFAULT NULL,
  `Lost_to_Follow_Up` varchar(50) NULL DEFAULT NULL,
  `Final_Visit`varchar(50) NULL DEFAULT NULL,
  `Submission_Index` INT NOT NULL,
  PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Participant_Visit_Info_ibfk_1`
    FOREIGN KEY (`Research_Participant_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Participant` (`Research_Participant_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Submission_ibfk_1`
    FOREIGN KEY (`Submission_Index`)
    REFERENCES `seronetdb-Vaccine_Response`.`Submission` (`Submission_Index`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Drugs_And_Alcohol_Use` (
-- Data comes from baseline and followup templates
  `Visit_Info_ID` VARCHAR(50) NOT NULL,
  `Drug_Type` varchar(50) DEFAULT NULL,	
  `Drug_Use` varchar(50) DEFAULT NULL,
  `ECOG_Status`	varchar(50) DEFAULT NULL,
  `Smoking_Or_Vaping_Status` varchar(50) DEFAULT NULL,
  `Alcohol_Use`	varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Drugs_And_Alcohol_Use_ibfk_1`
    FOREIGN KEY (`Visit_Info_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Specimens_Collected` (
-- Data comes from baseline and followup templates
  `Visit_Info_ID` VARCHAR(50),  
  `Biospecimens_Collected` varchar(255),
  PRIMARY KEY (`Visit_Info_ID`, `Biospecimens_Collected`),
  CONSTRAINT `Specimens_Collected_ibfk_1`
    FOREIGN KEY (`Visit_Info_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Non_SARS_Covid_2_Vaccination_Status` (
-- Data comes from baseline and followup templates
  `Visit_Info_ID` VARCHAR(50) NOT NULL,  
  `Vaccination_Record` varchar(255),
  PRIMARY KEY (`Visit_Info_ID`, `Vaccination_Record`),
  CONSTRAINT `Non_SARS_Covid_2_Vaccination_Status_ibfk_1`
    FOREIGN KEY (`Visit_Info_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);  

CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`Participant_Comorbidities` (
-- Data comes from baseline and Follow up templates
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `Diabetes` VARCHAR(255),
  `Hypertension` VARCHAR(255),
  `Obesity` VARCHAR(255),
  `Cardiovascular_Disease` VARCHAR(255),
  `Chronic_Lung_Disease` VARCHAR(255),
  `Chronic_Kidney_Disease` VARCHAR(255),
  `Chronic_Liver_Disease` VARCHAR(255),
  `Acute_Liver_Disease` VARCHAR(255),
  `Immunosuppressive_Condition` VARCHAR(255),
  `Autoimmune_Disorder` VARCHAR(255),
  `Chronic_Neurological_Condition` VARCHAR(255),
  `Chronic_Oxygen_Requirement` VARCHAR(255),
  `Inflammatory_Disease` VARCHAR(255),
  `Viral_Infection` VARCHAR(255),
  `Bacterial_Infection` VARCHAR(255),
  `Cancer` VARCHAR(255),
  PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Participant_Comorbidities_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`Comorbidities_Names` (
-- Data comes from baseline and Follow up templates
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `Diabetes_Description_Or_ICD10_codes` VARCHAR(255),
  `Hypertension_Description_Or_ICD10_codes` VARCHAR(255),
  `Obesity_Description_Or_ICD10_codes` VARCHAR(255),
  `Cardiovascular_Disease_Description_Or_ICD10_codes` VARCHAR(255),
  `Chronic_Lung_Disease_Description_Or_ICD10_codes` VARCHAR(255),
  `Chronic_Kidney_Disease_Description_Or_ICD10_codes` VARCHAR(255),
  `Chronic_Liver_Disease_Description_Or_ICD10_codes` VARCHAR(255),
  `Acute_Liver_Disease_Description_Or_ICD10_codes` VARCHAR(255),
  `Immunosuppressive_Condition_Description_Or_ICD10_codes` VARCHAR(255),
  `Autoimmune_Disorder_Description_Or_ICD10_codes` VARCHAR(255),
  `Chronic_Neurological_Condition_Description_Or_ICD10_codes` VARCHAR(255),
  `Chronic_Oxygen_Requirement_Description_Or_ICD10_codes` VARCHAR(255),
  `Inflammatory_Disease_Description_Or_ICD10_codes` VARCHAR(255),
  `Viral_Infection_ICD10_codes_Or_Agents` VARCHAR(255),
  `Bacterial_Infection_ICD10_codes_Or_Agents` VARCHAR(255),
  `Cancer_Description_Or_ICD10_codes` VARCHAR(255),
  PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Comorbidities_Names_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`Participant_Other_Conditions` (
-- Data comes from baseline and Follow up templates
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `Substance_Abuse_Disorder` VARCHAR(255),
  `Organ_Transplant_Recipient` VARCHAR(255),
PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Participant_Other_Conditions_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`Participant_Other_Condition_Names` (
-- Data comes from baseline and Follow up templates
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `Substance_Abuse_Disorder_Description_Or_ICD10_codes` VARCHAR(255),
  `Organ_Transplant_Description_Or_ICD10_codes` VARCHAR(255),
  `Other_Health_Condition_Description_Or_ICD10_codes` VARCHAR(255),
PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Participant_Other_Condition_Names_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);
-- ---------------------------------------------------------------------------------------------------
-- Biospecimen and Aliquot Tables
-- ---------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Tube` (
-- Data comes from biospecimen and aliquot
  `Tube_ID` INT NOT NULL AUTO_INCREMENT,
  `Tube_Used_For` VARCHAR(255) NOT NULL,
  `Tube_Type_Lot_Number` VARCHAR(255) NULL DEFAULT NULL,
  `Tube_Type_Catalog_Number` VARCHAR(255) NULL DEFAULT NULL,
  `Tube_Type` VARCHAR(255) NULL DEFAULT NULL,
  `Tube_Type_Expiration_Date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`Tube_ID`));

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Biospecimen` (
-- Data comes from biospecimen templte
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `Research_Participant_ID` VARCHAR(255) NOT NULL,
  `Biospecimen_ID` VARCHAR(255) NOT NULL,
  `Biospecimen_Tube_ID` INT NULL DEFAULT NULL,
  `Biospecimen_Type` VARCHAR(255) NOT NULL,
  `Biospecimen_Collection_Date_Duration_From_Index` float,
  `Biospecimen_Processing_Batch_ID` VARCHAR(255) NULL DEFAULT NULL,
  `Initial_Volume_of_Biospecimen` FLOAT NULL DEFAULT NULL,
  `Biospecimen_Collection_Company_Clinic` VARCHAR(255) NULL DEFAULT NULL,
  `Biospecimen_Collector_Initials` VARCHAR(100) NULL DEFAULT NULL,
  `Biospecimen_Collection_Year` INT NULL DEFAULT NULL,
  `Storage_Time_at_2_8_Degrees_Celsius` FLOAT NULL DEFAULT NULL,
  `Storage_Start_Time_at_2-8_Initials` VARCHAR(100) NULL DEFAULT NULL,
  `Storage_End_Time_at_2-8_Initials` VARCHAR(100) NULL DEFAULT NULL,
  `Biospecimen_Processing_Company_Clinic` VARCHAR(255) NULL DEFAULT NULL,
  `Biospecimen_Processor_Initials` VARCHAR(100) NULL DEFAULT NULL,
  `Biospecimen_Collection_to_Receipt_Duration` FLOAT NULL DEFAULT NULL,
  `Biospecimen_Receipt_to_Storage_Duration` FLOAT NULL DEFAULT NULL,
  `Centrifugation_Time` FLOAT NULL DEFAULT NULL,
  `RT_Serum_Clotting_Time` FLOAT NULL DEFAULT NULL,
  `Live_Cells_Hemocytometer_Count` double NULL DEFAULT NULL,
  `Total_Cells_Hemocytometer_Count` double NULL DEFAULT NULL,
  `Viability_Hemocytometer_Count` double NULL DEFAULT NULL,
  `Live_Cells_Automated_Count` double NULL DEFAULT NULL,
  `Total_Cells_Automated_Count` double NULL DEFAULT NULL,
  `Viability_Automated_Count` double NULL DEFAULT NULL,
  `Storage_Time_in_Mr_Frosty` float,
  `Biospecimen_Comments` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`Biospecimen_ID`, `Research_Participant_ID`, `Biospecimen_Type`),
  INDEX `Visit_Info_ID` (`Visit_Info_ID` ASC) VISIBLE,
  INDEX `Research_Participant_ID` (`Research_Participant_ID` ASC) VISIBLE,
  INDEX `Biospecimen_Tube_ID` (`Biospecimen_Tube_ID` ASC) VISIBLE,
  CONSTRAINT `Biospecimen_ibfk_1`
    FOREIGN KEY (`Visit_Info_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Biospecimen_ibfk_2`
	FOREIGN KEY (`Research_Participant_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Participant` (`Research_Participant_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Biospecimen_ibfk_3`
    FOREIGN KEY (`Biospecimen_Tube_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Tube` (`Tube_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Aliquot` (
-- Data comes from the Aliquot template
  `Biospecimen_ID` VARCHAR(255) NOT NULL,
  `Aliquot_ID` VARCHAR(255) NOT NULL,
  `Aliquot_Volume` FLOAT NOT NULL,
  `Aliquot_Units` VARCHAR(255) NOT NULL,
  `Aliquot_Concentration` FLOAT NULL DEFAULT NULL,
  `Aliquot_Initials` VARCHAR(100) NULL DEFAULT NULL,
  `Aliquot_Tube_ID` INT NULL DEFAULT NULL,
  `Aliquot_Comments` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`Aliquot_ID`, `Biospecimen_ID`),
  INDEX `Biospecimen_ID` (`Biospecimen_ID` ASC) VISIBLE,
  INDEX `Aliquot_Tube_ID` (`Aliquot_Tube_ID` ASC) VISIBLE,
  CONSTRAINT `Aliquot_ibfk_1`
    FOREIGN KEY (`Biospecimen_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Biospecimen` (`Biospecimen_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Aliquot_ibfk_2`
    FOREIGN KEY (`Aliquot_Tube_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Tube` (`Tube_ID`));
-- ---------------------------------------------------------------------------------------------------
-- Assay Data Tables
-- ---------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Assay_Metadata` (
  `Assay_ID` varchar(255),
  `Technology_Type` varchar(255), -- vocab table?
  `Assay_Name` varchar(255)  NOT NULL, -- removed unique, added in target bio type as key 		
  `Assay_Manufacturer` varchar(255)  NOT NULL,
  `EUA_Status` varchar(255), -- vocab table
  `Assay_Multiplicity` varchar(255), -- ??
  `Developer/Substrate` varchar(255),
  `Developer/Substrate Manufacturer` varchar(255),
  `Platform` varchar(255),
  `Platform Manufacturer` varchar(255),
  `Analysis Method` varchar(255),
  `Analysis Software` varchar(255),
  `Assay_Target_Organism` varchar(255) NOT NULL, -- vocab
  primary key (`Assay_ID`,  `Assay_Target_Organism`)
  );
  
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Assay_Calibration`(
  `Assay_ID` varchar(255),
  `Calibration_Type` varchar(255), -- vocab
  `Calibrator_High_or_Positive` varchar(255), -- bool?
  `Calibrator_Low_or_Negative` varchar(255), -- bool?
  `Standard Source` varchar(255),
  `Standard Concentration Upper` varchar(255),
  `Standard Concentration Lower` varchar(255),
  `Standard Concentration Units` varchar(255),
  `Standard Curve Diluent` varchar(255),
  `Standard Curve Dilution Value` varchar(255),
  `Number of Standard Dilutions` varchar(255),
  `N_true_positive` int,
  `N_true_negative` int,
  `N_false_positive` int,
  `N_false_negative` int,
  `Peformance_Statistics_Source` varchar(255), -- vocab
  `Number of Samples Per Plate` varchar(255),
  `Number of Sample Dilutions` int,
  `Sample Dilution Value` varchar(255),
  `Testing Format` varchar(255),
  `Starting Sample Dilution` varchar(255),
  primary key (`Assay_ID`,  `Calibration_Type`),
  FOREIGN KEY (`Assay_ID`) REFERENCES `Assay_Metadata` (`Assay_ID`) ON DELETE CASCADE ON UPDATE CASCADE
  );
  
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Assay_Target`(
  `Assay_ID` varchar(255),
  `Assay_Target_Organism` varchar(255) NOT NULL, -- vocab
  `Assay_Target` varchar(255) NOT NULL, -- vocab
  `Assay_Target_Sub_Region` varchar(255), -- vocab
  `Measurand_Antibody_Type` varchar(255), -- vocab
  `Assay_Result_Type` varchar(255), -- vocab
  `Assay_Result_Unit` varchar(255), -- vocab
  `Positive_Cut_Off_Threshold` varchar(255), -- string value??
  `Negative_Cut_Off_Ceiling` varchar(255), -- string value??
  `Cut_Off_Unit` varchar(255), -- vocab
  `Low_Positive_Lower_Limit` float,
  `Low_Positive_Upper_Limit` float,
  `Medium_Positive_Lower_Limit` float,
  `Medium_Positive_Upper_Limit` float,
  `High_Positive_Lower_Limit` float,
  `High_Positive_Upper_Limit` float,
  `Assay_Antigen_Source` varchar(255),
  `Assay Antigen Method Of Production` varchar(255),
  `Plasmid Description` varchar(255),
  primary key (`Assay_ID`, `Assay_Target_Organism`, `Assay_Target`),
  FOREIGN KEY (`Assay_ID`) REFERENCES `Assay_Metadata` (`Assay_ID`) ON DELETE CASCADE ON UPDATE CASCADE
  --  FOREIGN KEY (`Target_Organism`) REFERENCES `Assay_Metadata` (`Target_Organism`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Assay_Bio_Target` (
	`Assay_Bio_Target_Index` int PRIMARY KEY AUTO_INCREMENT,
	`Assay_ID` varchar(255),
    `Target_Biospecimen_Type` varchar(255),
    `Is_Present` varchar(255),  -- Yes
	FOREIGN KEY (`Target_Biospecimen_Type`) REFERENCES `Biospecimen_Type` (`Biospecimen_Type`) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (`Assay_ID`) REFERENCES `Assay_Metadata` (`Assay_ID`) ON DELETE CASCADE ON UPDATE CASCADE
    );

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Assay_Quality_Controls` (
	`Assay_QC_Index` int PRIMARY KEY AUTO_INCREMENT,
	`Assay_ID` varchar(255),
    `Quality_Control_Name` varchar(255),
    `Quality_Control_Source` varchar(255),
    `Quality_Control` varchar(255),
    `Quality_Control_Type` varchar(255),    
	FOREIGN KEY (`Assay_ID`) REFERENCES `Assay_Metadata` (`Assay_ID`) ON DELETE CASCADE ON UPDATE CASCADE
    );

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Assay_Organism_Conversion` (
	`Assay_Organism_Index` int PRIMARY KEY AUTO_INCREMENT,
    `CBC_Name` varchar(255),
	`Assay_ID` varchar(255),
    `Assay_Target_Organism` varchar(255),
    `Assay_Target` varchar(255),
    `Target_Organism_Conversion` varchar(255),
	FOREIGN KEY (`Assay_ID`) REFERENCES `Assay_Metadata` (`Assay_ID`) ON DELETE CASCADE ON UPDATE CASCADE
    );
-- -----------------------------------------------------
-- Consubable Tables
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Consumable` (
-- Data from Consumable Template
  `Consumable_Name_Index` INT NOT NULL AUTO_INCREMENT,
  `Consumable_Name` VARCHAR(255) NOT NULL,
  `Consumable_Catalog_Number` VARCHAR(255) NULL DEFAULT NULL,
  `Consumable_Lot_Number` VARCHAR(255) NULL DEFAULT NULL,
  `Consumable_Expiration_Date` DATE NULL DEFAULT NULL,
  `Consumable_Comments` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`Consumable_Name_Index`));

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Biospecimen_Consumable` (
-- Data from Consumable Template
  `Consumable_Biospecimen_ID` INT NOT NULL AUTO_INCREMENT,
  `Biospecimen_ID` VARCHAR(255) NOT NULL,
  `Consumable_Name_Index` INT NOT NULL,
  PRIMARY KEY (`Consumable_Biospecimen_ID`),
  INDEX `Biospecimen_ID` (`Biospecimen_ID` ASC) VISIBLE,
  INDEX `Consumable_Name_Index` (`Consumable_Name_Index` ASC) VISIBLE,
  CONSTRAINT `Biospecimen_Consumable_ibfk_1`
    FOREIGN KEY (`Biospecimen_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Biospecimen` (`Biospecimen_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Biospecimen_Consumable_ibfk_2`
    FOREIGN KEY (`Consumable_Name_Index`)
    REFERENCES `seronetdb-Vaccine_Response`.`Consumable` (`Consumable_Name_Index`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
-- -----------------------------------------------------
-- Equipment Tables
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Equipment` (
  `Equipment_Index` INT NOT NULL AUTO_INCREMENT,
  `Equipment_ID` VARCHAR(255) NULL DEFAULT NULL,
  `Equipment_Type` VARCHAR(255) NULL DEFAULT NULL,
  `Equipment_Calibration_Due_Date` DATE NULL DEFAULT NULL,
  `Equipment_Comments` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`Equipment_Index`));

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Biospecimen_Equipment` (
  `Biospecimen_Equipment_ID` INT NOT NULL AUTO_INCREMENT,
  `Biospecimen_ID` VARCHAR(255) NOT NULL,
  `Equipment_Index` INT NOT NULL,
  PRIMARY KEY (`Biospecimen_Equipment_ID`),
  INDEX `Biospecimen_ID` (`Biospecimen_ID` ASC) VISIBLE,
  INDEX `Equipment_Index` (`Equipment_Index` ASC) VISIBLE,
  CONSTRAINT `Biospecimen_Equipment_ibfk_1`
    FOREIGN KEY (`Biospecimen_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Biospecimen` (`Biospecimen_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Biospecimen_Equipment_ibfk_2`
    FOREIGN KEY (`Equipment_Index`)
    REFERENCES `seronetdb-Vaccine_Response`.`Equipment` (`Equipment_Index`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
-- -----------------------------------------------------
-- Reagent Tables
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Reagent` (
  `Reagent_Name_Index` INT NOT NULL AUTO_INCREMENT,
  `Reagent_Lot_Number` VARCHAR(255) NULL DEFAULT NULL,
  `Reagent_Name` VARCHAR(255) NOT NULL,
  `Reagent_Catalog_Number` VARCHAR(255) NULL DEFAULT NULL,
  `Reagent_Expiration_Date` DATE NULL DEFAULT NULL,
  `Reagent_Comments` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`Reagent_Name_Index`));

CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Biospecimen_Reagent` (
  `Reagent_Biospecimen_ID` INT NOT NULL AUTO_INCREMENT,
  `Biospecimen_ID` VARCHAR(255) NOT NULL,
  `Reagent_Name_Index` INT NOT NULL,
  PRIMARY KEY (`Reagent_Biospecimen_ID`),
  INDEX `Biospecimen_ID` (`Biospecimen_ID` ASC) VISIBLE,
  INDEX `Reagent_Name_Index` (`Reagent_Name_Index` ASC) VISIBLE,
  CONSTRAINT `Biospecimen_Reagent_ibfk_1`
    FOREIGN KEY (`Biospecimen_ID`)
    REFERENCES `seronetdb-Vaccine_Response`.`Biospecimen` (`Biospecimen_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Biospecimen_Reagent_ibfk_2`
    FOREIGN KEY (`Reagent_Name_Index`)
    REFERENCES `seronetdb-Vaccine_Response`.`Reagent` (`Reagent_Name_Index`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
-- -----------------------------------------------------
-- Table `seronetdb-Vaccine_Response`.`Shipping_Manifest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Shipping_Manifest` (
  `Submission_Index` INT NOT NULL,
  `Study ID` VARCHAR(255) NULL DEFAULT NULL,
  `Material Type` VARCHAR(255) NULL DEFAULT NULL,
  `Current Label` VARCHAR(255) NOT NULL,
  `Volume` FLOAT NULL DEFAULT NULL,
  `Volume Unit` VARCHAR(255) NULL DEFAULT NULL,
  `Volume Estimate` VARCHAR(255) NULL DEFAULT NULL,
  `Vial Type` VARCHAR(255) NULL DEFAULT NULL,
  `Vial Warnings` VARCHAR(255) NULL DEFAULT NULL,
  `Vial Modifiers` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`Current Label`, `Submission_Index`),
  INDEX `Submission_Index` (`Submission_Index` ASC) VISIBLE,
  CONSTRAINT `Shipping_Manifest_ibfk_1`
    FOREIGN KEY (`Submission_Index`)
    REFERENCES `seronetdb-Vaccine_Response`.`Submission` (`Submission_Index`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Shipping_Manifest_ibfk_2`
    FOREIGN KEY (`Current Label`)
    REFERENCES `seronetdb-Vaccine_Response`.`Aliquot` (`Aliquot_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
-- -----------------------------------------------------
-- Table `seronetdb-Vaccine_Response`.`Covid_History`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Covid_History` (
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `COVID_Status` VARCHAR(255) NOT NULL,
  `Breakthrough_COVID` VARCHAR(255) NOT NULL,
  `SARS-CoV-2_Variant` VARCHAR(255) NOT NULL,
  `PCR_Test_Date_Duration_From_Index` Float NOT NULL,
  `Rapid_Antigen_Test_Date_Duration_From_Index` Float NOT NULL,
  `Antibody_Test_Date_Duration_From_Index` Float NOT NULL,
  `Symptomatic_COVID` VARCHAR(255) NOT NULL,
  `Recovered_From_COVID` VARCHAR(255) NOT NULL,
  `Duration_of_Disease` VARCHAR(255),
  `Recovery_Date_Duration_From_Index` VARCHAR(255),
  `Disease_Severity` varchar(50),
  `Level_Of_Care`  VARCHAR(255) NOT NULL,
  `Symptoms`  VARCHAR(255) NOT NULL,
  `Other_Symptoms`  VARCHAR(255) NOT NULL,
  `COVID_complications`  VARCHAR(255) NOT NULL,
  `Long_COVID_symptoms`  VARCHAR(255) NOT NULL,
  `Other_Long_COVID_symptoms`  VARCHAR(255) NOT NULL,
  `COVID_Therapy`  VARCHAR(255) NOT NULL,
  `Covid_History_Comments`  VARCHAR(1000) NULL DEFAULT NULL,
  #PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Covid_History_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);
-- -----------------------------------------------------
-- Table `seronetdb-Vaccine_Response`.`Covid_Vaccination_Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `seronetdb-Vaccine_Response`.`Covid_Vaccination_Status` (
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `Research_Participant_ID` VARCHAR(255) NOT NULL,
  `Vaccination_Status` VARCHAR(50) NOT NULL,
  `SARS-CoV-2_Vaccine_Type` VARCHAR(255) NOT NULL,
  `SARS-CoV-2_Vaccination_Date_Duration_From_Index` VARCHAR(255) NOT NULL,
  `SARS-CoV-2_Vaccination_Side_Effects` VARCHAR(255) NOT NULL,
  `Other_SARS-CoV-2_Vaccination_Side_Effects` VARCHAR(255) NOT NULL,
  `Covid_Vaccination_Status_Comments`  VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`Visit_Info_ID`, `Research_Participant_ID`, `Vaccination_Status`),
  CONSTRAINT `Covid_Vaccination_Status_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);
-- -----------------------------------------------------
-- Table `seronetdb-Vaccine_Response`.`Biospecimen_Test_Results`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`Biospecimen_Test_Results` (
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `Assay_ID` varchar(10) NOT NULL,
  `Instrument_ID` varchar(255) NOT NULL,
  `Test_Operator_Initials` varchar(255) NOT NULL,
  `Assay_Kit_Lot_Number` varchar(255) NOT NULL,
  `Test_Batch_ID` varchar(255) NOT NULL,
  `Biospecimen_Collection_to_Test_Duration` FLOAT NOT NULL,
  `Assay_Target_Organism` varchar(50) NOT NULL,
  `Assay_Target` varchar(50) NOT NULL,
  `Assay_Target_Sub_Region` varchar(50) NOT NULL,
  `Measurand_Antibody` varchar(255) NOT NULL,
  `Assay_Replicate` int NOT NULL,
  `Sample_Type` varchar(255) NOT NULL,
  `Sample_Dilution` int NOT NULL,
  `Interpretation` varchar(255) NOT NULL,
  `Derived_Result` varchar(255) NOT NULL,
  `Derived_Result_Units` varchar(255) NOT NULL,
  `Raw_Result` float NOT NULL,
  `Raw_Result_Units` varchar(255) NOT NULL,
  `Positive_Control_Reading` float NOT NULL,
  `Negative_Control_Reading` float NOT NULL,
  `Biospecimen_Test_Results_Comments` varchar(1000),
  PRIMARY KEY (`Visit_Info_ID`, `Assay_ID`, `Assay_Target_Organism`, `Assay_Target`, `Assay_Target_Sub_Region`, `Measurand_Antibody`(50)),
  CONSTRAINT `Biospecimen_Test_Results_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
  CONSTRAINT `Biospecimen_Test_Results_ibfk_2`
	FOREIGN KEY (`Assay_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Assay_Metadata` (`Assay_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);
-- -----------------------------------------------------
-- Table `seronetdb-Vaccine_Response`.`Treatment_History`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`Treatment_History` (
  `Visit_Info_ID` VARCHAR(50) NOT NULL,
  `Health_Condition_Or_Disease` VARCHAR(255),
  `Treatment` VARCHAR(255),
  `Dosage` VARCHAR(100),
  `Dosage_Units` VARCHAR(255),
  `Dosage_Regimen` VARCHAR(255),
  `Start_Date_Duration_From_Index` VARCHAR(255),
  `Stop_Date_Duration_From_Index` VARCHAR(255),
  `Update` VARCHAR(255),
  `Treatment_History_Comments` VARCHAR(255),
  PRIMARY KEY (`Visit_Info_ID`, `Health_Condition_Or_Disease`, `Treatment`,`Dosage`),
  CONSTRAINT `Treatment_History_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);
-- -----------------------------------------------------
-- Cohort Tables
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`AutoImmune_Cohort` (
	`Visit_Info_ID` VARCHAR(255) NOT NULL,
    `Autoimmune_Condition` varchar(50),
	`Autoimmune_Condition_ICD10_code` varchar(1000),
	`Year_Of_Diagnosis_Duration_to_Index` varchar(50),
	`Antibody_Name` varchar(255),
	`Antibody_Present` varchar(50),
	`Update` varchar(50),
	`AutoImmune_Cohort_Comments` varchar(1000),
      PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `AutoImmune_Cohort_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`Cancer_Cohort` (
	`Visit_Info_ID` VARCHAR(255) NOT NULL,
    `Cancer` varchar(50),
	`ICD_10_Code` varchar(1000),
	`Year_Of_Diagnosis_Duration_From_Index` varchar(50),
	`Cured` varchar(255),
	`In_Remission` varchar(50),
    `In_Unspecified_Therapy` varchar(255),
    `Chemotherapy`  varchar(255),
	`Radiation Therapy`  varchar(255),
	`Surgery`  varchar(255),
	`Update` varchar(50),
	`Cancer_Cohort_Comments` varchar(1000),
      PRIMARY KEY (`Visit_Info_ID`, `Cancer`, `Year_Of_Diagnosis_Duration_From_Index`),
  CONSTRAINT `Cancer_Cohort_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`HIV_Cohort` (
	`Visit_Info_ID` VARCHAR(255) NOT NULL,
    `Viral_RNA_Load` varchar(50),
	`Viral_RNA_Load_Reporting_Date_Duration_From_Index` varchar(50),
	`CD4_Count` varchar(50),
	`CD4_Count_Reporting_Date_Duration_From_Index` varchar(50),
    `Opportunistic_Infection_History` varchar(255),
    `OI_Status_Reporting_Date_Duration_From_Index`  varchar(255),
	`Update` varchar(50),
	`HIV_Cohort_Comments` varchar(1000),
      PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `HIV_Cohort_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS  `seronetdb-Vaccine_Response`.`Organ_Transplant_Cohort` (
	`Visit_Info_ID` VARCHAR(255) NOT NULL,
    `Organ Transplant` varchar(255),
	`Organ_Transplant_Other` varchar(255),
	`Number_of_Hematopoietic_Cell_Transplants` varchar(50),
	`Number_Of_Solid_Organ_Transplants` varchar(50),
	`Date_of_Latest_Hematopoietic_Cell_Transplant_Duration_From_Index` varchar(50),
    `Date_of_Latest_Solid_Organ_Transplant_Duration_From_Index` varchar(50),
	`Update` varchar(50),
	`Organ_Transplant_Cohort_Comments` varchar(1000),
      PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Organ_Transplant_Cohort_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);
-- -----------------------------------------------------
-- BSI Tables
-- -----------------------------------------------------
Create table if not Exists `seronetdb-Vaccine_Response`.`BSI_Parent_Aliquots` (
	`CBC_Biospecimen_Aliquot_ID` varchar(255),
	`Biorepository_ID` varchar(255) primary key,
    `Current Label` varchar(50), 
    `Material Type` varchar(255),
	`Vial Status` varchar(255),
	`Vial Warnings` varchar(255),
    `Consented_For_Research_Use` varchar(255),
FOREIGN KEY (`Material Type`) REFERENCES `Biospecimen_Type` (`Biospecimen_Type`) ON DELETE CASCADE ON UPDATE CASCADE);
#FOREIGN KEY (`CBC_Biospecimen_Aliquot_ID`) REFERENCES `Aliquot` (`Aliquot_ID`) ON DELETE CASCADE ON UPDATE CASCADE);

Create table if not Exists `seronetdb-Vaccine_Response`.`BSI_Child_Aliquots` (
	`Biorepository_ID` varchar(255),
	`Subaliquot_ID` varchar(255) primary key,
	`CGR_Aliquot_ID` varchar(255),
	`Vial Status` varchar(255),
	`Vial Warnings` varchar(255),
FOREIGN KEY (`Biorepository_ID`) REFERENCES `BSI_Parent_Aliquots` (`Biorepository_ID`) ON DELETE CASCADE ON UPDATE CASCADE);


Create table if not Exists `seronetdb-Vaccine_Response`.`BSI_Reference_Panel_Aliquots` (
	`Biorepository_ID` varchar(255),
	`Subaliquot_ID` varchar(255) primary key,
	`CGR_Aliquot_ID` varchar(255),
	`Vial Status` varchar(255),
	`Vial Warnings` varchar(255),
    `Material Type` varchar(255),
	`Volume`varchar(255),
	`Volume Unit`varchar(255),
FOREIGN KEY (`Biorepository_ID`) REFERENCES `BSI_Child_Aliquots` (`Subaliquot_ID`) ON DELETE CASCADE ON UPDATE CASCADE);


Create table if not Exists `seronetdb-Vaccine_Response`.`Visit_One_Offset_Correction` (
	`Research_Participant_ID` VARCHAR(255) NOT NULL primary Key,
	`Offset_Value` float
);

create table if not exists `seronetdb-Vaccine_Response`.`Normalized_Comorbidity_Dictionary`(
	`Comorbid_Name` varchar(255),
    `Orgional_Description_Or_ICD10_codes` varchar(255),
    `Normalized_Description` varchar(255),
    `Normalized_Description_AND_ICD10_codes` varchar(255)
);

drop table `seronetdb-Vaccine_Response`.`Normalized_Cancer_Dictionary`;
create table if not exists `seronetdb-Vaccine_Response`.`Normalized_Cancer_Dictionary`(
	`Cancer` varchar(255),
    `Harmonized Cancer Name` varchar(255),
    `SEER Category` varchar(255)
);

drop table if exists `seronetdb-Vaccine_Response`.`Normalized_Comorbidity_Names`;
create table if not exists `seronetdb-Vaccine_Response`.`Normalized_Comorbidity_Names_v2`(
  `Visit_Info_ID` VARCHAR(255) NOT NULL,
  `Diabetes_Description_Normalized` VARCHAR(255),
  `Hypertension_Description_Normalized` VARCHAR(255),
  `Obesity_Description_Normalized` VARCHAR(255),
  `Cardiovascular_Disease_Description_Normalized` VARCHAR(255),
  `Chronic_Lung_Disease_Description_Normalized` VARCHAR(255),
  `Chronic_Kidney_Disease_Description_Normalized` VARCHAR(255),
  `Chronic_Liver_Disease_Description_Normalized` VARCHAR(255),
  `Acute_Liver_Disease_Description_Normalized` VARCHAR(255),
  `Immunosuppressive_Condition_Description_Normalized` VARCHAR(255),
  `Autoimmune_Disorder_Description_Normalized` VARCHAR(255),
  `Chronic_Neurological_Condition_Description_Normalized` VARCHAR(255),
  `Chronic_Oxygen_Requirement_Description_Normalized` VARCHAR(255),
  `Inflammatory_Disease_Description_Normalized` VARCHAR(255),
  `Viral_Infection_Normalized` VARCHAR(255),
  `Bacterial_Infection_Normalized` VARCHAR(255),
  `Cancer_Description_Normalized` VARCHAR(255),
  PRIMARY KEY (`Visit_Info_ID`),
  CONSTRAINT `Normalized_Comorbidity_Names_v2_ibfk_1`
	FOREIGN KEY (`Visit_Info_ID`)
	REFERENCES `seronetdb-Vaccine_Response`.`Participant_Visit_Info` (`Visit_Info_ID`)
	ON DELETE CASCADE
	ON UPDATE CASCADE);

create table if not exists `seronetdb-Vaccine_Response`.`Normalized_Cancer_Names_v2`(
	`Visit_Info_ID` VARCHAR(255) NOT NULL,
    `Harmonized Cancer Name` varchar(255),
    `SEER Category` varchar(255)
);

drop table if exists `seronetdb-Vaccine_Response`.`Normalized_Treatment_Dict`;
create table if not exists `seronetdb-Vaccine_Response`.`Normalized_Treatment_Dict`(
	`Treatment` VARCHAR(255) NOT NULL,
    `Harmonized Treatment` varchar(255)
);
drop table if exists `seronetdb-Vaccine_Response`.`Normalized_Treatment_Names`;
create table if not exists `seronetdb-Vaccine_Response`.`Normalized_Treatment_Names`(
	`Visit_Info_ID` VARCHAR(255) NOT NULL,
    `Orgional Treatment Name` varchar(255),
    `Harmonized Treatment` varchar(255)
);
