@id("f4fca686-9faa-41f8-b194-1b9eb8e0840f")
@nodeType("705")
@testsEnabled
@tests("SELECT 1 FROM {{ this }}")
@tests("SELECT 2 FROM {{ this }}", "Before", true)
@tests("SELECT 3 FROM {{ this }}", "After")
@tests("SELECT 4 FROM {{ this }}", "After", false)
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY` @description("Nation'' Key") @tests("unique") @inHash("GH_COL1", 2),
     `N_NAME` AS `N_NAME` @description("Name") @inHash("GH_COL2", 1),
     `N_REGIONKEY` AS `N_REGIONKEY` @tests("null") @tests("unique") @inHash("GH_COL1", 1) @inHash("GH_COL2", 2),
     `N_COMMENT` AS `N_COMMENT` @description("'Nation Comment'"),
     `last_modified` AS `last_modified` @tests("null"),
     CAST({{ get_hash('GH_COL1') }} AS STRING) AS "GH_COL1",
     CAST({{ get_hash('GH_COL2') }}AS STRING) AS "GH_COL2"
FROM {{ ref('SRC', 'nation') }} `nation`