-- EwpSystem: one node per System code.
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).
-- Some rows leave System Description blank; max() keeps the one non-empty description per code (checked).

SELECT
  concat('system-', CASE WHEN trim(`System`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System`) END) AS externalId,
  CASE WHEN trim(`System`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System`) END AS systemCode,
  max(CASE WHEN trim(`System Description`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System Description`) END) AS name
FROM `kiz_scopes`.`list_of_scopes`
WHERE CASE WHEN trim(`System`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System`) END IS NOT NULL
GROUP BY CASE WHEN trim(`System`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System`) END
