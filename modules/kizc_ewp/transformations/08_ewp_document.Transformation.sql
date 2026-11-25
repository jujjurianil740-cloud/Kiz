-- EwpDocument: one node per EWP document number (D-026), plus the IWP document.
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).
-- Placeholder numbers containing "xxx" load as documents, as in the uploaded model.

SELECT DISTINCT
  concat('doc-', doc) AS externalId,
  doc AS documentNumber,
  doc AS name
FROM (
  SELECT CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END AS doc FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT CASE WHEN trim(`IWP Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`IWP Reference`) END AS doc FROM `kiz_scopes`.`list_of_scopes`
) docs
WHERE doc IS NOT NULL
