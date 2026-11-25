# Kiz-C EWP: two Toolkit versions

Both versions load the same 99 columns into the same 13 EWP views with the same 13 load transformations.
They differ in naming and in **what the EWP records are contextualized against**.

| | `kizc_ewp_cdm` | `kizc_ewp_cfihos` |
|---|---|---|
| Built on | Cognite Core Data Model (CDM) | CDM, as a domain extension next to Cognite's CFIHOS oil and gas package (`cfihos_oil_and_gas_extension`, CFIHOS 2.0 / ISO 14224) |
| Prerequisite | None | CFIHOS package deployed first (`cdf modules add -d cfihos_oil_and_gas_extension`) |
| Schema space | `sp_kizc_ewp_model` | `dm_dom_kizc_ewp` (package convention `dm_dom_*`) |
| Instance space | `sp_kizc_ewp_instances` (own) | `inst_location` (shared with the package, as it recommends) |
| Data model | `KizcEwp` v1 | `dm_kizc_ewp_domain_model` v1, which also exposes the CFIHOS `Tag` and `Files` views |
| Systems / subsystems link to | `CogniteAsset` (`asset`) | CFIHOS `Tag` (`tag`) |
| Documents and revisions link to | NEO Document / Revision bridge views (`neoDocument`, `neoRevision`) | CFIHOS `Files` (`file`), which flattens document, revision and file |
| Projects link to | IFS_Site (`ifsSite`) | Site / plant `Tag` (`siteTag`) |
| Areas link to | IFS_Location (`ifsLocation`) | Area / functional-location `Tag` (`locationTag`) |
| Inspection disciplines | EWP codes only | Plus `cfihosDisciplineCode` / `cfihosDisciplineName` from a mapping table |
| Contextualization transformations | 7 | 8 |

## Shared structure (both versions)

```
kizc_ewp_<profile>/
├── cdf.toml                 default organization dir and environment
├── config.dev.yaml          environment, selected modules, variables
├── .env.example             credentials and group source IDs
├── modules/kizc_ewp/
│   ├── auth/                owner and reader groups (module-scoped access)
│   ├── data_modeling/       space, containers/, views/, data model
│   ├── data_sets/           ds_kizc_ewp
│   ├── raw/                 RAW databases and tables (.Database.yaml, .Table.yaml)
│   ├── transformations/     01-13 load, contextualization/ 01-08
│   └── default.config.yaml  module variable defaults
├── upload_data/             RAW data and mapping tables with manifests, for `cdf data upload dir`
└── scripts/entity_match.py  entity matching proposals (not a Toolkit resource)
```

## Gaps fixed from the previous version

- RAW databases now have `.Database.yaml` files.
- `auth/` added with module-scoped owner and reader groups.
- The script and seed CSVs moved out of the module (`scripts/`, `upload_data/`).
- `cdf.toml`, `config.dev.yaml` and `.env.example` added at the organization level.
- Data modeling file suffixes are lowercase (`.space.yaml`, `.container.yaml`, `.view.yaml`, `.datamodel.yaml`),
  as in the Toolkit resource library.

## Validation

All 13 load transformations were run locally against the 99-column RAW file in both versions and compared with the
independent Python build. The only differences are the same 6 system names, which the SQL fills in correctly.

## What I could not confirm

- **CFIHOS property names:** the public docs for the package don't list the property names on `Files` and `Tag`. Document number
  and revision on `Files` are variables in `config.dev.yaml` (`files_document_number_property`,
  `files_revision_property`). Check them in your deployed package before running contextualization 02 and 03.
- **CFIHOS discipline codes:** they come from your CFIHOS reference data library, so the mapping table is left blank to fill in.
- **Access group scopes:** the scopes (`datasetScope` with a data set external ID, `tableScope`) should be checked with `cdf build`.
- **Variables in SQL files:** check whether your Toolkit version substitutes `{{ }}` variables inside `.sql` files. If it
  doesn't, replace them by hand in the contextualization SQL.
