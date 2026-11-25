-- Contextualization: write reviewed EwpSubsystem -> CogniteAsset matches.
-- Candidates come from scripts/entity_match.py (or the CDF entity matching UI) in RAW kizc_context.asset_match_candidates.
-- Only rows a reviewer set to status = 'accepted' are written.
SELECT
  sourceExternalId AS externalId,
  node_reference(targetSpace, targetExternalId) AS asset,
  cast(score AS double) AS assetMatchScore,
  'accepted' AS assetMatchStatus
FROM `kizc_context`.`asset_match_candidates`
WHERE status = 'accepted' AND sourceView = 'EwpSubsystem'
