-- Contextualization: link each EwpDocument to its NEO document by document number (D-023).
-- Exact match on the normalised number (trimmed, upper case). Placeholders ("xxx") are marked, not matched (Q10).
-- The {{ neo_* }} variables are set in config.dev.yaml.
WITH ewp AS (
  SELECT externalId, documentNumber FROM cdf_data_models('sp_kizc_ewp_model', 'KizcEwp', 'v1', 'EwpDocument')
), neo AS (
  SELECT space AS neo_space, externalId AS neo_xid, upper(trim({{ neo_doc_number_property }})) AS neo_number
  FROM cdf_data_models('{{ neo_model_space }}', '{{ neo_model }}', '{{ neo_model_version }}', '{{ neo_document_view }}')
)
SELECT
  ewp.externalId,
  CASE WHEN neo.neo_xid IS NOT NULL THEN node_reference(neo.neo_space, neo.neo_xid) END AS neoDocument,
  CASE WHEN lower(ewp.documentNumber) LIKE '%xxx%' THEN 'placeholder'
       WHEN neo.neo_xid IS NOT NULL THEN 'matched' ELSE 'not found in NEO' END AS neoMatchStatus
FROM ewp
LEFT JOIN neo ON neo.neo_number = upper(trim(ewp.documentNumber))
