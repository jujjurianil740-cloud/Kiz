-- Internal contextualization check: does each scope's document agree with its own project and system?
-- Writes one row per scope to RAW kizc_context.scope_context_checks. Runs on the Smartsheet data alone.
-- Rule 1 (Q8): SO17104 = M-MONDO, SO17105 = S-SAXI.
-- Rule 2: EWP numbers SOnnnnn-ZGFsspnn carry the system code in characters 12-13 (for example SO17104-ZGF05008 -> 05).
SELECT
  `key` AS key,
  CASE WHEN trim(`Project Code`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`Project Code`) END AS projectCode,
  CASE WHEN trim(`L0 - Project`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L0 - Project`) END AS project,
  CASE WHEN trim(`System`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System`) END AS systemCode,
  CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END AS documentNumber,
  CASE
    WHEN CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END IS NULL THEN 'no document'
    WHEN substr(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, 1, 7) NOT IN ('SO17104', 'SO17105') THEN 'not an SO number'
    WHEN (substr(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, 1, 7) = 'SO17104' AND CASE WHEN trim(`L0 - Project`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L0 - Project`) END = 'M-MONDO')
      OR (substr(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, 1, 7) = 'SO17105' AND CASE WHEN trim(`L0 - Project`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`L0 - Project`) END = 'S-SAXI') THEN 'agrees'
    ELSE 'disagrees'
  END AS projectCheck,
  CASE
    WHEN CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END IS NULL OR substr(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, 9, 3) <> 'ZGF' THEN 'not a ZGF number'
    WHEN lower(substr(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, 12, 2)) = 'xx' OR lower(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END) LIKE '%xxx%' THEN 'placeholder'
    WHEN CASE WHEN trim(`System`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System`) END IS NULL THEN 'scope has no system'
    WHEN substr(CASE WHEN trim(`EWP Document Number`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`EWP Document Number`) END, 12, 2) = CASE WHEN trim(`System`) IN ('', '#NO MATCH', '#N/A', '#REF!', '#VALUE!') THEN NULL ELSE trim(`System`) END THEN 'agrees'
    ELSE 'disagrees'
  END AS systemCheck
FROM `kiz_scopes`.`list_of_scopes`
