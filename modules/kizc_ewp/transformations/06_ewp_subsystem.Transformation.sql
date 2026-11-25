-- EwpSubsystem: key is the full L2 text, code plus title (D-063). 415 nodes.
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).

SELECT
  concat('sub-', coalesce(CASE WHEN trim(`L2 - Scopes`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2 - Scopes`) END, CASE WHEN trim(`L2-Dropdown`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2-Dropdown`) END)) AS externalId,
  coalesce(CASE WHEN trim(`L2 - Scopes`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2 - Scopes`) END, CASE WHEN trim(`L2-Dropdown`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2-Dropdown`) END) AS subsystemKey,
  coalesce(CASE WHEN trim(`L2 - Scopes`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2 - Scopes`) END, CASE WHEN trim(`L2-Dropdown`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2-Dropdown`) END) AS name,
  max(CASE WHEN trim(`Subsystem Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Subsystem Code`) END) AS subsystemCode,
  node_reference('sp_kizc_ewp_instances', concat('system-', max(CASE WHEN trim(`System`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System`) END))) AS belongsToSystem
FROM `kiz_scopes`.`list_of_scopes`
WHERE coalesce(CASE WHEN trim(`L2 - Scopes`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2 - Scopes`) END, CASE WHEN trim(`L2-Dropdown`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2-Dropdown`) END) IS NOT NULL
GROUP BY coalesce(CASE WHEN trim(`L2 - Scopes`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2 - Scopes`) END, CASE WHEN trim(`L2-Dropdown`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2-Dropdown`) END)
