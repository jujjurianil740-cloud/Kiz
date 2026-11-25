-- EwpInspectionAssessment: 815 scopes x 7 disciplines = 5,705 (D-027).
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).
-- Status values are kept raw (D-036).

SELECT * FROM (
  SELECT
    concat('insp-', `key`, '-piping') AS externalId,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Piping') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    node_reference('sp_kizc_ewp_instances', 'disc-piping') AS inspectsDiscipline,
    CASE WHEN trim(`Inspection Scope - Piping`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Scope - Piping`) END AS isInScope,
    CASE WHEN trim(`Inspection Status - Piping`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Status - Piping`) END AS inspectionStatus,
    CASE WHEN trim(`Inspection Report Status - Piping`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Report Status - Piping`) END AS reportStatus
  FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT
    concat('insp-', `key`, '-instrument') AS externalId,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Instrument') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    node_reference('sp_kizc_ewp_instances', 'disc-instrument') AS inspectsDiscipline,
    CASE WHEN trim(`Inspection Scope - Instrument`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Scope - Instrument`) END AS isInScope,
    CASE WHEN trim(`Inspection Status - Instrument`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Status - Instrument`) END AS inspectionStatus,
    CASE WHEN trim(`Inspection Report Status - Instrument`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Report Status - Instrument`) END AS reportStatus
  FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT
    concat('insp-', `key`, '-mechanical') AS externalId,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Mechanical') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    node_reference('sp_kizc_ewp_instances', 'disc-mechanical') AS inspectsDiscipline,
    CASE WHEN trim(`Inspection Scope - Mechanical`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Scope - Mechanical`) END AS isInScope,
    CASE WHEN trim(`Inspection Status - Mechanical`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Status - Mechanical`) END AS inspectionStatus,
    CASE WHEN trim(`Inspection Report Status - Mechanical`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Report Status - Mechanical`) END AS reportStatus
  FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT
    concat('insp-', `key`, '-electrical') AS externalId,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Electrical') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    node_reference('sp_kizc_ewp_instances', 'disc-electrical') AS inspectsDiscipline,
    CASE WHEN trim(`Inspection Scope - Electrical`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Scope - Electrical`) END AS isInScope,
    CASE WHEN trim(`Inspection Status - Electrical`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Status - Electrical`) END AS inspectionStatus,
    CASE WHEN trim(`Inspection Report Status - Electrical`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Report Status - Electrical`) END AS reportStatus
  FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT
    concat('insp-', `key`, '-structuraltopsides') AS externalId,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Structural Topsides') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    node_reference('sp_kizc_ewp_instances', 'disc-structuraltopsides') AS inspectsDiscipline,
    CASE WHEN trim(`Inspection Scope - Str. Topsides`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Scope - Str. Topsides`) END AS isInScope,
    CASE WHEN trim(`Inspection Status - Str. Topsides`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Status - Str. Topsides`) END AS inspectionStatus,
    CASE WHEN trim(`Inspection Report Status - Str. Topsides`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Report Status - Str. Topsides`) END AS reportStatus
  FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT
    concat('insp-', `key`, '-structuralhull') AS externalId,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Structural Hull') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    node_reference('sp_kizc_ewp_instances', 'disc-structuralhull') AS inspectsDiscipline,
    CASE WHEN trim(`Inspection Scope - Str. Hull`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Scope - Str. Hull`) END AS isInScope,
    CASE WHEN trim(`Inspection Status - Str. Hull`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Status - Str. Hull`) END AS inspectionStatus,
    CASE WHEN trim(`Inspection Report Status - Str. Hull`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Report Status - Str. Hull`) END AS reportStatus
  FROM `kiz_scopes`.`list_of_scopes`
  UNION ALL
  SELECT
    concat('insp-', `key`, '-coating') AS externalId,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Coating') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    node_reference('sp_kizc_ewp_instances', 'disc-coating') AS inspectsDiscipline,
    CASE WHEN trim(`Inspection Scope - Coating`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Scope - Coating`) END AS isInScope,
    CASE WHEN trim(`Inspection Status - Coating`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Status - Coating`) END AS inspectionStatus,
    CASE WHEN trim(`Inspection Report Status - Coating`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Inspection Report Status - Coating`) END AS reportStatus
  FROM `kiz_scopes`.`list_of_scopes`
) assessments
