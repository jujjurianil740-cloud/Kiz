"""Generate a Cognite Toolkit organization for the Kiz-C EWP load, in one of two profiles.

  cdm     EWP model on the Cognite Core Data Model; contextualization targets CogniteAsset and NEO / IFS views.
  cfihos  EWP model as a domain extension next to Cognite's CFIHOS oil and gas package
          (cfihos_oil_and_gas_extension); contextualization targets its Tag and Files views.

Usage: python3 gen2.py <out_dir> <cdm|cfihos>
"""
import os, sys, textwrap, yaml

OUT, PROFILE = sys.argv[1], sys.argv[2]
assert PROFILE in ('cdm', 'cfihos')
MOD = os.path.join(OUT, 'modules', 'kizc_ewp')
VER = 'v1'
RAWDB, RAWTB = 'kiz_scopes', 'list_of_scopes'
CTXDB = 'kizc_context'
RAW = f'`{RAWDB}`.`{RAWTB}`'
if PROFILE == 'cdm':
    SCHEMA, INST, DM, DS = 'sp_kizc_ewp_model', 'sp_kizc_ewp_instances', 'KizcEwp', 'ds_kizc_ewp'
else:
    # CFIHOS package conventions: dm_dom_* domain spaces, inst_* instance spaces, dm_*_domain_model data models
    SCHEMA, INST, DM, DS = 'dm_dom_kizc_ewp', 'inst_location', 'dm_kizc_ewp_domain_model', 'ds_kizc_ewp'
CFIHOS_SPACE, CFIHOS_VER = 'dm_dom_oil_and_gas', 'v1'
CDM_IMPL = [{'type': 'view', 'space': 'cdf_cdm', 'externalId': 'CogniteDescribable', 'version': 'v1'},
            {'type': 'view', 'space': 'cdf_cdm', 'externalId': 'CogniteSourceable', 'version': 'v1'}]
EXT_VIEWS = {'CogniteAsset': {'type': 'view', 'space': 'cdf_cdm', 'externalId': 'CogniteAsset', 'version': 'v1'},
             'Tag': {'type': 'view', 'space': CFIHOS_SPACE, 'externalId': 'Tag', 'version': CFIHOS_VER},
             'Files': {'type': 'view', 'space': CFIHOS_SPACE, 'externalId': 'Files', 'version': CFIHOS_VER}}

def vref(v): return EXT_VIEWS.get(v) or {'type': 'view', 'space': SCHEMA, 'externalId': v, 'version': VER}

# ---------------------------------------------------------------- model
T, D, TS, I, F, DR = 'text', 'date', 'timestamp', 'int32', 'float64', 'direct'
VIEWS = {
 'EwpProject': {'code': T},
 'EwpScopeSplitBaseSubsystem': {'code': T},
 'EwpArea': {'areaCode': T},
 'EwpInspectionDiscipline': {'code': T},
 'EwpSystem': {'systemCode': T},
 'EwpSubsystem': {'subsystemKey': T, 'subsystemCode': T, 'belongsToSystem': (DR, 'EwpSystem')},
 'EwpPerson': {'personId': T, 'email': T},
 'EwpDocument': {'documentNumber': T},
 'EwpDocumentRevision': {'revision': T, 'belongsToDocument': (DR, 'EwpDocument'), 'isInitiated': T, 'issuedP1': T,
                         'status': T, 'scheduledEndTime': D, 'uploadDate': D, 'actualDate': D, 'installationIssued': T},
 'EwpWorkScope': {
   'scopeRowId': T, 'formEntry': T, 'formEntryValidated': T, 'p6Id': T, 'projectCode': T, 'scopeSequenceNo': T,
   'executionPriority': T, 'shutdownRequirement': T, 'isBaseScope': T, 'scopeCategory': T, 'scopeStatus': T,
   'inExecution': T, 'ewpReference': T, 'overallInspectionStatus': T, 'overallInspectionReportStatus': T,
   'ewpHoldPointCount': I, 'c1ForecastDate': D, 'isMocRequired': T, 'legacyScopeCode': T, 'oimCategorisation': T,
   'integratedAssetPriority': T, 'latestStatus': T,
   'l2Dropdown': T, 'mocReference': T, 'helperColumnsMarker': T, 'projectCodeName': T, 'compareString': T,
   'duplicateCheck': T, 'inEwpTracker': T, 'inProjectsPassedGate1': T, 'inSubsystemReference': T,
   'belongsToProject': (DR, 'EwpProject'), 'locatedInArea': (DR, 'EwpArea'),
   'hasSplitBase': (DR, 'EwpScopeSplitBaseSubsystem'), 'belongsToSubsystem': (DR, 'EwpSubsystem'),
   'documentedBy': (DR, 'EwpDocument'), 'iwpDocumentedBy': (DR, 'EwpDocument'),
   'responsibleFor': (DR, 'EwpPerson'), 'createdBy': (DR, 'EwpPerson'), 'modifiedBy': (DR, 'EwpPerson')},
 'EwpGateReview': {'gate': T, 'scheduledEndTime': D, 'p6ForecastDate': D, 'apeForecastDate': D, 'endTime': D,
                   'executionPlanStatus': T, 'planningStatus': T, 'costEstimationStatus': T, 'readinessStatus': T,
                   'closedOut': T, 'belongsToScope': (DR, 'EwpWorkScope')},
 'EwpInspectionAssessment': {'isInScope': T, 'inspectionStatus': T, 'reportStatus': T,
                             'belongsToScope': (DR, 'EwpWorkScope'), 'inspectsDiscipline': (DR, 'EwpInspectionDiscipline')},
 'EwpComment': {'kind': T, 'text': T, 'commentsOn': (DR, None)},
}
# contextualization link properties, per profile
if PROFILE == 'cdm':
    LINKS = {'EwpProject': {'ifsSite': (DR, None)}, 'EwpArea': {'ifsLocation': (DR, None)},
             'EwpSystem': {'asset': (DR, 'CogniteAsset'), 'assetMatchScore': F, 'assetMatchStatus': T},
             'EwpSubsystem': {'asset': (DR, 'CogniteAsset'), 'assetMatchScore': F, 'assetMatchStatus': T},
             'EwpDocument': {'neoDocument': (DR, None), 'neoMatchStatus': T},
             'EwpDocumentRevision': {'neoRevision': (DR, None), 'neoMatchStatus': T}}
else:
    LINKS = {'EwpProject': {'siteTag': (DR, 'Tag')}, 'EwpArea': {'locationTag': (DR, 'Tag')},
             'EwpSystem': {'tag': (DR, 'Tag'), 'tagMatchScore': F, 'tagMatchStatus': T},
             'EwpSubsystem': {'tag': (DR, 'Tag'), 'tagMatchScore': F, 'tagMatchStatus': T},
             'EwpDocument': {'file': (DR, 'Files'), 'fileMatchStatus': T},
             'EwpDocumentRevision': {'file': (DR, 'Files'), 'fileMatchStatus': T},
             'EwpInspectionDiscipline': {'cfihosDisciplineCode': T, 'cfihosDisciplineName': T}}
for v, extra in LINKS.items(): VIEWS[v].update(extra)

UNIQUE = {'EwpSystem': ['systemCode'], 'EwpSubsystem': ['subsystemKey'], 'EwpDocument': ['documentNumber'],
          'EwpPerson': ['email']}
REVERSE = {
 'EwpWorkScope': {'gateReviews': ('EwpGateReview', 'belongsToScope'),
                  'inspectionAssessments': ('EwpInspectionAssessment', 'belongsToScope')},
 'EwpDocument': {'revisions': ('EwpDocumentRevision', 'belongsToDocument'), 'scopes': ('EwpWorkScope', 'documentedBy')},
 'EwpSubsystem': {'scopes': ('EwpWorkScope', 'belongsToSubsystem')},
 'EwpSystem': {'subsystems': ('EwpSubsystem', 'belongsToSystem')},
}
INDEXED = {('EwpGateReview', 'belongsToScope'), ('EwpInspectionAssessment', 'belongsToScope'),
           ('EwpDocumentRevision', 'belongsToDocument'), ('EwpWorkScope', 'documentedBy'),
           ('EwpWorkScope', 'belongsToSubsystem'), ('EwpSubsystem', 'belongsToSystem')}

def _write(base, path, text):
    p = os.path.join(base, path); os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, 'w', encoding='utf-8').write(text)
def w(path, text): _write(MOD, path, text)        # inside the module
def wroot(path, text): _write(OUT, path, text)    # organization level
def y(obj): return yaml.safe_dump(obj, sort_keys=False, allow_unicode=True, width=120)

def gen_model():
    # Toolkit resource library: data_modeling/ with .space / .container / .view / .datamodel suffixes
    for sp, desc in [(SCHEMA, 'Kiz-C EWP gate tracking: containers, views and data model'),
                     (INST, 'Instances' if PROFILE == 'cfihos' else 'Kiz-C EWP instances loaded from Smartsheet')]:
        if PROFILE == 'cfihos' and sp == INST:
            continue  # inst_location is owned by the CFIHOS package; do not redefine it here
        w(f'data_modeling/{sp}.space.yaml', y({'space': sp, 'name': sp, 'description': desc}))
    for v, props in VIEWS.items():
        cprops = {p: ({'type': {'type': 'direct'}, 'nullable': True} if isinstance(t, tuple)
                      else {'type': {'type': t}, 'nullable': True}) for p, t in props.items()}
        cont = {'space': SCHEMA, 'externalId': v, 'name': v, 'usedFor': 'node', 'properties': cprops}
        if v in UNIQUE:
            cont['constraints'] = {f'uq_{p}': {'constraintType': 'uniqueness', 'properties': [p]} for p in UNIQUE[v]}
        idx = {f'ix_{p}': {'indexType': 'btree', 'properties': [p]} for (vv, p) in sorted(INDEXED) if vv == v}
        if idx: cont['indexes'] = idx
        w(f'data_modeling/containers/{v}.container.yaml', y(cont))
        vprops = {}
        for p, t in props.items():
            vp = {'container': {'type': 'container', 'space': SCHEMA, 'externalId': v}, 'containerPropertyIdentifier': p}
            if isinstance(t, tuple) and t[1]: vp['source'] = vref(t[1])
            vprops[p] = vp
        for p, (src, through) in REVERSE.get(v, {}).items():
            vprops[p] = {'connectionType': 'multi_reverse_direct_relation', 'source': vref(src),
                         'through': {'source': vref(src), 'identifier': through}}
        w(f'data_modeling/views/{v}.view.yaml',
          y({'space': SCHEMA, 'externalId': v, 'name': v, 'version': VER, 'implements': CDM_IMPL, 'properties': vprops}))
    views = [vref(v) for v in VIEWS]
    if PROFILE == 'cfihos':
        views += [EXT_VIEWS['Tag'], EXT_VIEWS['Files']]  # expose the linked CFIHOS views in the EWP model
    w(f'data_modeling/{DM}.datamodel.yaml',
      y({'space': SCHEMA, 'externalId': DM, 'name': 'Kiz-C EWP gate tracking', 'version': VER, 'views': views}))
    w(f'data_sets/{DS}.DataSet.yaml', y({'externalId': DS, 'name': 'Kiz-C EWP', 'description': 'Kiz-C EWP scope tracking'}))
    for db in [RAWDB, CTXDB]:
        w(f'raw/{db}.Database.yaml', y({'dbName': db}))
    w(f'raw/{RAWDB}.{RAWTB}.Table.yaml', y({'dbName': RAWDB, 'tableName': RAWTB}))
    for tb in CTX_TABLES:
        w(f'raw/{CTXDB}.{tb}.Table.yaml', y({'dbName': CTXDB, 'tableName': tb}))

CTX_TABLES = (['project_site_map', 'area_location_map', 'asset_match_candidates', 'scope_context_checks']
              if PROFILE == 'cdm' else
              ['project_tag_map', 'area_tag_map', 'discipline_cfihos_map', 'tag_match_candidates', 'scope_context_checks'])

# ---------------------------------------------------------------- SQL helpers
ERRS = "('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!')"
def c(col):  # clean text from a RAW column
    return f"CASE WHEN trim(`{col}`) IN {ERRS} THEN NULL ELSE trim(`{col}`) END"
def d(col):  # date from a RAW column; text and error values become null (D-039)
    return f"CASE WHEN trim(`{col}`) LIKE '____-__-__%' THEN to_date(substr(trim(`{col}`), 1, 10)) END"
def ref(prefix, expr): return f"node_reference('{INST}', concat('{prefix}', {expr}))"
SYS_ACCOUNTS = "('cell-link@smartsheet.com', 'web-form@smartsheet.com')"
CANON = {'brian.carriou@sbmoffshore.com': 'brian.carriou', 'brian.carriou@ext.sbmoffshore.com': 'brian.carriou',
 'BIRAJ MOHAPATRA': 'biraj.mohapatra', 'biraj.mohapatra@sbmoffshore.com': 'biraj.mohapatra',
 'SANDRO CESAR': 'sandro.cesar', 'Sandro Cesar': 'sandro.cesar',
 'mohdfuad.binchenordi@sbmoffshore.com': 'mohammad.fuad', 'Mohammad Fuad': 'mohammad.fuad',
 'ramzy.benrehouma@sbmoffshore.com': 'ramzy.benrehouma', 'ratko.simic@ext.sbmoffshore.com': 'ratko.simic',
 'eliel.maroja@ext.sbmoffshore.com': 'eliel.maroja', 'manu.surendrannair@sbmoffshore.com': 'manu.surendrannair',
 'richie.ooi@exxonmobil.com': 'richie.ooi', 'kishan.mohan@sbmoffshore.com': 'kishan.mohan',
 'ahmadhumaizi.yahya@sbmoffshore.com': 'ahmadhumaizi.yahya'}
def person_key(expr):
    whens = '\n'.join(f"    WHEN {expr} = '{k}' THEN '{v}'" for k, v in CANON.items())
    return f"CASE\n    WHEN {expr} IS NULL OR {expr} IN {SYS_ACCOUNTS} THEN NULL\n{whens}\n    ELSE lower({expr})\n  END"

HEADER = lambda title, rules: f"-- {title}\n-- Source: RAW {RAWDB}.{RAWTB} (19 Nov 2026 export, all 99 columns).\n" + \
    ''.join(f"-- {r}\n" for r in rules)

SQL = {}
SQL['EwpProject'] = HEADER('EwpProject: one node per L0 project (D-022).', []) + f"""
SELECT DISTINCT
  concat('project-', {c('L0 - Project')}) AS externalId,
  {c('L0 - Project')} AS code,
  {c('L0 - Project')} AS name
FROM {RAW}
WHERE {c('L0 - Project')} IS NOT NULL
"""
SQL['EwpScopeSplitBaseSubsystem'] = HEADER('EwpScopeSplitBaseSubsystem: SS, TK, ZS, ZC, ZP, GE (D-024).', []) + f"""
SELECT
  concat('split-', substr({c('Scope Split Base')}, 1, 2)) AS externalId,
  substr({c('Scope Split Base')}, 1, 2) AS code,
  max({c('Scope Split Base')}) AS name
FROM {RAW}
WHERE {c('Scope Split Base')} IS NOT NULL
GROUP BY substr({c('Scope Split Base')}, 1, 2)
"""
SQL['EwpArea'] = HEADER('EwpArea: one node per L1 code (V, T, S, M, G).', []) + f"""
SELECT
  concat('area-', substr({c('L1 - Sub-Work')}, 1, 1)) AS externalId,
  substr({c('L1 - Sub-Work')}, 1, 1) AS areaCode,
  max({c('L1 - Sub-Work')}) AS name
FROM {RAW}
WHERE {c('L1 - Sub-Work')} IS NOT NULL
GROUP BY substr({c('L1 - Sub-Work')}, 1, 1)
"""
DISC = [('Piping', 'Piping'), ('Instrument', 'Instrument'), ('Mechanical', 'Mechanical'), ('Electrical', 'Electrical'),
        ('Str. Topsides', 'Structural Topsides'), ('Str. Hull', 'Structural Hull'), ('Coating', 'Coating')]
dkey = lambda n: n.replace(' ', '').lower()
SQL['EwpInspectionDiscipline'] = HEADER('EwpInspectionDiscipline: the 7 inspection disciplines (D-027).', []) + '\n' + \
    '\nUNION ALL\n'.join(f"SELECT 'disc-{dkey(n)}' AS externalId, '{dkey(n)}' AS code, '{n}' AS name" for _, n in DISC) + '\n'
SQL['EwpSystem'] = HEADER('EwpSystem: one node per System code.',
    ['Some rows leave System Description blank; max() keeps the one non-empty description per code (checked).']) + f"""
SELECT
  concat('system-', {c('System')}) AS externalId,
  {c('System')} AS systemCode,
  max({c('System Description')}) AS name
FROM {RAW}
WHERE {c('System')} IS NOT NULL
GROUP BY {c('System')}
"""
L2 = f"coalesce({c('L2 - Scopes')}, {c('L2-Dropdown')})"
SQL['EwpSubsystem'] = HEADER('EwpSubsystem: key is the full L2 text, code plus title (D-063). 415 nodes.', []) + f"""
SELECT
  concat('sub-', {L2}) AS externalId,
  {L2} AS subsystemKey,
  {L2} AS name,
  max({c('Subsystem Code')}) AS subsystemCode,
  {ref('system-', f"max({c('System')})")} AS belongsToSystem
FROM {RAW}
WHERE {L2} IS NOT NULL
GROUP BY {L2}
"""
PCOLS = ['Responsible PE', 'Created By', 'Modified By']
SQL['EwpPerson'] = HEADER('EwpPerson: one node per person after merges (D-028, D-030, D-032, D-064).',
    ['Every raw spelling is kept in CDM aliases. System accounts (cell-link, web-form) are not persons.']) + f"""
WITH raw_people AS (
""" + '\n  UNION ALL\n'.join(f"  SELECT {c(col)} AS raw_value FROM {RAW}" for col in PCOLS) + f"""
), keyed AS (
  SELECT raw_value, {person_key('raw_value')} AS person_key
  FROM raw_people
)
SELECT
  concat('person-', person_key) AS externalId,
  person_key AS personId,
  initcap(replace(person_key, '.', ' ')) AS name,
  max(CASE WHEN raw_value LIKE '%@%' THEN raw_value END) AS email,
  collect_set(raw_value) AS aliases
FROM keyed
WHERE person_key IS NOT NULL
GROUP BY person_key
"""
SQL['EwpDocument'] = HEADER('EwpDocument: one node per EWP document number (D-026), plus the IWP document.',
    ['Placeholder numbers containing "xxx" load as documents, as in the uploaded model.']) + f"""
SELECT DISTINCT
  concat('doc-', doc) AS externalId,
  doc AS documentNumber,
  doc AS name
FROM (
  SELECT {c('EWP Document Number')} AS doc FROM {RAW}
  UNION ALL
  SELECT {c('IWP Reference')} AS doc FROM {RAW}
) docs
WHERE doc IS NOT NULL
"""
DOC = c('EWP Document Number')
SQL['EwpDocumentRevision'] = HEADER('EwpDocumentRevision: P1 and C1 per EWP document, IWP revision on the IWP document.',
    ['Values are identical across scopes that share a document (checked), so max() picks that value.',
     'A revision is created only when at least one of its values is filled.']) + f"""
SELECT * FROM (
  SELECT
    concat('rev-', {DOC}, '-P1') AS externalId,
    'P1' AS revision,
    concat({DOC}, ' P1') AS name,
    {ref('doc-', DOC)} AS belongsToDocument,
    max({c('Initiate EWP P1 (Draft)')}) AS isInitiated,
    max({c('EWP P1 (Draft) issued in NEO')}) AS issuedP1,
    max({c('EWP P1 Status')}) AS status,
    cast(NULL AS date) AS scheduledEndTime,
    cast(NULL AS date) AS uploadDate,
    cast(NULL AS date) AS actualDate,
    cast(NULL AS string) AS installationIssued
  FROM {RAW}
  WHERE {DOC} IS NOT NULL
  GROUP BY {DOC}
  HAVING max({c('Initiate EWP P1 (Draft)')}) IS NOT NULL OR max({c('EWP P1 (Draft) issued in NEO')}) IS NOT NULL
      OR max({c('EWP P1 Status')}) IS NOT NULL
  UNION ALL
  SELECT
    concat('rev-', {DOC}, '-C1'), 'C1', concat({DOC}, ' C1'), {ref('doc-', DOC)},
    cast(NULL AS string), cast(NULL AS string), cast(NULL AS string),
    max({d('EWP Rev C1 Plan Date')}),
    max({d('EWP Rev C1 Upload Date in NEO')}),
    max({d('EWP Rev C1 Actual Date')}),
    cast(NULL AS string)
  FROM {RAW}
  WHERE {DOC} IS NOT NULL
  GROUP BY {DOC}
  HAVING max({d('EWP Rev C1 Plan Date')}) IS NOT NULL OR max({d('EWP Rev C1 Upload Date in NEO')}) IS NOT NULL
      OR max({d('EWP Rev C1 Actual Date')}) IS NOT NULL
  UNION ALL
  SELECT
    concat('rev-', {c('IWP Reference')}, '-IWP'), 'IWP', concat({c('IWP Reference')}, ' IWP'), {ref('doc-', c('IWP Reference'))},
    cast(NULL AS string), cast(NULL AS string), cast(NULL AS string),
    cast(NULL AS date), cast(NULL AS date), cast(NULL AS date),
    max({c('IWP Installation issued')})
  FROM {RAW}
  WHERE {c('IWP Reference')} IS NOT NULL
  GROUP BY {c('IWP Reference')}
) revisions
"""
SC = c('Scope Categorisation'); HP = c('EWP Hold Points')
SQL['EwpWorkScope'] = HEADER('EwpWorkScope: one node per Smartsheet row (815).',
    ['Identity: interim Excel row number (RAW key) until the Smartsheet row ID is exported (D-044).',
     'Scope Categorisation is split into scopeCategory and scopeStatus (D-041).',
     'Raw Created By / Modified By go to CDM sourceCreatedUser / sourceUpdatedUser, including system accounts (D-028).']) + f"""
SELECT
  concat('scope-', `key`) AS externalId,
  `key` AS scopeRowId,
  {c('Project Name')} AS name,
  {c('Form Entry')} AS formEntry,
  {c('Form Entry Validated')} AS formEntryValidated,
  {c('P6 ID')} AS p6Id,
  {c('Project Code')} AS projectCode,
  {c('Project Number')} AS scopeSequenceNo,
  {c("Priority - Jun'26 update + APE final input")} AS executionPriority,
  {c('Shutdown Requirement')} AS shutdownRequirement,
  {c('Base Scope')} AS isBaseScope,
  CASE WHEN {SC} IN ('Base', 'Tank Opportunity', 'Others') THEN {SC} END AS scopeCategory,
  CASE WHEN {SC} IN ('Added', 'No Scope pre-G1', 'No Scope post-G1') THEN {SC} END AS scopeStatus,
  {c('In Execution')} AS inExecution,
  {c('EWP Reference')} AS ewpReference,
  {c('Overall Inspection Status')} AS overallInspectionStatus,
  {c('Overall Inspection Report Status')} AS overallInspectionReportStatus,
  CASE WHEN upper({HP}) IN ('YES', 'NO') THEN NULL ELSE cast({HP} AS int) END AS ewpHoldPointCount,
  {d('EWP Rev C1 Forecast Date')} AS c1ForecastDate,
  {c('MOC Required')} AS isMocRequired,
  {c('Scope Code')} AS legacyScopeCode,
  {c('OIM Categorisation')} AS oimCategorisation,
  {c('Integrated Asset Priority')} AS integratedAssetPriority,
  {c('Latest Status')} AS latestStatus,
  {c('L2-Dropdown')} AS l2Dropdown,
  {c('MOC Reference')} AS mocReference,
  {c('Helper Columns ->')} AS helperColumnsMarker,
  {c('Project Code - Name')} AS projectCodeName,
  {c('Compare String')} AS compareString,
  {c('Duplicate Check')} AS duplicateCheck,
  {c('In EWP Tracker')} AS inEwpTracker,
  {c('In Projects Passed Gate 1')} AS inProjectsPassedGate1,
  {c('In Subsystem Reference')} AS inSubsystemReference,
  to_timestamp({c('Created')}) AS sourceCreatedTime,
  to_timestamp({c('Modified')}) AS sourceUpdatedTime,
  {c('Created By')} AS sourceCreatedUser,
  {c('Modified By')} AS sourceUpdatedUser,
  'Smartsheet Kiz C - List of Scopes' AS sourceContext,
  {ref('project-', c('L0 - Project'))} AS belongsToProject,
  {ref('area-', f"substr({c('L1 - Sub-Work')}, 1, 1)")} AS locatedInArea,
  {ref('split-', f"substr({c('Scope Split Base')}, 1, 2)")} AS hasSplitBase,
  CASE WHEN {c('Subsystem Code')} IS NOT NULL THEN {ref('sub-', L2)} END AS belongsToSubsystem,
  {ref('doc-', c('EWP Document Number'))} AS documentedBy,
  {ref('doc-', c('IWP Reference'))} AS iwpDocumentedBy,
  {ref('person-', person_key(c('Responsible PE')))} AS responsibleFor,
  {ref('person-', person_key(c('Created By')))} AS createdBy,
  {ref('person-', person_key(c('Modified By')))} AS modifiedBy
FROM {RAW}
"""
GATES = [
 ('1', {'scheduledEndTime': 'Gate 1 Review Plan Date', 'p6ForecastDate': 'Gate 1 Review P6 Forecast Date',
        'apeForecastDate': "Gate 1 Review APE's  Forecast Date", 'endTime': 'Gate 1 Review Complete Date'}),
 ('2', {'scheduledEndTime': 'Gate 2 Review  P6 BL Plan Date', 'p6ForecastDate': 'Gate 2 Review P6 Forecast Date',
        'apeForecastDate': "Gate 2 Review APE's  Forecast Date", 'endTime': 'Gate 2 Review Complete Date',
        'executionPlanStatus': 'Gate 2 Execution Plan', 'planningStatus': 'Gate 2 Planning',
        'costEstimationStatus': 'Gate 2 Cost Estimation', 'readinessStatus': 'Gate 2 Readiness'}),
 ('3', {'scheduledEndTime': 'Gate 3 Review P6 BL Plan Date', 'p6ForecastDate': 'Gate 3 Review P6 Forecast Date',
        'apeForecastDate': "Gate 3 Review APE's  Forecast Date", 'endTime': 'Gate 3 Review Complete Date'}),
 ('4', {'scheduledEndTime': 'Gate 4 Review P6 BL Plan Date', 'p6ForecastDate': 'Gate 4 Review P6 Forecast Date',
        'apeForecastDate': "Gate 4 Review APE's  Forecast Date", 'endTime': 'Gate 4 Review Complete Date'}),
 ('CLOSEOUT', {'scheduledEndTime': 'Closed Out Plan Date', 'p6ForecastDate': 'Closed Out Forecast Date',
               'endTime': 'Closed Out Complete Date', 'closedOut': 'Closed Out'})]
GPROPS = ['scheduledEndTime', 'p6ForecastDate', 'apeForecastDate', 'endTime', 'executionPlanStatus', 'planningStatus',
          'costEstimationStatus', 'readinessStatus', 'closedOut']
DATEP = {'scheduledEndTime', 'p6ForecastDate', 'apeForecastDate', 'endTime'}
def gate_expr(p, m):
    if p not in m: return f"cast(NULL AS {'date' if p in DATEP else 'string'})"
    return d(m[p]) if p in DATEP else c(m[p])
def gate_has_data(m): return ' OR '.join(f"({gate_expr(p, m)}) IS NOT NULL" for p in m)
parts = []
for gate, m in GATES:
    cols = ',\n    '.join(f"{gate_expr(p, m)} AS {p}" for p in GPROPS)
    parts.append(f"""  SELECT
    concat('gate-', `key`, '-{gate}') AS externalId,
    '{gate}' AS gate,
    concat({c('Project Code')}, ' Gate {gate}') AS name,
    {ref('scope-', '`key`')} AS belongsToScope,
    {cols}
  FROM {RAW}
  WHERE {gate_has_data(m)}""")
SQL['EwpGateReview'] = HEADER('EwpGateReview: Gates 1 to 4 and close-out (D-033), one per scope per gate with data.',
    ['Text in plan-date columns equals Scope Categorisation and is nulled here; it lives on the scope.']) + \
    '\nSELECT * FROM (\n' + '\n  UNION ALL\n'.join(parts) + '\n) gates\n'
parts = []
for src, n in DISC:
    parts.append(f"""  SELECT
    concat('insp-', `key`, '-{dkey(n)}') AS externalId,
    concat({c('Project Code')}, ' {n}') AS name,
    {ref('scope-', '`key`')} AS belongsToScope,
    node_reference('{INST}', 'disc-{dkey(n)}') AS inspectsDiscipline,
    {c('Inspection Scope - ' + src)} AS isInScope,
    {c('Inspection Status - ' + src)} AS inspectionStatus,
    {c('Inspection Report Status - ' + src)} AS reportStatus
  FROM {RAW}""")
SQL['EwpInspectionAssessment'] = HEADER('EwpInspectionAssessment: 815 scopes x 7 disciplines = 5,705 (D-027).',
    ['Status values are kept raw (D-036).']) + '\nSELECT * FROM (\n' + '\n  UNION ALL\n'.join(parts) + '\n) assessments\n'
G2 = dict(GATES)['2']
SQL['EwpComment'] = HEADER('EwpComment: Notes, Latest comment, Gate 2 Readiness Comment (D-014, D-031).',
    ['Gate 2 comments attach to the Gate 2 review; if a scope has no Gate 2 data they attach to the scope.']) + f"""
SELECT * FROM (
  SELECT concat('comment-', `key`, '-notes') AS externalId, 'notes' AS kind, {c('Notes')} AS text,
    {ref('scope-', '`key`')} AS commentsOn
  FROM {RAW} WHERE {c('Notes')} IS NOT NULL
  UNION ALL
  SELECT concat('comment-', `key`, '-latestComment'), 'latestComment', {c('Latest comment')},
    {ref('scope-', '`key`')}
  FROM {RAW} WHERE {c('Latest comment')} IS NOT NULL
  UNION ALL
  SELECT concat('comment-', `key`, '-gate2Readiness'), 'gate2Readiness', {c('Gate 2 Readiness Comment')},
    CASE WHEN {gate_has_data(G2)} THEN {ref('gate-', "concat(`key`, '-2')")} ELSE {ref('scope-', '`key`')} END
  FROM {RAW} WHERE {c('Gate 2 Readiness Comment')} IS NOT NULL
) comments
"""
ORDER = ['EwpProject', 'EwpScopeSplitBaseSubsystem', 'EwpArea', 'EwpInspectionDiscipline', 'EwpSystem', 'EwpSubsystem',
         'EwpPerson', 'EwpDocument', 'EwpDocumentRevision', 'EwpWorkScope', 'EwpGateReview',
         'EwpInspectionAssessment', 'EwpComment']

def snake(v): return ''.join('_' + ch.lower() if ch.isupper() else ch for ch in v).lstrip('_')
AUTH = {'clientId': '{{ transformation_client_id }}', 'clientSecret': '{{ transformation_client_secret }}'}
def tr_yaml(xid, name, dest, folder):
    return y({'externalId': xid, 'name': name, 'destination': dest, 'dataSetExternalId': DS,
              'ignoreNullFields': False, 'isPublic': True, 'conflictMode': 'upsert', 'authentication': AUTH})

def gen_transformations():
    for i, v in enumerate(ORDER, 1):
        fn = f'{i:02d}_{snake(v)}'
        dest = {'type': 'nodes', 'view': {'space': SCHEMA, 'externalId': v, 'version': VER}, 'instanceSpace': INST}
        w(f'transformations/{fn}.Transformation.yaml', tr_yaml(f'tr_kizc_{snake(v)}', f'Kiz-C {v}', dest, 'transformations'))
        w(f'transformations/{fn}.Transformation.sql', SQL[v].lstrip())

# ---------------------------------------------------------------- contextualization
CTX = {}
CTX['scope_context_checks'] = ("""-- Internal contextualization check: does each scope's document agree with its own project and system?
-- Writes one row per scope to RAW kizc_context.scope_context_checks. Runs on the Smartsheet data alone.
-- Rule 1 (Q8): SO17104 = M-MONDO, SO17105 = S-SAXI.
-- Rule 2: EWP numbers SOnnnnn-ZGFsspnn carry the system code in characters 12-13 (for example SO17104-ZGF05008 -> 05).
""" + f"""SELECT
  `key` AS key,
  {c('Project Code')} AS projectCode,
  {c('L0 - Project')} AS project,
  {c('System')} AS systemCode,
  {DOC} AS documentNumber,
  CASE
    WHEN {DOC} IS NULL THEN 'no document'
    WHEN substr({DOC}, 1, 7) NOT IN ('SO17104', 'SO17105') THEN 'not an SO number'
    WHEN (substr({DOC}, 1, 7) = 'SO17104' AND {c('L0 - Project')} = 'M-MONDO')
      OR (substr({DOC}, 1, 7) = 'SO17105' AND {c('L0 - Project')} = 'S-SAXI') THEN 'agrees'
    ELSE 'disagrees'
  END AS projectCheck,
  CASE
    WHEN {DOC} IS NULL OR substr({DOC}, 9, 3) <> 'ZGF' THEN 'not a ZGF number'
    WHEN lower(substr({DOC}, 12, 2)) = 'xx' OR lower({DOC}) LIKE '%xxx%' THEN 'placeholder'
    WHEN {c('System')} IS NULL THEN 'scope has no system'
    WHEN substr({DOC}, 12, 2) = {c('System')} THEN 'agrees'
    ELSE 'disagrees'
  END AS systemCheck
FROM {RAW}
""", {'type': 'raw', 'database': CTXDB, 'table': 'scope_context_checks'})


# ---------------------------------------------------------------- contextualization (profile specific)
def node_dest(view): return {'type': 'nodes', 'view': {'space': SCHEMA, 'externalId': view, 'version': VER}, 'instanceSpace': INST}
CAND = 'asset_match_candidates' if PROFILE == 'cdm' else 'tag_match_candidates'

def accepted_matches(view, prop, score, status, target):
    return (f"""-- Contextualization: write reviewed {view} -> {target} matches.
-- Candidates come from scripts/entity_match.py (or the CDF entity matching UI) in RAW {CTXDB}.{CAND}.
-- Only rows a reviewer set to status = 'accepted' are written.
SELECT
  sourceExternalId AS externalId,
  node_reference(targetSpace, targetExternalId) AS {prop},
  cast(score AS double) AS {score},
  'accepted' AS {status}
FROM `{CTXDB}`.`{CAND}`
WHERE status = 'accepted' AND sourceView = '{view}'
""", node_dest(view))

def mapping_table(view, prefix, keycol, table, prop, comment):
    return (f"""-- Contextualization: {comment}
-- Few values, so the link comes from a reviewed mapping table, not matching:
-- RAW {CTXDB}.{table} ({keycol}, targetSpace, targetExternalId). Fill it (upload_data/), then run.
SELECT
  concat('{prefix}', {keycol}) AS externalId,
  node_reference(targetSpace, targetExternalId) AS {prop}
FROM `{CTXDB}`.`{table}`
WHERE nullif(trim(targetExternalId), '') IS NOT NULL
""", node_dest(view))

if PROFILE == 'cdm':
    CTX['document_neo'] = (f"""-- Contextualization: link each EwpDocument to its NEO document by document number (D-023).
-- Exact match on the normalised number (trimmed, upper case). Placeholders ("xxx") are marked, not matched (Q10).
-- The {{{{ neo_* }}}} variables are set in config.dev.yaml.
WITH ewp AS (
  SELECT externalId, documentNumber FROM cdf_data_models('{SCHEMA}', '{DM}', '{VER}', 'EwpDocument')
), neo AS (
  SELECT space AS neo_space, externalId AS neo_xid, upper(trim({{{{ neo_doc_number_property }}}})) AS neo_number
  FROM cdf_data_models('{{{{ neo_model_space }}}}', '{{{{ neo_model }}}}', '{{{{ neo_model_version }}}}', '{{{{ neo_document_view }}}}')
)
SELECT
  ewp.externalId,
  CASE WHEN neo.neo_xid IS NOT NULL THEN node_reference(neo.neo_space, neo.neo_xid) END AS neoDocument,
  CASE WHEN lower(ewp.documentNumber) LIKE '%xxx%' THEN 'placeholder'
       WHEN neo.neo_xid IS NOT NULL THEN 'matched' ELSE 'not found in NEO' END AS neoMatchStatus
FROM ewp
LEFT JOIN neo ON neo.neo_number = upper(trim(ewp.documentNumber))
""", node_dest('EwpDocument'))
    CTX['revision_neo'] = (f"""-- Contextualization: link each EwpDocumentRevision (P1, C1) to the NEO revision of its linked NEO document.
-- Runs after document_neo. Values stay Smartsheet-owned (D-046); the link records which NEO revision they describe.
WITH rev AS (
  SELECT r.externalId, r.revision, r.belongsToDocument.externalId AS doc_xid
  FROM cdf_data_models('{SCHEMA}', '{DM}', '{VER}', 'EwpDocumentRevision') r
), doc AS (
  SELECT externalId, neoDocument.externalId AS neo_doc_xid
  FROM cdf_data_models('{SCHEMA}', '{DM}', '{VER}', 'EwpDocument') WHERE neoDocument IS NOT NULL
), neo_rev AS (
  SELECT space AS neo_space, externalId AS neo_xid,
         {{{{ neo_revision_document_property }}}}.externalId AS neo_doc_xid,
         upper(trim({{{{ neo_revision_code_property }}}})) AS neo_code
  FROM cdf_data_models('{{{{ neo_model_space }}}}', '{{{{ neo_model }}}}', '{{{{ neo_model_version }}}}', '{{{{ neo_revision_view }}}}')
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
""", node_dest('EwpDocumentRevision'))
    CTX['project_ifs'] = mapping_table('EwpProject', 'project-', 'projectCode', 'project_site_map', 'ifsSite',
                                       'link EwpProject to its IFS site (Q14, D-021).')
    CTX['area_ifs'] = mapping_table('EwpArea', 'area-', 'areaCode', 'area_location_map', 'ifsLocation',
                                    'link EwpArea to its IFS location (weak candidate, D-052).')
    CTX['system_asset'] = accepted_matches('EwpSystem', 'asset', 'assetMatchScore', 'assetMatchStatus', 'CogniteAsset')
    CTX['subsystem_asset'] = accepted_matches('EwpSubsystem', 'asset', 'assetMatchScore', 'assetMatchStatus', 'CogniteAsset')
    CTX_ORDER = ['scope_context_checks', 'document_neo', 'revision_neo', 'project_ifs', 'area_ifs', 'system_asset',
                 'subsystem_asset']
else:
    FILES = f"cdf_data_models('{CFIHOS_SPACE}', '{{{{ cfihos_data_model }}}}', '{CFIHOS_VER}', 'Files')"
    CTX['document_files'] = (f"""-- Contextualization (CFIHOS): link each EwpDocument to the CFIHOS Files node for that document.
-- The Files view flattens Document -> Revision -> File, so one document has a Files node per revision.
-- The document-level link points at the latest revision; revision links are made in revision_files.
-- Placeholders ("xxx") are marked, not matched (Q10). Property names are variables in config.dev.yaml.
WITH ewp AS (
  SELECT externalId, documentNumber FROM cdf_data_models('{SCHEMA}', '{DM}', '{VER}', 'EwpDocument')
), files AS (
  SELECT space AS f_space, externalId AS f_xid,
         upper(trim({{{{ files_document_number_property }}}})) AS f_number,
         row_number() OVER (PARTITION BY upper(trim({{{{ files_document_number_property }}}}))
                            ORDER BY {{{{ files_revision_property }}}} DESC) AS rn
  FROM {FILES}
)
SELECT
  ewp.externalId,
  CASE WHEN files.f_xid IS NOT NULL THEN node_reference(files.f_space, files.f_xid) END AS file,
  CASE WHEN lower(ewp.documentNumber) LIKE '%xxx%' THEN 'placeholder'
       WHEN files.f_xid IS NOT NULL THEN 'matched' ELSE 'not found in Files' END AS fileMatchStatus
FROM ewp
LEFT JOIN files ON files.f_number = upper(trim(ewp.documentNumber)) AND files.rn = 1
""", node_dest('EwpDocument'))
    CTX['revision_files'] = (f"""-- Contextualization (CFIHOS): link each EwpDocumentRevision (P1, C1) to the CFIHOS Files node for the
-- same document number and revision code. P1 / C1 values stay Smartsheet-owned (D-046).
WITH rev AS (
  SELECT r.externalId, r.revision, d.documentNumber
  FROM cdf_data_models('{SCHEMA}', '{DM}', '{VER}', 'EwpDocumentRevision') r
  JOIN cdf_data_models('{SCHEMA}', '{DM}', '{VER}', 'EwpDocument') d ON d.externalId = r.belongsToDocument.externalId
  WHERE r.revision IN ('P1', 'C1')
), files AS (
  SELECT space AS f_space, externalId AS f_xid,
         upper(trim({{{{ files_document_number_property }}}})) AS f_number,
         upper(trim({{{{ files_revision_property }}}})) AS f_revision
  FROM {FILES}
)
SELECT
  rev.externalId,
  CASE WHEN files.f_xid IS NOT NULL THEN node_reference(files.f_space, files.f_xid) END AS file,
  CASE WHEN files.f_xid IS NOT NULL THEN 'matched' ELSE 'revision not found in Files' END AS fileMatchStatus
FROM rev
LEFT JOIN files ON files.f_number = upper(trim(rev.documentNumber)) AND files.f_revision = upper(rev.revision)
""", node_dest('EwpDocumentRevision'))
    CTX['project_tag'] = mapping_table('EwpProject', 'project-', 'projectCode', 'project_tag_map', 'siteTag',
        'link EwpProject to its site / plant Tag in the CFIHOS hierarchy (replaces IFS_Site, Q14).')
    CTX['area_tag'] = mapping_table('EwpArea', 'area-', 'areaCode', 'area_tag_map', 'locationTag',
        'link EwpArea to its area / functional-location Tag (replaces IFS_Location, D-052).')
    CTX['discipline_cfihos'] = (f"""-- Contextualization (CFIHOS): map the 7 inspection disciplines to CFIHOS discipline codes.
-- RAW {CTXDB}.discipline_cfihos_map (code, cfihosDisciplineCode, cfihosDisciplineName), filled from the
-- CFIHOS reference data library your project uses.
SELECT
  concat('disc-', code) AS externalId,
  cfihosDisciplineCode,
  cfihosDisciplineName
FROM `{CTXDB}`.`discipline_cfihos_map`
WHERE nullif(trim(cfihosDisciplineCode), '') IS NOT NULL
""", node_dest('EwpInspectionDiscipline'))
    CTX['system_tag'] = accepted_matches('EwpSystem', 'tag', 'tagMatchScore', 'tagMatchStatus', 'Tag')
    CTX['subsystem_tag'] = accepted_matches('EwpSubsystem', 'tag', 'tagMatchScore', 'tagMatchStatus', 'Tag')
    CTX_ORDER = ['scope_context_checks', 'document_files', 'revision_files', 'project_tag', 'area_tag',
                 'discipline_cfihos', 'system_tag', 'subsystem_tag']

def gen_ctx():
    for i, k in enumerate(CTX_ORDER, 1):
        sql, dest = CTX[k]
        fn = f'{i:02d}_ctx_{k}'
        w(f'transformations/contextualization/{fn}.Transformation.yaml',
          tr_yaml(f'tr_kizc_ctx_{k}', f'Kiz-C contextualization: {k.replace("_", " ")}', dest, 'ctx'))
        w(f'transformations/contextualization/{fn}.Transformation.sql', sql)

def gen_script():
    target = ('ViewId("cdf_cdm", "CogniteAsset", "v1")' if PROFILE == 'cdm'
              else f'ViewId("{CFIHOS_SPACE}", "Tag", "{CFIHOS_VER}")')
    wroot('scripts/entity_match.py', textwrap.dedent(f'''\
        """Propose EwpSystem / EwpSubsystem -> {'CogniteAsset' if PROFILE == 'cdm' else 'CFIHOS Tag'} matches with CDF entity matching.

        Writes candidates to RAW {CTXDB}.{CAND} with status 'proposed'. A reviewer sets status to
        'accepted' or 'rejected' (RAW explorer or the entity matching UI). Then run the
        system / subsystem contextualization transformations, which write only accepted rows.

        Requires cognite-sdk and a configured CogniteClient. Check the entity matching section of the
        cognite-sdk docs for your SDK version before running; signatures can change between releases.
        """
        from cognite.client import CogniteClient
        from cognite.client.data_classes.data_modeling import ViewId

        SCHEMA, VER = "{SCHEMA}", "{VER}"
        TARGET_VIEW = {target}
        SCORE_THRESHOLD = 0.75

        client = CogniteClient()

        def nodes(view, props):
            out = []
            for n in client.data_modeling.instances.list(instance_type="node", sources=[view], limit=None):
                p = n.properties[view]
                out.append({{"id": f"{{n.space}}|{{n.external_id}}", **{{k: str(p.get(k) or "") for k in props}}}})
            return out

        targets = nodes(TARGET_VIEW, ["name", "description"])
        for src_view, fields in [("EwpSystem", [("name", "name")]),
                                 ("EwpSubsystem", [("name", "name"), ("name", "description")])]:
            sources = nodes(ViewId(SCHEMA, src_view, VER), ["name"])
            model = client.entity_matching.fit(sources=sources, targets=targets, match_fields=fields, feature_type="bigram")
            result = model.predict(sources=sources, targets=targets, num_matches=1, score_threshold=SCORE_THRESHOLD).result
            rows = {{}}
            for item in result["items"]:
                for m in item.get("matches", []):
                    _, src_xid = item["source"]["id"].split("|", 1)
                    tgt_space, tgt_xid = m["target"]["id"].split("|", 1)
                    rows[src_xid] = {{"sourceView": src_view, "sourceExternalId": src_xid,
                                     "sourceName": item["source"].get("name"), "targetSpace": tgt_space,
                                     "targetExternalId": tgt_xid, "targetName": m["target"].get("name"),
                                     "score": m["score"], "status": "proposed"}}
            client.raw.rows.insert("{CTXDB}", "{CAND}", rows, ensure_parent=True)
            print(src_view, len(sources), "sources,", len(rows), "proposals")
        '''))

def manifest(name, table, key):
    return y({'kind': 'RawRows', 'type': 'rawTable', 'table': {'dbName': table[0], 'tableName': table[1]}, 'key': key})

def gen_upload_data(raw_csv):
    # Data to upload with `cdf data upload dir upload_data` (Toolkit data plugin), kept outside the module.
    import shutil
    os.makedirs(os.path.join(OUT, 'upload_data'), exist_ok=True)
    shutil.copy(raw_csv, os.path.join(OUT, 'upload_data', 'scopes.RawRows.csv'))
    wroot('upload_data/scopes.Manifest.yaml', manifest('scopes', (RAWDB, RAWTB), 'scope_row_id'))
    tspace = 'REPLACE_ifs_space' if PROFILE == 'cdm' else INST
    seeds = {
      ('project_site_map' if PROFILE == 'cdm' else 'project_tag_map'):
        ('projectCode', ['M-MONDO', 'S-SAXI']),
      ('area_location_map' if PROFILE == 'cdm' else 'area_tag_map'):
        ('areaCode', ['G', 'M', 'S', 'T', 'V'])}
    for tb, (key, vals) in seeds.items():
        wroot(f'upload_data/{tb}.RawRows.csv', f'{key},targetSpace,targetExternalId\n' + ''.join(f'{v},{tspace},\n' for v in vals))
        wroot(f'upload_data/{tb}.Manifest.yaml', manifest(tb, (CTXDB, tb), key))
    if PROFILE == 'cfihos':
        rows = ''.join(f'{c},,\n' for c in ['piping', 'instrument', 'mechanical', 'electrical', 'structuraltopsides',
                                            'structuralhull', 'coating'])
        wroot('upload_data/discipline_cfihos_map.RawRows.csv', 'code,cfihosDisciplineCode,cfihosDisciplineName\n' + rows)
        wroot('upload_data/discipline_cfihos_map.Manifest.yaml', manifest('d', (CTXDB, 'discipline_cfihos_map'), 'code'))

def gen_auth():
    dm_read = ['cdf_cdm', 'cdf_cdm_units'] + ([CFIHOS_SPACE] if PROFILE == 'cfihos' else [])
    raw_scope = {'tableScope': {'dbsToTables': {RAWDB: [], CTXDB: []}}}
    owner = {'name': 'gp_kizc_ewp_owner', 'sourceId': '{{ owner_source_id }}',
             'metadata': {'origin': 'cognite-toolkit', 'module': 'kizc_ewp'},
             'capabilities': [
               {'dataModelsAcl': {'actions': ['READ', 'WRITE'], 'scope': {'spaceIdScope': {'spaceIds': [SCHEMA]}}}},
               {'dataModelsAcl': {'actions': ['READ'], 'scope': {'spaceIdScope': {'spaceIds': dm_read}}}},
               {'dataModelInstancesAcl': {'actions': ['READ', 'WRITE', 'WRITE_PROPERTIES'],
                                          'scope': {'spaceIdScope': {'spaceIds': [INST]}}}},
               {'rawAcl': {'actions': ['READ', 'WRITE'], 'scope': raw_scope}},
               {'datasetsAcl': {'actions': ['READ', 'OWNER'], 'scope': {'idScope': {'ids': [DS]}}}},
               {'transformationsAcl': {'actions': ['READ', 'WRITE'], 'scope': {'datasetScope': {'ids': [DS]}}}},
               {'sessionsAcl': {'actions': ['LIST', 'CREATE'], 'scope': {'all': {}}}},
               {'entitymatchingAcl': {'actions': ['READ', 'WRITE'], 'scope': {'all': {}}}}]}
    reader = {'name': 'gp_kizc_ewp_reader', 'sourceId': '{{ read_source_id }}',
              'metadata': {'origin': 'cognite-toolkit', 'module': 'kizc_ewp'},
              'capabilities': [
                {'dataModelsAcl': {'actions': ['READ'], 'scope': {'spaceIdScope': {'spaceIds': [SCHEMA] + dm_read}}}},
                {'dataModelInstancesAcl': {'actions': ['READ'], 'scope': {'spaceIdScope': {'spaceIds': [INST]}}}},
                {'rawAcl': {'actions': ['READ'], 'scope': raw_scope}}]}
    w('auth/gp_kizc_ewp_owner.Group.yaml', y(owner))
    w('auth/gp_kizc_ewp_reader.Group.yaml', y(reader))

def gen_config():
    variables = {'transformation_client_id': '${IDP_CLIENT_ID}', 'transformation_client_secret': '${IDP_CLIENT_SECRET}',
                 'owner_source_id': '${OWNER_GROUP_SOURCE_ID}', 'read_source_id': '${READ_GROUP_SOURCE_ID}'}
    if PROFILE == 'cdm':
        variables.update({'neo_model_space': 'REPLACE', 'neo_model': 'REPLACE', 'neo_model_version': 'REPLACE',
                          'neo_document_view': 'Document', 'neo_doc_number_property': 'doc_number',
                          'neo_revision_view': 'Revision', 'neo_revision_document_property': 'REPLACE',
                          'neo_revision_code_property': 'REPLACE'})
    else:
        variables.update({'cfihos_data_model': 'dm_oil_and_gas_domain_model',
                          'files_document_number_property': 'REPLACE_document_number_property_on_Files',
                          'files_revision_property': 'REPLACE_revision_property_on_Files'})
    w('default.config.yaml', y(variables))
    wroot('config.dev.yaml', y({'environment': {'name': 'dev', 'project': 'REPLACE_with_cdf_project', 'type': 'dev',
                                                'selected': ['modules/kizc_ewp']},
                                'variables': {'modules': {'kizc_ewp': variables}}}))
    wroot('cdf.toml', '[cdf]\ndefault_organization_dir = "."\ndefault_env = "dev"\n')
    wroot('.env.example', 'CDF_PROJECT=\nCDF_CLUSTER=\nIDP_CLIENT_ID=\nIDP_CLIENT_SECRET=\nIDP_TENANT_ID=\n'
                          'OWNER_GROUP_SOURCE_ID=\nREAD_GROUP_SOURCE_ID=\n')

if __name__ == '__main__':
    gen_model(); gen_transformations(); gen_ctx(); gen_script(); gen_upload_data(sys.argv[3]); gen_auth(); gen_config()
    print('generated', PROFILE, OUT)
