-- EwpDocumentRevision: P1 and C1 per EWP document, IWP revision on the IWP document.
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).
-- Values are identical across scopes that share a document (checked), so max() picks that value.
-- A revision is created only when at least one of its values is filled.

SELECT * FROM (
  SELECT
    concat('rev-', CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, '-P1') AS externalId,
    'P1' AS revision,
    concat(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, ' P1') AS name,
    node_reference('sp_kizc_ewp_instances', concat('doc-', CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END)) AS belongsToDocument,
    max(CASE WHEN trim(`Initiate EWP P1 (Draft)`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Initiate EWP P1 (Draft)`) END) AS isInitiated,
    max(CASE WHEN trim(`EWP P1 (Draft) issued in NEO`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP P1 (Draft) issued in NEO`) END) AS issuedP1,
    max(CASE WHEN trim(`EWP P1 Status`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP P1 Status`) END) AS status,
    cast(NULL AS date) AS scheduledEndTime,
    cast(NULL AS date) AS uploadDate,
    cast(NULL AS date) AS actualDate,
    cast(NULL AS string) AS installationIssued
  FROM `kiz_scopes`.`list_of_scopes`
  WHERE CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END IS NOT NULL
  GROUP BY CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END
  HAVING max(CASE WHEN trim(`Initiate EWP P1 (Draft)`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Initiate EWP P1 (Draft)`) END) IS NOT NULL OR max(CASE WHEN trim(`EWP P1 (Draft) issued in NEO`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP P1 (Draft) issued in NEO`) END) IS NOT NULL
      OR max(CASE WHEN trim(`EWP P1 Status`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP P1 Status`) END) IS NOT NULL
  UNION ALL
  SELECT
    concat('rev-', CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, '-C1'), 'C1', concat(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, ' C1'), node_reference('sp_kizc_ewp_instances', concat('doc-', CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END)),
    cast(NULL AS string), cast(NULL AS string), cast(NULL AS string),
    max(CASE WHEN trim(`EWP Rev C1 Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`EWP Rev C1 Plan Date`), 1, 10)) END),
    max(CASE WHEN trim(`EWP Rev C1 Upload Date in NEO`) LIKE '____-__-__%' THEN to_date(substr(trim(`EWP Rev C1 Upload Date in NEO`), 1, 10)) END),
    max(CASE WHEN trim(`EWP Rev C1 Actual Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`EWP Rev C1 Actual Date`), 1, 10)) END),
    cast(NULL AS string)
  FROM `kiz_scopes`.`list_of_scopes`
  WHERE CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END IS NOT NULL
  GROUP BY CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END
  HAVING max(CASE WHEN trim(`EWP Rev C1 Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`EWP Rev C1 Plan Date`), 1, 10)) END) IS NOT NULL OR max(CASE WHEN trim(`EWP Rev C1 Upload Date in NEO`) LIKE '____-__-__%' THEN to_date(substr(trim(`EWP Rev C1 Upload Date in NEO`), 1, 10)) END) IS NOT NULL
      OR max(CASE WHEN trim(`EWP Rev C1 Actual Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`EWP Rev C1 Actual Date`), 1, 10)) END) IS NOT NULL
  UNION ALL
  SELECT
    concat('rev-', CASE WHEN trim(`IWP Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`IWP Reference`) END, '-IWP'), 'IWP', concat(CASE WHEN trim(`IWP Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`IWP Reference`) END, ' IWP'), node_reference('sp_kizc_ewp_instances', concat('doc-', CASE WHEN trim(`IWP Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`IWP Reference`) END)),
    cast(NULL AS string), cast(NULL AS string), cast(NULL AS string),
    cast(NULL AS date), cast(NULL AS date), cast(NULL AS date),
    max(CASE WHEN trim(`IWP Installation issued`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`IWP Installation issued`) END)
  FROM `kiz_scopes`.`list_of_scopes`
  WHERE CASE WHEN trim(`IWP Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`IWP Reference`) END IS NOT NULL
  GROUP BY CASE WHEN trim(`IWP Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`IWP Reference`) END
) revisions
