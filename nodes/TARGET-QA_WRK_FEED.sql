@id("180ee444-003f-40b1-83d8-54e53d45d91e")
@nodeType("SQLWork")
@materializationType("table")
@description("QA feed over SRC.nation, one row per key. The CHANGES CTE is edited in each test phase to simulate source updates, inserts and deletes.")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) = 0", false, "After")
WITH `BASE` AS (
    SELECT
        `nation`.`N_NATIONKEY`                                                               AS `N_NATIONKEY`,
        `nation`.`N_NAME`                                                                    AS `N_NAME`,
        COALESCE(`nation`.`N_REGIONKEY`, -1)                                                 AS `N_REGIONKEY`,
        `nation`.`N_COMMENT`                                                                 AS `N_COMMENT`,
        TIMESTAMP_SECONDS(1767225600 + `nation`.`N_NATIONKEY` * 3600)                        AS `LAST_MODIFIED`
    FROM {{ ref('SRC', 'nation') }} `nation`
    WHERE TRUE
    QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
),
`CHANGES` AS (
    -- Phase 1: the source as-is
    SELECT `B`.* FROM `BASE` `B`
)
SELECT
    CAST(`C`.`N_NATIONKEY` AS INT64)        AS `N_NATIONKEY`    @notNull @not_null @uniqueness @min_value("1") @inHash("NK_HASH", 1) @description("Nation key, unique after de-duplication"),
    CAST(`C`.`N_NAME` AS STRING)            AS `N_NAME`         @not_null @empty @inHash("ROW_HASH", 1),
    CAST(`C`.`N_REGIONKEY` AS INT64)        AS `N_REGIONKEY`    @accepted_values("-1, 0, 1, 2") @accepted_values("3, 4") @min_max("-1", "4") @inHash("ROW_HASH", 2),
    CAST(`C`.`N_COMMENT` AS STRING)         AS `N_COMMENT`      @rejected_values("'DELETED'") @inHash("ROW_HASH", 3),
    CAST(`C`.`LAST_MODIFIED` AS TIMESTAMP)  AS `LAST_MODIFIED`  @not_null @freshness(365, "DAY") @max_value("CURRENT_TIMESTAMP()"),
    CAST({{ get_hash('NK_HASH') }} AS STRING) AS `NK_HASH`        @uniqueness,
    CAST({{ get_hash('ROW_HASH', 'MD5', '~') }} AS STRING) AS `ROW_HASH`       @not_null
FROM `CHANGES` `C`
