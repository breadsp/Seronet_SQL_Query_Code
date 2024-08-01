SELECT 
   case when Primary_Cohort in ('Chronic Conditions', 'Convalescent', 'Inflammatory') then 'Healthy Control'
		when Primary_Cohort in ('IBD') then 'Autoimmune'
        else Primary_Cohort end as Primary_Cohort, Vaccination_Status,	Duration_Between_Vaccine_and_Visit
 FROM `seronetdb-Vaccine_Response`.Normalized_Visit_Vaccination;