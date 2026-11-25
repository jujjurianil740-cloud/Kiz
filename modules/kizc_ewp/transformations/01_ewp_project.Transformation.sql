-- EwpProject: one node per L0 project (D-022).
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).

SELECT DISTINCT
  concat('project-', CASE WHEN trim(`L0 - Project`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L0 - Project`) END) AS externalId,
  CASE WHEN trim(`L0 - Project`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L0 - Project`) END AS code,
  CASE WHEN trim(`L0 - Project`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L0 - Project`) END AS name
FROM `kiz_scopes`.`list_of_scopes`
WHERE CASE WHEN trim(`L0 - Project`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L0 - Project`) END IS NOT NULL
