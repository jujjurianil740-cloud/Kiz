# Kiz-C EWP Toolkit organization: CDM version

See `COMPARISON.md` for how this differs from the other version.

## Load transformations (run 01 to 13 in order)

| # | Writes | Rows |
|---|---|---|
| 01 | EwpProject | 2 |
| 02 | EwpScopeSplitBaseSubsystem | 6 |
| 03 | EwpArea | 5 |
| 04 | EwpInspectionDiscipline | 7 |
| 05 | EwpSystem | 60 |
| 06 | EwpSubsystem | 415 |
| 07 | EwpPerson | 11 |
| 08 | EwpDocument | 507 |
| 09 | EwpDocumentRevision | 686 |
| 10 | EwpWorkScope | 815 |
| 11 | EwpGateReview | 2,463 |
| 12 | EwpInspectionAssessment | 5,705 |
| 13 | EwpComment | 115 |

Relations are direct relations on the child record (D-047). Every view implements CDM `CogniteDescribable` and
`CogniteSourceable`. Load rules: error values become null, dates are `date` type (D-039), Scope Categorisation splits
into `scopeCategory` / `scopeStatus` (D-041), persons are merged with all spellings kept as aliases (D-030, D-032).

## Contextualization (run after the load)

| # | Links | Method |
|---|---|---|
| 01 | Scope document vs its own project and system (RAW `kizc_context.scope_context_checks`) | Rule-based, runs now |
| 02 | EwpDocument → NEO Document | Exact document number; placeholders marked |
| 03 | EwpDocumentRevision → NEO Revision | NEO document + revision code |
| 04 | EwpProject → IFS site | Mapping table `project_site_map` |
| 05 | EwpArea → IFS location | Mapping table `area_location_map` |
| 06 | EwpSystem → CogniteAsset | Entity matching, accepted by a reviewer |
| 07 | EwpSubsystem → CogniteAsset | Same |

## Deploy

1. Copy `.env.example` to `.env` and fill in credentials and group source IDs. Set `project` in `config.dev.yaml`.
2. Fill the NEO variables in `config.dev.yaml`.
3. `cdf build`, `cdf deploy --dry-run`, `cdf deploy`.
4. `cdf data upload dir upload_data` loads the scopes RAW table and the two mapping tables.
5. Run load transformations 01 to 13 in order, then contextualization 01.
6. Fill the mapping tables (target space and externalId), run contextualization 02 to 05.
7. Run `scripts/entity_match.py`, review `kizc_context.asset_match_candidates`, then run 06 and 07.

## Before production

- Preview each transformation in the CDF Transformations UI once before scheduling.
- Scopes are keyed on the Excel row number until the Smartsheet row ID is exported (D-044).
- 114 documents get no P1 / C1 revisions because their source values are `#NO MATCH`.
