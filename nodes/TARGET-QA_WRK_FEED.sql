@id("180ee444-003f-40b1-83d8-54e53d45d91e")
@nodeType("SQLWork")
@materializationType("table")
@description("QA feed over SRC.Nation_Test_CamelCase (mixed-case column names), one row per key. The CHANGES CTE is edited in each test phase to simulate source updates, inserts and deletes.")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) = 0", false, "After")
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
    -- Phase 2: key 1 renamed (last_Modified unchanged), key 2 comment changed, key 3 renamed + last_Modified bumped a day,
    --          key 5 moved to region 3, key 24 deleted, key 99 added
    SELECT
        `B`.`n_NationKey`                                                                            AS `n_NationKey`,
        CASE `B`.`n_NationKey` WHEN 1 THEN 'ARGENTINA_V2' WHEN 3 THEN 'CANADA_V2' ELSE `B`.`n_Name` END AS `n_Name`,
        CASE WHEN `B`.`n_NationKey` = 5 THEN 3 ELSE `B`.`n_RegionKey` END                            AS `n_RegionKey`,
        CASE WHEN `B`.`n_NationKey` = 2 THEN 'comment changed in phase 2' ELSE `B`.`n_Comment` END   AS `n_Comment`,
        CASE WHEN `B`.`n_NationKey` = 3 THEN TIMESTAMP_SECONDS(UNIX_SECONDS(`B`.`last_Modified`) + 86400) ELSE `B`.`last_Modified` END AS `last_Modified`
    FROM `BASE` `B`
    WHERE `B`.`n_NationKey` <> 24
    UNION ALL
    SELECT 99, 'NEW_NATION', 2, 'added in phase 2', TIMESTAMP_SECONDS(1790000000)
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
