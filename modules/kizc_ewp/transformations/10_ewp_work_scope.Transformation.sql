-- EwpWorkScope: one node per Smartsheet row (815).
-- Source: RAW kiz_scopes.list_of_scopes (19 Nov 2026 export, all 99 columns).
-- Identity: interim Excel row number (RAW key) until the Smartsheet row ID is exported (D-044).
-- Scope Categorisation is split into scopeCategory and scopeStatus (D-041).
-- Raw Created By / Modified By go to CDM sourceCreatedUser / sourceUpdatedUser, including system accounts (D-028).

SELECT
  concat('scope-', `key`) AS externalId,
  `key` AS scopeRowId,
  CASE WHEN trim(`Project Name`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Name`) END AS name,
  CASE WHEN trim(`Form Entry`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Form Entry`) END AS formEntry,
  CASE WHEN trim(`Form Entry Validated`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Form Entry Validated`) END AS formEntryValidated,
  CASE WHEN trim(`P6 ID`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`P6 ID`) END AS p6Id,
  CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END AS projectCode,
  CASE WHEN trim(`Project Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Number`) END AS scopeSequenceNo,
  CASE WHEN trim(`Priority - Jun'26 update + APE final input`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Priority - Jun'26 update + APE final input`) END AS executionPriority,
  CASE WHEN trim(`Shutdown Requirement`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Shutdown Requirement`) END AS shutdownRequirement,
  CASE WHEN trim(`Base Scope`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Base Scope`) END AS isBaseScope,
  CASE WHEN CASE WHEN trim(`Scope Categorisation`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Categorisation`) END IN ('Base', 'Tank Opportunity', 'Others') THEN CASE WHEN trim(`Scope Categorisation`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Categorisation`) END END AS scopeCategory,
  CASE WHEN CASE WHEN trim(`Scope Categorisation`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Categorisation`) END IN ('Added', 'No Scope pre-G1', 'No Scope post-G1') THEN CASE WHEN trim(`Scope Categorisation`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Categorisation`) END END AS scopeStatus,
  CASE WHEN trim(`In Execution`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`In Execution`) END AS inExecution,
  CASE WHEN trim(`EWP Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Reference`) END AS ewpReference,
  CASE WHEN trim(`Overall Inspection Status`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Overall Inspection Status`) END AS overallInspectionStatus,
  CASE WHEN trim(`Overall Inspection Report Status`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Overall Inspection Report Status`) END AS overallInspectionReportStatus,
  CASE WHEN upper(CASE WHEN trim(`EWP Hold Points`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Hold Points`) END) IN ('YES', 'NO') THEN NULL ELSE cast(CASE WHEN trim(`EWP Hold Points`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Hold Points`) END AS int) END AS ewpHoldPointCount,
  CASE WHEN trim(`EWP Rev C1 Forecast Date`) LIKE '____-__-__%' THEN to_date(substr(trim(`EWP Rev C1 Forecast Date`), 1, 10)) END AS c1ForecastDate,
  CASE WHEN trim(`MOC Required`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`MOC Required`) END AS isMocRequired,
  CASE WHEN trim(`Scope Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Code`) END AS legacyScopeCode,
  CASE WHEN trim(`OIM Categorisation`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`OIM Categorisation`) END AS oimCategorisation,
  CASE WHEN trim(`Integrated Asset Priority`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Integrated Asset Priority`) END AS integratedAssetPriority,
  CASE WHEN trim(`Latest Status`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Latest Status`) END AS latestStatus,
  CASE WHEN trim(`L2-Dropdown`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2-Dropdown`) END AS l2Dropdown,
  CASE WHEN trim(`MOC Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`MOC Reference`) END AS mocReference,
  CASE WHEN trim(`Helper Columns ->`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Helper Columns ->`) END AS helperColumnsMarker,
  CASE WHEN trim(`Project Code - Name`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code - Name`) END AS projectCodeName,
  CASE WHEN trim(`Compare String`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Compare String`) END AS compareString,
  CASE WHEN trim(`Duplicate Check`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Duplicate Check`) END AS duplicateCheck,
  CASE WHEN trim(`In EWP Tracker`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`In EWP Tracker`) END AS inEwpTracker,
  CASE WHEN trim(`In Projects Passed Gate 1`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`In Projects Passed Gate 1`) END AS inProjectsPassedGate1,
  CASE WHEN trim(`In Subsystem Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`In Subsystem Reference`) END AS inSubsystemReference,
  to_timestamp(CASE WHEN trim(`Created`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created`) END) AS sourceCreatedTime,
  to_timestamp(CASE WHEN trim(`Modified`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified`) END) AS sourceUpdatedTime,
  CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END AS sourceCreatedUser,
  CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END AS sourceUpdatedUser,
  'Smartsheet Kiz C - List of Scopes' AS sourceContext,
  node_reference('sp_kizc_ewp_instances', concat('project-', CASE WHEN trim(`L0 - Project`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L0 - Project`) END)) AS belongsToProject,
  node_reference('sp_kizc_ewp_instances', concat('area-', substr(CASE WHEN trim(`L1 - Sub-Work`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L1 - Sub-Work`) END, 1, 1))) AS locatedInArea,
  node_reference('sp_kizc_ewp_instances', concat('split-', substr(CASE WHEN trim(`Scope Split Base`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Scope Split Base`) END, 1, 2))) AS hasSplitBase,
  CASE WHEN CASE WHEN trim(`Subsystem Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Subsystem Code`) END IS NOT NULL THEN node_reference('sp_kizc_ewp_instances', concat('sub-', coalesce(CASE WHEN trim(`L2 - Scopes`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2 - Scopes`) END, CASE WHEN trim(`L2-Dropdown`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L2-Dropdown`) END))) END AS belongsToSubsystem,
  node_reference('sp_kizc_ewp_instances', concat('doc-', CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END)) AS documentedBy,
  node_reference('sp_kizc_ewp_instances', concat('doc-', CASE WHEN trim(`IWP Reference`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`IWP Reference`) END)) AS iwpDocumentedBy,
  node_reference('sp_kizc_ewp_instances', concat('person-', CASE
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END IS NULL OR CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END IN ('cell-link@smartsheet.com', 'web-form@smartsheet.com') THEN NULL
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'brian.carriou@sbmoffshore.com' THEN 'brian.carriou'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'brian.carriou@ext.sbmoffshore.com' THEN 'brian.carriou'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'BIRAJ MOHAPATRA' THEN 'biraj.mohapatra'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'biraj.mohapatra@sbmoffshore.com' THEN 'biraj.mohapatra'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'SANDRO CESAR' THEN 'sandro.cesar'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'Sandro Cesar' THEN 'sandro.cesar'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'mohdfuad.binchenordi@sbmoffshore.com' THEN 'mohammad.fuad'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'Mohammad Fuad' THEN 'mohammad.fuad'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'ramzy.benrehouma@sbmoffshore.com' THEN 'ramzy.benrehouma'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'ratko.simic@ext.sbmoffshore.com' THEN 'ratko.simic'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'eliel.maroja@ext.sbmoffshore.com' THEN 'eliel.maroja'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'manu.surendrannair@sbmoffshore.com' THEN 'manu.surendrannair'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'richie.ooi@exxonmobil.com' THEN 'richie.ooi'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'kishan.mohan@sbmoffshore.com' THEN 'kishan.mohan'
    WHEN CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END = 'ahmadhumaizi.yahya@sbmoffshore.com' THEN 'ahmadhumaizi.yahya'
    ELSE lower(CASE WHEN trim(`Responsible PE`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Responsible PE`) END)
  END)) AS responsibleFor,
  node_reference('sp_kizc_ewp_instances', concat('person-', CASE
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END IS NULL OR CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END IN ('cell-link@smartsheet.com', 'web-form@smartsheet.com') THEN NULL
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'brian.carriou@sbmoffshore.com' THEN 'brian.carriou'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'brian.carriou@ext.sbmoffshore.com' THEN 'brian.carriou'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'BIRAJ MOHAPATRA' THEN 'biraj.mohapatra'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'biraj.mohapatra@sbmoffshore.com' THEN 'biraj.mohapatra'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'SANDRO CESAR' THEN 'sandro.cesar'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'Sandro Cesar' THEN 'sandro.cesar'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'mohdfuad.binchenordi@sbmoffshore.com' THEN 'mohammad.fuad'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'Mohammad Fuad' THEN 'mohammad.fuad'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'ramzy.benrehouma@sbmoffshore.com' THEN 'ramzy.benrehouma'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'ratko.simic@ext.sbmoffshore.com' THEN 'ratko.simic'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'eliel.maroja@ext.sbmoffshore.com' THEN 'eliel.maroja'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'manu.surendrannair@sbmoffshore.com' THEN 'manu.surendrannair'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'richie.ooi@exxonmobil.com' THEN 'richie.ooi'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'kishan.mohan@sbmoffshore.com' THEN 'kishan.mohan'
    WHEN CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END = 'ahmadhumaizi.yahya@sbmoffshore.com' THEN 'ahmadhumaizi.yahya'
    ELSE lower(CASE WHEN trim(`Created By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Created By`) END)
  END)) AS createdBy,
  node_reference('sp_kizc_ewp_instances', concat('person-', CASE
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END IS NULL OR CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END IN ('cell-link@smartsheet.com', 'web-form@smartsheet.com') THEN NULL
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'brian.carriou@sbmoffshore.com' THEN 'brian.carriou'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'brian.carriou@ext.sbmoffshore.com' THEN 'brian.carriou'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'BIRAJ MOHAPATRA' THEN 'biraj.mohapatra'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'biraj.mohapatra@sbmoffshore.com' THEN 'biraj.mohapatra'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'SANDRO CESAR' THEN 'sandro.cesar'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'Sandro Cesar' THEN 'sandro.cesar'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'mohdfuad.binchenordi@sbmoffshore.com' THEN 'mohammad.fuad'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'Mohammad Fuad' THEN 'mohammad.fuad'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'ramzy.benrehouma@sbmoffshore.com' THEN 'ramzy.benrehouma'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'ratko.simic@ext.sbmoffshore.com' THEN 'ratko.simic'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'eliel.maroja@ext.sbmoffshore.com' THEN 'eliel.maroja'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'manu.surendrannair@sbmoffshore.com' THEN 'manu.surendrannair'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'richie.ooi@exxonmobil.com' THEN 'richie.ooi'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'kishan.mohan@sbmoffshore.com' THEN 'kishan.mohan'
    WHEN CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END = 'ahmadhumaizi.yahya@sbmoffshore.com' THEN 'ahmadhumaizi.yahya'
    ELSE lower(CASE WHEN trim(`Modified By`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Modified By`) END)
  END)) AS modifiedBy
FROM `kiz_scopes`.`list_of_scopes`
