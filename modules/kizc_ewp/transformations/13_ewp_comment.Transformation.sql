-- EwpComment: Notes, Latest comment, Gate 2 Readiness Comment (D-014, D-031).
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).
-- Gate 2 comments attach to the Gate 2 review; if a scope has no Gate 2 data they attach to the scope.

SELECT * FROM (
  SELECT concat('comment-', `key`, '-notes') AS externalId, 'notes' AS kind, CASE WHEN trim(`Notes`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Notes`) END AS text,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) AS commentsOn
  FROM `kiz_scopes`.`list_of_scopes` WHERE CASE WHEN trim(`Notes`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Notes`) END IS NOT NULL
  UNION ALL
  SELECT concat('comment-', `key`, '-latestComment'), 'latestComment', CASE WHEN trim(`Latest comment`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Latest comment`) END,
    node_reference('sp_kizc_ewp_instances', concat('scope-', `key`))
  FROM `kiz_scopes`.`list_of_scopes` WHERE CASE WHEN trim(`Latest comment`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Latest comment`) END IS NOT NULL
  UNION ALL
  SELECT concat('comment-', `key`, '-gate2Readiness'), 'gate2Readiness', CASE WHEN trim(`Gate 2 Readiness Comment`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Readiness Comment`) END,
    CASE WHEN (CASE WHEN trim(`Gate 2 Review  P6 BL Plan Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review  P6 BL Plan Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Review P6 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review P6 Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Review APE's  Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review APE's  Forecast Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Review Complete Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`Gate 2 Review Complete Date`), 1, 10)) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Execution Plan`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Execution Plan`) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Planning`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Planning`) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Cost Estimation`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Cost Estimation`) END) IS NOT NULL OR (CASE WHEN trim(`Gate 2 Readiness`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Readiness`) END) IS NOT NULL THEN node_reference('sp_kizc_ewp_instances', concat('gate-', concat(`key`, '-2'))) ELSE node_reference('sp_kizc_ewp_instances', concat('scope-', `key`)) END
  FROM `kiz_scopes`.`list_of_scopes` WHERE CASE WHEN trim(`Gate 2 Readiness Comment`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Gate 2 Readiness Comment`) END IS NOT NULL
) comments
