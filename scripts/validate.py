"""Run the generated transformation SQL locally (SQLite stand-in for Spark SQL) against the RAW CSV
and compare every node and relation with the independent Python build (v3).

Usage: python3 validate.py <module_dir> <raw_csv> <v3_build_dir>
"""
import csv, glob, os, re, sqlite3, sys, collections, json, datetime

MOD, RAWCSV, V3 = sys.argv[1:4]
con = sqlite3.connect(':memory:')
con.execute("ATTACH ':memory:' AS kiz_scopes")

# ---- Spark function stand-ins
def concat(*a): return None if any(x is None for x in a) else ''.join(str(x) for x in a)
def node_reference(space, xid): return None if xid is None else xid
def to_date(s):
    if s is None: return None
    try: return datetime.date.fromisoformat(str(s)[:10]).isoformat()
    except ValueError: return None
def to_timestamp(s):
    if s is None: return None
    return datetime.datetime.fromisoformat(str(s)).isoformat(timespec='seconds')
def initcap(s): return None if s is None else ' '.join(w[:1].upper() + w[1:].lower() for w in s.split(' '))
class CollectSet:
    def __init__(self): self.v = set()
    def step(self, x):
        if x is not None: self.v.add(x)
    def finalize(self): return '|'.join(sorted(self.v))
con.create_function('concat', -1, concat)
con.create_function('node_reference', 2, node_reference)
con.create_function('to_date', 1, to_date)
con.create_function('to_timestamp', 1, to_timestamp)
con.create_function('initcap', 1, initcap)
con.create_aggregate('collect_set', 1, CollectSet)

# ---- load RAW (all values are strings, as in CDF RAW)
rows = list(csv.reader(open(RAWCSV, encoding='utf-8')))
hdr = ['key'] + rows[0][1:]
con.execute('CREATE TABLE kiz_scopes.list_of_scopes (' + ', '.join(f'`{h}` TEXT' for h in hdr) + ')')
con.executemany(f'INSERT INTO kiz_scopes.list_of_scopes VALUES ({",".join("?" * len(hdr))})', rows[1:])

def run(sql):
    sql = re.sub(r'cast\(NULL AS (string|date)\)', 'NULL', sql)
    cur = con.execute(sql)
    cols = [d[0] for d in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]

def v3(name, kind='nodes'):
    p = os.path.join(V3, kind, name + '.csv')
    return list(csv.DictReader(open(p, encoding='utf-8'))) if os.path.exists(p) else []

def norm(v):
    if v is None or v == '': return None
    s = str(v)
    s = re.sub(r'^(\d{4}-\d{2}-\d{2})[ T](\d{2}:\d{2}:\d{2})$', r'\1T\2', s)
    return s

RENAME = {'EwpPerson': {'id': 'personId'}, 'EwpDocumentRevision': {'documentRef': 'belongsToDocument'}}
REL_FROM_EDGES = {  # SQL property -> (v3 edge file, filter on startNode prefix)
 'EwpWorkScope': ['belongsToProject', 'locatedInArea', 'hasSplitBase', 'belongsToSubsystem', 'documentedBy',
                  'iwpDocumentedBy', 'responsibleFor', 'createdBy', 'modifiedBy'],
 'EwpSubsystem': ['belongsToSystem'], 'EwpGateReview': ['belongsToScope'], 'EwpInspectionAssessment':
 ['belongsToScope', 'inspectsDiscipline'], 'EwpComment': ['commentsOn']}

report = collections.OrderedDict(); total_diff = 0
files = sorted(glob.glob(os.path.join(MOD, 'transformations', '[0-9][0-9]_*.Transformation.sql')))
for f in files:
    view = None
    y = open(f.replace('.sql', '.yaml'), encoding='utf-8').read()
    view = re.search(r'externalId: (Ewp\w+)', y).group(1)
    out = run(open(f, encoding='utf-8').read())
    ref = {r['externalId']: r for r in v3(view)}
    got = {r['externalId']: r for r in out}
    diffs = collections.Counter(); examples = []
    dup = len(out) - len(got)
    missing = set(ref) - set(got); extra = set(got) - set(ref)
    ren = RENAME.get(view, {})
    for xid in set(ref) & set(got):
        for k, v in ref[xid].items():
            k2 = ren.get(k, k)
            if k2 == 'externalId' or k2 not in got[xid]: continue
            if norm(v) != norm(got[xid][k2]):
                diffs[k2] += 1
                if len(examples) < 5: examples.append((xid, k2, v, got[xid][k2]))
    # relations: compare SQL direct-relation values with v3 edge files
    for rel in REL_FROM_EDGES.get(view, []):
        exp = {}
        for e in v3(rel, 'edges'):
            if e['startNode'] in got or e['startNode'] in ref: exp[e['startNode']] = e['endNode']
        act = {xid: r[rel] for xid, r in got.items() if r.get(rel)}
        if exp != act:
            bad = [(k, exp.get(k), act.get(k)) for k in set(exp) | set(act) if exp.get(k) != act.get(k)]
            diffs['relation ' + rel] += len(bad); examples += bad[:3]
    n = sum(diffs.values()) + len(missing) + len(extra) + dup
    total_diff += n
    report[view] = {'sql_rows': len(out), 'v3_rows': len(ref), 'duplicate_ids': dup, 'missing': len(missing),
                    'extra': len(extra), 'value_diffs': dict(diffs), 'examples': examples[:6]}

# contextualization check that runs on RAW alone
ctx = run(open(glob.glob(os.path.join(MOD, 'transformations', 'contextualization', '01_*.sql'))[0], encoding='utf-8').read())
report['ctx_scope_context_checks'] = {
    'rows': len(ctx),
    'projectCheck': dict(collections.Counter(r['projectCheck'] for r in ctx)),
    'systemCheck': dict(collections.Counter(r['systemCheck'] for r in ctx))}
with open(os.path.join(os.path.dirname(MOD.rstrip('/')), '..', 'scope_context_checks.csv'), 'w', newline='', encoding='utf-8') as fh:
    wr = csv.DictWriter(fh, fieldnames=list(ctx[0].keys())); wr.writeheader(); wr.writerows(ctx)
print(json.dumps(report, indent=1, default=str))
print('TOTAL DIFFERENCES:', total_diff)
