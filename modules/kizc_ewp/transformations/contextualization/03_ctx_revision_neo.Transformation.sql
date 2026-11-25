-- Contextualization: link each EwpDocumentRevision (P1, C1) to the NEO revision of its linked NEO document.
-- Runs after document_neo. Values stay Smartsheet-owned (D-046); the link records which NEO revision they describe.
WITH rev AS (
  SELECT r.externalId, r.revision, r.belongsToDocument.externalId AS doc_xid
  FROM cdf_data_models('sp_kizc_ewp_model', 'KizcEwp', 'v1', 'EwpDocumentRevision') r
), doc AS (
  SELECT externalId, neoDocument.externalId AS neo_doc_xid
  FROM cdf_data_models('sp_kizc_ewp_model', 'KizcEwp', 'v1', 'EwpDocument') WHERE neoDocument IS NOT NULL
), neo_rev AS (
  SELECT space AS neo_space, externalId AS neo_xid,
         {{ neo_revision_document_property }}.externalId AS neo_doc_xid,
         upper(trim({{ neo_revision_code_property }})) AS neo_code
  FROM cdf_data_models('{{ neo_model_space }}', '{{ neo_model }}', '{{ neo_model_version }}', '{{ neo_revision_view }}')
)
SELECT
  rev.externalId,
  CASE WHEN neo_rev.neo_xid IS NOT NULL THEN node_reference(neo_rev.neo_space, neo_rev.neo_xid) END AS neoRevision,
  CASE WHEN doc.neo_doc_xid IS NULL THEN 'document not linked to NEO'
       WHEN neo_rev.neo_xid IS NOT NULL THEN 'matched' ELSE 'revision not found in NEO' END AS neoMatchStatus
FROM rev
LEFT JOIN doc ON doc.externalId = rev.doc_xid
LEFT JOIN neo_rev ON neo_rev.neo_doc_xid = doc.neo_doc_xid AND neo_rev.neo_code = upper(rev.revision)
WHERE rev.revision IN ('P1', 'C1')
