-- EwpArea: one node per L1 code (V, T, S, M, G).
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).

SELECT
  concat('area-', substr(CASE WHEN trim(`L1 - Sub-Work`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L1 - Sub-Work`) END, 1, 1)) AS externalId,
  substr(CASE WHEN trim(`L1 - Sub-Work`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L1 - Sub-Work`) END, 1, 1) AS areaCode,
  max(CASE WHEN trim(`L1 - Sub-Work`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L1 - Sub-Work`) END) AS name
FROM `kiz_scopes`.`list_of_scopes`
WHERE CASE WHEN trim(`L1 - Sub-Work`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L1 - Sub-Work`) END IS NOT NULL
GROUP BY substr(CASE WHEN trim(`L1 - Sub-Work`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L1 - Sub-Work`) END, 1, 1)
