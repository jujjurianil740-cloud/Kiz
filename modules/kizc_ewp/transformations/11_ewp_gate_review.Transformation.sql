-- EwpGateReview: Gates 1 to 4 and close-out (D-033), one per scope per gate with data.
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).
-- Text in plan-date columns equals Scope Categorisation and is nulled here; it lives on the scope.

SELECT * FROM (
  SELECT
    concat('gate-', `key`, '-1') AS externalId,
    '1' AS gate,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Gate 1') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    CASE WHEN trim(`Gate 1 Review Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 1 Review Plan Date`), 1, 10)) END AS scheduledEndTime,
    CASE WHEN trim(`Gate 1 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 1 Review P6 Forecast Date`), 1, 10)) END AS p6ForecastDate,
    CASE WHEN trim(`Gate 1 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 1 Review APE's  Forecast Date`), 1, 10)) END AS apeForecastDate,
    CASE WHEN trim(`Gate 1 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 1 Review Complete Date`), 1, 10)) END AS endTime,
    cast(NULL AS string) AS executionPlanStatus,
    cast(NULL AS string) AS planningStatus,
    cast(NULL AS string) AS costEstimationStatus,
    cast(NULL AS string) AS readinessStatus,
    cast(NULL AS string) AS closedOut
  FROM `kiz_scopes`.`list_of_scopes`
  WHERE (CASE WHEN trim(`Gate 1 Review Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 1 Review Plan Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 1 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 1 Review P6 Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 1 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 1 Review APE's  Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 1 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 1 Review Complete Date`), 1, 10)) END) IS NOT NULL
  UNION ALL
  SELECT
    concat('gate-', `key`, '-2') AS externalId,
    '2' AS gate,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Gate 2') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    CASE WHEN trim(`Gate 2 Review  P6 BL Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review  P6 BL Plan Date`), 1, 10)) END AS scheduledEndTime,
    CASE WHEN trim(`Gate 2 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review P6 Forecast Date`), 1, 10)) END AS p6ForecastDate,
    CASE WHEN trim(`Gate 2 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review APE's  Forecast Date`), 1, 10)) END AS apeForecastDate,
    CASE WHEN trim(`Gate 2 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review Complete Date`), 1, 10)) END AS endTime,
    CASE WHEN trim(`Gate 2 Execution Plan`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Execution Plan`) END AS executionPlanStatus,
    CASE WHEN trim(`Gate 2 Planning`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Planning`) END AS planningStatus,
    CASE WHEN trim(`Gate 2 Cost Estimation`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Cost Estimation`) END AS costEstimationStatus,
    CASE WHEN trim(`Gate 2 Readiness`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Readiness`) END AS readinessStatus,
    cast(NULL AS string) AS closedOut
  FROM `kiz_scopes`.`list_of_scopes`
  WHERE (CASE WHEN trim(`Gate 2 Review  P6 BL Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review  P6 BL Plan Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review P6 Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review APE's  Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review Complete Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Execution Plan`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Execution Plan`) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Planning`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Planning`) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Cost Estimation`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Cost Estimation`) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Readiness`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Readiness`) END) IS NOT NULL
  UNION ALL
  SELECT
    concat('gate-', `key`, '-3') AS externalId,
    '3' AS gate,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Gate 3') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    CASE WHEN trim(`Gate 3 Review P6 BL Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 3 Review P6 BL Plan Date`), 1, 10)) END AS scheduledEndTime,
    CASE WHEN trim(`Gate 3 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 3 Review P6 Forecast Date`), 1, 10)) END AS p6ForecastDate,
    CASE WHEN trim(`Gate 3 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 3 Review APE's  Forecast Date`), 1, 10)) END AS apeForecastDate,
    CASE WHEN trim(`Gate 3 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 3 Review Complete Date`), 1, 10)) END AS endTime,
    cast(NULL AS string) AS executionPlanStatus,
    cast(NULL AS string) AS planningStatus,
    cast(NULL AS string) AS costEstimationStatus,
    cast(NULL AS string) AS readinessStatus,
    cast(NULL AS string) AS closedOut
  FROM `kiz_scopes`.`list_of_scopes`
  WHERE (CASE WHEN trim(`Gate 3 Review P6 BL Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 3 Review P6 BL Plan Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 3 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 3 Review P6 Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 3 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 3 Review APE's  Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 3 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 3 Review Complete Date`), 1, 10)) END) IS NOT NULL
  UNION ALL
  SELECT
    concat('gate-', `key`, '-4') AS externalId,
    '4' AS gate,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Gate 4') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    CASE WHEN trim(`Gate 4 Review P6 BL Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 4 Review P6 BL Plan Date`), 1, 10)) END AS scheduledEndTime,
    CASE WHEN trim(`Gate 4 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 4 Review P6 Forecast Date`), 1, 10)) END AS p6ForecastDate,
    CASE WHEN trim(`Gate 4 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 4 Review APE's  Forecast Date`), 1, 10)) END AS apeForecastDate,
    CASE WHEN trim(`Gate 4 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 4 Review Complete Date`), 1, 10)) END AS endTime,
    cast(NULL AS string) AS executionPlanStatus,
    cast(NULL AS string) AS planningStatus,
    cast(NULL AS string) AS costEstimationStatus,
    cast(NULL AS string) AS readinessStatus,
    cast(NULL AS string) AS closedOut
  FROM `kiz_scopes`.`list_of_scopes`
  WHERE (CASE WHEN trim(`Gate 4 Review P6 BL Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 4 Review P6 BL Plan Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 4 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 4 Review P6 Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 4 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 4 Review APE's  Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 4 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 4 Review Complete Date`), 1, 10)) END) IS NOT NULL
  UNION ALL
  SELECT
    concat('gate-', `key`, '-CLOSEOUT') AS externalId,
    'CLOSEOUT' AS gate,
    concat(CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END, ' Gate CLOSEOUT') AS name,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS belongsToScope,
    CASE WHEN trim(`Closed Out Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Closed Out Plan Date`), 1, 10)) END AS scheduledEndTime,
    CASE WHEN trim(`Closed Out Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Closed Out Forecast Date`), 1, 10)) END AS p6ForecastDate,
    cast(NULL AS date) AS apeForecastDate,
    CASE WHEN trim(`Closed Out Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Closed Out Complete Date`), 1, 10)) END AS endTime,
    cast(NULL AS string) AS executionPlanStatus,
    cast(NULL AS string) AS planningStatus,
    cast(NULL AS string) AS costEstimationStatus,
    cast(NULL AS string) AS readinessStatus,
    CASE WHEN trim(`Closed Out`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Closed Out`) END AS closedOut
  FROM `kiz_scopes`.`list_of_scopes`
  WHERE (CASE WHEN trim(`Closed Out Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Closed Out Plan Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Closed Out Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Closed Out Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Closed Out Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Closed Out Complete Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Closed Out`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Closed Out`) END) IS NOT NULL
) gates
