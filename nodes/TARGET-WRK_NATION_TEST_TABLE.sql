@id("f602cfcd-87c3-432e-acbf-b6fd8cd05189")
@nodeType("705")
@description("Nation Key ''dfhadj")
@tests("SELECT 1 FROM {{ this }}")
@tests("SELECT 2 FROM {{ this }}", true, "Before")
@tests("SELECT 3 FROM {{ this }}", true, "After")
@tests("SELECT 4 FROM {{ this }}", true, "After")
@preSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 1")
@postSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 2")
@preSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 3")
@postSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 4")
SELECT DISTINCT
     `N_NATIONKEY` AS `N_nATIONKEY` @uniqueness @inHash("GH_COL1", 2),
     `N_NATIONKEY` AS `N_nATIONKEY_smallCase` @uniqueness @inHash("GH_COL1", 2) @defaultValue("0"),
     `N_NAME` AS `N_NAME` @inHash("GH_COL2", 1) @defaultValue("'NA'"),
     `N_REGIONKEY` @not_null @uniqueness @inHash("GH_COL1", 1) @inHash("GH_COL2", 2),
     `N_COMMENT` AS `N_COMMENT` @description("'Nation Comment'"),
     CAST(CONCAT(N_NAME, '_TEST') AS STRING) AS N_NAME_CAPS  @uniqueness @description("Adde COl"),
     CAST({{ get_hash("GH_COL1") }} AS STRING) AS `GH_COL1` @description("Hash Column"),
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE `N_NATIONKEY` = {{ parameters.nationkey }}