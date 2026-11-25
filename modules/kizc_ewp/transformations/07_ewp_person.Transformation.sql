-- EwpPerson: one node per person after merges (D-028, D-030, D-032, D-064).
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).
-- Every raw spelling is kept in CDM aliases. System accounts (cell-link, web-form) are not persons.

WITH raw_people AS (
  SELECT CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END AS raw_value FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END AS raw_value FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END AS raw_value FROM `kiz_scopes`.`list_of_scopes`
), keyed AS (
  SELECT raw_value, CASE
    WHEN raw_value IS NULL OR raw_value IN ('cell-link@smartsheet.com', 'web-form@smartsheet.com') THEN NULL
    WHEN raw_value = 'brian.carriou@sbmoffshore.com' THEN 'brian.carriou'
    WHEN raw_value = 'brian.carriou@ext.sbmoffshore.com' THEN 'brian.carriou'
    WHEN raw_value = 'BIRAJ MOHAPATRA' THEN 'biraj.mohapatra'
    WHEN raw_value = 'biraj.mohapatra@sbmoffshore.com' THEN 'biraj.mohapatra'
    WHEN raw_value = 'SANDRO CESAR' THEN 'sandro.cesar'
    WHEN raw_value = 'Sandro Cesar' THEN 'sandro.cesar'
    WHEN raw_value = 'mohdfuad.binchenordi@sbmoffshore.com' THEN 'mohammad.fuad'
    WHEN raw_value = 'Mohammad Fuad' THEN 'mohammad.fuad'
    WHEN raw_value = 'ramzy.benrehouma@sbmoffshore.com' THEN 'ramzy.benrehouma'
    WHEN raw_value = 'ratko.simic@ext.sbmoffshore.com' THEN 'ratko.simic'
    WHEN raw_value = 'eliel.maroja@ext.sbmoffshore.com' THEN 'eliel.maroja'
    WHEN raw_value = 'manu.surendrannair@sbmoffshore.com' THEN 'manu.surendrannair'
    WHEN raw_value = 'richie.ooi@exxonmobil.com' THEN 'richie.ooi'
    WHEN raw_value = 'kishan.mohan@sbmoffshore.com' THEN 'kishan.mohan'
    WHEN raw_value = 'ahmadhumaizi.yahya@sbmoffshore.com' THEN 'ahmadhumaizi.yahya'
    ELSE lower(raw_value)
  END AS person_key
  FROM raw_people
)
SELECT
  concat('person-', person_key) AS externalId,
  person_key AS personId,
  initcap(replace(person_key, '.', ' ')) AS name,
  max(CASE WHEN raw_value LIKE '%@%' THEN raw_value END) AS email,
  collect_set(raw_value) AS aliases
FROM keyed
WHERE person_key IS NOT NULL
GROUP BY person_key
