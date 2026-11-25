-- Contextualization: link EwpProject to its IFS site (Q14, D-021).
-- Few values, so the link comes from a reviewed mapping table, not matching:
-- RAW kizc_context.project_site_map (projectCode, targetSpace, targetExternalId). Fill it (upload_data/), then run.
SELECT
  concat('project-', projectCode) AS externalId,
  node_reference(targetSpace, targetExternalId) AS ifsSite
FROM `kizc_context`.`project_site_map`
WHERE nullif(trim(targetExternalId), '') IS NOT NULL
