"""Propose EwpSystem / EwpSubsystem -> CogniteAsset matches with CDF entity matching.

Writes candidates to RAW kizc_context.asset_match_candidates with status 'proposed'. A reviewer sets status to
'accepted' or 'rejected' (RAW explorer or the entity matching UI). Then run the
system / subsystem contextualization transformations, which write only accepted rows.

Requires cognite-sdk and a configured CogniteClient. Check the entity matching section of the
cognite-sdk docs for your SDK version before running; signatures can change between releases.
"""
from cognite.client import CogniteClient
from cognite.client.data_classes.data_modeling import ViewId

SCHEMA, VER = "sp_kizc_ewp_model", "v1"
TARGET_VIEW = ViewId("cdf_cdm", "CogniteAsset", "v1")
SCORE_THRESHOLD = 0.75

client = CogniteClient()

def nodes(view, props):
    out = []
    for n in client.data_modeling.instances.list(instance_type="node", sources=[view], limit=None):
        p = n.properties[view]
        out.append({"id": f"{n.space}|{n.external_id}", **{k: str(p.get(k) or "") for k in props}})
    return out

targets = nodes(TARGET_VIEW, ["name", "description"])
for src_view, fields in [("EwpSystem", [("name", "name")]),
                         ("EwpSubsystem", [("name", "name"), ("name", "description")])]:
    sources = nodes(ViewId(SCHEMA, src_view, VER), ["name"])
    model = client.entity_matching.fit(sources=sources, targets=targets, match_fields=fields, feature_type="bigram")
    result = model.predict(sources=sources, targets=targets, num_matches=1, score_threshold=SCORE_THRESHOLD).result
    rows = {}
    for item in result["items"]:
        for m in item.get("matches", []):
            _, src_xid = item["source"]["id"].split("|", 1)
            tgt_space, tgt_xid = m["target"]["id"].split("|", 1)
            rows[src_xid] = {"sourceView": src_view, "sourceExternalId": src_xid,
                             "sourceName": item["source"].get("name"), "targetSpace": tgt_space,
                             "targetExternalId": tgt_xid, "targetName": m["target"].get("name"),
                             "score": m["score"], "status": "proposed"}
    client.raw.rows.insert("kizc_context", "asset_match_candidates", rows, ensure_parent=True)
    print(src_view, len(sources), "sources,", len(rows), "proposals")
