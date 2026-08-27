@id("f602cfcd-87c3-432e-acbf-b6fd8cd05189")
@nodeType("705")
@testsEnabled
@truncateBefore
@description("Nation Key ''dfhadj")
@tests("SELECT 1 FROM {{ this }}")
@tests("SELECT 2 FROM {{ this }}", "Before", true)
@tests("SELECT 3 FROM {{ this }}", "After", true)
@tests("SELECT 4 FROM {{ this }}", "After", true)
@preSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 1")
@postSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 2")
@preSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 3")
@postSQL("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 4")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY` @tests("unique") @inHash("GH_COL1", 2) @defaultValue("0"),
     `N_NAME` AS `N_NAME` @description("Name") @inHash("GH_COL2", 1) @deafultValue("'NA'"),
     `N_REGIONKEY` AS `N_REGIONKEY` @tests("null") @tests("unique") @inHash("GH_COL1", 1) @inHash("GH_COL2", 2),
     `N_COMMENT` AS `N_COMMENT` @description("'Nation Comment'"),
     CAST({{ get_hash('GH_COL1') }} AS STRING) AS "GH_COL1" @description("Hash Column"),
     CAST({{ get_hash('GH_COL2') }}AS STRING) AS "GH_COL2",
     CAST(1.11 AS FLOAT64) AS "AREA",
     CAST(CONCAT(N_NAME, '_TEST') AS STRING) AS N_NAME_CAPS  @tests("unique>") @description("Adde COl")
FROM {{ ref('SRC', 'nation') }} `nation`