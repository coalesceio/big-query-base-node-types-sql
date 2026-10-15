@id("7d25ddd5-8e66-4527-867a-aba21486ffd0")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - default strategy (changeTracking with no tracked column = SCD1), UUID surrogate key, fixed datetime expiration, rounding, tag, cluster, PK")
@tableExpiration("2027-12-31 23:59:59")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
@tests("SELECT 1 FROM {{ this }} GROUP BY `N_NATIONKEY` HAVING COUNT(*) > 1")
SELECT
    CAST('0' AS STRING)                      AS `QA_DIM_CT_SCD1_KEY`  @id("d1a000") @isSurrogateKey @defaultValue("GENERATE_UUID()") @not_null @uniqueness @description("Surrogate key - filled by the GENERATE_UUID() default"),
    `F`.`N_NATIONKEY`                        AS `N_NATIONKEY`         @id("d1a001") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness,
    `F`.`N_NAME`                             AS `N_NAME`              @id("d1a002") @clusterKey(2),
    `F`.`N_REGIONKEY`                        AS `N_REGIONKEY`         @id("d1a003") @min_max("-1", "4"),
    `F`.`N_COMMENT`                          AS `N_COMMENT`           @id("d1a004") @defaultValue("'NA'"),
    CAST(`F`.`N_NATIONKEY` * 1.25 AS NUMERIC) AS `N_SCORE`            @id("d1a005") @min_value("0"),
    `F`.`LAST_MODIFIED`                      AS `LAST_MODIFIED`       @id("d1a006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d1a007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d1a008") @isSystemUpdateDate @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
