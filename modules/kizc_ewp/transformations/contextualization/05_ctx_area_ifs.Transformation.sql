-- Contextualization: link EwpArea to its IFS location (weak candidate, D-052).
-- Few values, so the link comes from a reviewed mapping table, not matching:
-- RAW kizc_context.area_location_map (areaCode, targetSpace, targetExternalId). Fill it (upload_data/), then run.
SELECT
  concat('area-', areaCode) AS externalId,
  node_reference(targetSpace, targetExternalId) AS ifsLocation
FROM `kizc_context`.`area_location_map`
WHERE nullif(trim(targetExternalId), '') IS NOT NULL
