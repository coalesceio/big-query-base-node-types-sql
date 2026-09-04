@id("7986e87a-1377-4bdb-9fec-fa0575d17834")
@nodeType("705")
@writeMode("append")
@tests("SELECT 1 FROM {{ this }}")
@tests("SELECT 2 FROM {{ this }}", true, "Before")
@description("Table description")
@preSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 1")
@postSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 2")
SELECT ALL
     `N_NATIONKEY` AS `N_NATIONKEY` @uniqueness @min_value("0") @max_value("100")  @accepted_values("1") @inHash("GH_COL1", 2) @defaultValue("10") @description("primary column"),
     `N_NAME` AS `N_NAME` @empty @accepted_values("'ALGERIA'") @accepted_values("'ARGENTINA'") @inHash("GH_COL1", 1),
     `N_REGIONKEY` AS `N_REGIONKEY` @min_max("0", "4"),
     `N_COMMENT` AS `N_COMMENT` @rejected_values("'NA'") @not_null @defaultValue("'20'"),
     `last_modified` AS L_M_1 @freshness(7, "DAY") @relative_time("<", "L_M_2") @description("timestamp column"),
     `last_modified` AS L_M_2,
     `N_NAME` AS N_NAME_1 @notNull,
     CAST({{ get_hash('GH_COL1') }} AS STRING) AS `GH_COL1` @description("Hash Column"),
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE N_REGIONKEY IS NOT NULL