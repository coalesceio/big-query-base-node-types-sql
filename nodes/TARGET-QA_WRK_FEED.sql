@id("180ee444-003f-40b1-83d8-54e53d45d91e")
@nodeType("SQLWork")
@materializationType("table")
@description("QA feed over SRC.Nation_Test_CamelCase (mixed-case column names), one row per key. The CHANGES CTE is edited in each test phase to simulate source updates, inserts and deletes.")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) = 0", false, "After")
WITH `BASE` AS (
    SELECT
        `SRC`.`n_NationKey`                  AS `n_NationKey`,
        `SRC`.`n_Name`                       AS `n_Name`,
        COALESCE(`SRC`.`n_RegionKey`, -1)    AS `n_RegionKey`,
        `SRC`.`n_Comment`                    AS `n_Comment`,
        `SRC`.`last_Modified`                AS `last_Modified`
    FROM {{ ref('SRC', 'Nation_Test_CamelCase') }} `SRC`
    WHERE TRUE
    QUALIFY ROW_NUMBER() OVER (PARTITION BY `SRC`.`n_NationKey` ORDER BY `SRC`.`last_Modified` DESC) = 1
),
`CHANGES` AS (
    -- Phase 1: the source as-is
    SELECT `B`.* FROM `BASE` `B`
)
SELECT
    CAST(`C`.`n_NationKey` AS INT64)        AS `n_NationKey`    @clusterKey(1) @notNull @not_null @uniqueness @min_value("1") @inHash("NK_HASH", 1) @description("Nation key, unique after de-duplication"),
    CAST(`C`.`n_Name` AS STRING)            AS `n_Name`         @not_null @empty @inHash("ROW_HASH", 1),
    CAST(`C`.`n_RegionKey` AS INT64)        AS `n_RegionKey`    @accepted_values("-1, 0, 1, 2") @accepted_values("3, 4") @min_max("-1", "4") @inHash("ROW_HASH", 2),
    CAST(`C`.`n_Comment` AS STRING)         AS `n_Comment`      @rejected_values("'DELETED'") @inHash("ROW_HASH", 3),
    CAST(`C`.`last_Modified` AS TIMESTAMP)  AS `last_Modified`  @not_null @freshness(365, "DAY") @max_value("CURRENT_TIMESTAMP()"),
    CAST({{ get_hash('NK_HASH') }} AS STRING) AS `NK_HASH`      @uniqueness,
    CAST({{ get_hash('ROW_HASH', 'MD5', '~') }} AS STRING) AS `ROW_HASH` @not_null
FROM `CHANGES` `C`
