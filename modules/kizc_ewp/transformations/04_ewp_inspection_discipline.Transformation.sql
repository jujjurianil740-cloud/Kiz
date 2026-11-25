-- EwpInspectionDiscipline: the 7 inspection disciplines (D-027).
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).

SELECT 'disc-piping' AS externalId, 'piping' AS code, 'Piping' AS name
UNION ALL
SELECT 'disc-instrument' AS externalId, 'instrument' AS code, 'Instrument' AS name
UNION ALL
SELECT 'disc-mechanical' AS externalId, 'mechanical' AS code, 'Mechanical' AS name
UNION ALL
SELECT 'disc-electrical' AS externalId, 'electrical' AS code, 'Electrical' AS name
UNION ALL
SELECT 'disc-structuraltopsides' AS externalId, 'structuraltopsides' AS code, 'Structural Topsides' AS name
UNION ALL
SELECT 'disc-structuralhull' AS externalId, 'structuralhull' AS code, 'Structural Hull' AS name
UNION ALL
SELECT 'disc-coating' AS externalId, 'coating' AS code, 'Coating' AS name
