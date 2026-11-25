-- EwpScopeSplitBaseSubsystem: SS, TK, ZS, ZC, ZP, GE (D-024).
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).

SELECT
  concat('split-', substr(CASE WHEN trim(`Scope Split Base`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Split Base`) END, 1, 2)) AS externalId,
  substr(CASE WHEN trim(`Scope Split Base`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Split Base`) END, 1, 2) AS code,
  max(CASE WHEN trim(`Scope Split Base`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Split Base`) END) AS name
FROM `kiz_scopes`.`list_of_scopes`
WHERE CASE WHEN trim(`Scope Split Base`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Split Base`) END IS NOT NULL
GROUP BY substr(CASE WHEN trim(`Scope Split Base`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Split Base`) END, 1, 2)
