@id("2184690d-6dcb-4268-bdef-81d795de2317")
@nodeType("705")
@writeMode("append")
@tests("SELECT 1 FROM {{ this }} GROUP BY N_NATIONKEY HAVING COUNT(*) > 1")
@tests("SELECT 1 FROM {{ this }} WHERE N_REGIONKEY IS NULL", true, "Before")
@description("Nation staging table")
@preSQL("DELETE FROM {{ this }} WHERE L_M_1 < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY` @not_null @uniqueness @min_value("0") @max_value("100") @accepted_values("1") @inHash("GH_COL1", 2) @description("Nation key"),
     `N_NAME` AS `N_NAME` @not_null @empty @accepted_values("'ALGERIA'") @accepted_values("'ARGENTINA'") @inHash("GH_COL1", 1) @description("Nation name"),
     `N_REGIONKEY` AS `N_REGIONKEY` @min_max("0", "4")  @defaultValue("20") @description("Region key"),
     `N_COMMENT` AS `N_COMMENT` @rejected_values("'NA'") @description("Free-text comment"),
     `last_modified` AS `L_M_1` @freshness(7, "DAY") @relative_time("<", "L_M_2") @description("timestamp column"),
     `last_modified` AS `L_M_2`,
     CAST({{ get_hash('GH_COL1') }} AS STRING) AS `GH_COL1` @description("Hash Column")
FROM {{ ref('SRC', 'nation') }} `nation`