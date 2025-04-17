select prim_test.Research_Participant_ID,
	case when prim_test.`Primary_Test: Spike Result` > 0 then 'Positive'
		  when prim_test.`Primary_Test: Spike Result` < 0 then 'Negative' else 'Test Not Run' end as 'Primary Test: Spike Result',
	case when  `Second_Test: Spike Result` > 0 then 'Positive'
		  when  `Second_Test: Spike Result` < 0 then 'Negative' else 'Test Not Run' end as 'Secondary Test: Spike Result',
	case when `Third_Test: Spike Result` > 0 then 'Positive'
		  when `Third_Test: Spike Result` < 0 then 'Negative' else 'Test Not Run' end as 'Third Test: Spike Result',
	case when `Second_Test: Nuc Result` > 0 then 'Positive'
		  when `Second_Test: Nuc Result` < 0 then 'Negative' else 'Test Not Run' end as 'Second Test: Nuclepcapsid Result',
	case when `Third_Test: Nuc Result` > 0 then 'Positive'
		  when `Third_Test: Nuc Result` < 0 then 'Negative' else 'Test Not Run' end as 'Third Test: Nuclepcapsid Result'

from 

(SELECT Research_Participant_ID,  
	sum(case when lower(Interpretation) like '%positive%' then 10 when lower(Interpretation) like '%negative%' then -1 else 0 end) as `Primary_Test: Spike Result`
FROM `seronetdb-Validated`.Confirmatory_Clinical_Test
group by Research_Participant_ID) as prim_test

left join (
SELECT  left(bp.CBC_Biospecimen_Aliquot_ID, 9) as 'Part_ID',
	sum(case when lower(Interpretation) like '%positive%' then 10 
		 when lower(Interpretation) like '%negative%' then -1 else 0 end) as `Second_Test: Spike Result`

FROM `seronetdb-Validated`.Serology_Confirmatory_Test as sc
	left join  `seronetdb-Validated`.BSI_Parent_Aliquots as bp
on sc.BSI_Parent_ID = bp.Biorepository_ID
where Assay_Target = 'Spike'
group by left(bp.CBC_Biospecimen_Aliquot_ID, 9)) as sec_test
on prim_test.Research_Participant_ID = sec_test.Part_ID

left join (
SELECT  left(bp.CBC_Biospecimen_Aliquot_ID, 9) as 'Part_ID',
	sum(case when lower(Interpretation) like '%positive%' then 10 
		 when lower(Interpretation) like '%negative%' then -1 else 0 end) as `Second_Test: Nuc Result`

FROM `seronetdb-Validated`.Serology_Confirmatory_Test as sc
	left join  `seronetdb-Validated`.BSI_Parent_Aliquots as bp
on sc.BSI_Parent_ID = bp.Biorepository_ID
where Assay_Target = 'Nucleocapsid'
group by left(bp.CBC_Biospecimen_Aliquot_ID, 9)) as sec_test_n
on prim_test.Research_Participant_ID = sec_test_n.Part_ID


left join (
SELECT  left(bp.CBC_Biospecimen_Aliquot_ID, 9) as 'Part_ID',
	sum(case when lower(Interpretation) like '%positive%' then 10 
		 when lower(Interpretation) like '%negative%' then -1 else 0 end) as `Third_Test: Spike Result`

FROM `seronetdb-Validated`.Secondary_Confirmatory_Test as sct
	left join  `seronetdb-Validated`.BSI_Parent_Aliquots as bp
on sct.BSI_Parent_ID = bp.Biorepository_ID
where lower(Assay_Target) like 'spike%'
group by left(bp.CBC_Biospecimen_Aliquot_ID, 9)) as third_test
on prim_test.Research_Participant_ID = third_test.Part_ID

left join(
	select left(bp.CBC_Biospecimen_Aliquot_ID, 9) as 'Part_ID',
	sum(case when lower(Interpretation) like '%positive%' then 10 
		 when lower(Interpretation) like '%negative%' then -1 else 0 end) as `Third_Test: Nuc Result`
	FROM `seronetdb-Validated`.Secondary_Confirmatory_Test as sct
		left join  `seronetdb-Validated`.BSI_Parent_Aliquots as bp
	on sct.BSI_Parent_ID = bp.Biorepository_ID
	where lower(Assay_Target) like 'Nucleocapsid (N) antigen'
	group by left(bp.CBC_Biospecimen_Aliquot_ID, 9)) as third_test_n
	on prim_test.Research_Participant_ID = third_test_n.Part_ID