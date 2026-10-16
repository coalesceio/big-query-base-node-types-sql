@id("adee61d6-6ef7-47d3-b87e-2d7170eaa92f")
@nodeType("SQLDimension")
@materializationType("view")
@description("QA view - every table-only annotation set (all must be ignored on a view); relative expiration")
@mergeStrategy("lastModified")
@writeMode("truncateInsert")
@partitionExpirationDays("30")
@defaultRoundingMode("ROUND_HALF_EVEN")
@zeroKey("'-1'")
@preSQL("SELECT 1")
@postSQL("SELECT 1")
@tableExpiration("30")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ this }} WHERE `QA_VW_DIM_IGNORED_KEY` IS NOT NULL OR `SYSTEM_CREATE_DATE` IS NOT NULL")
SELECT
    CAST('0' AS STRING)                      AS `QA_VW_DIM_IGNORED_KEY` @id("v2a000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("v2a001") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @zeroKey("-1"),
    `F`.`n_Name`                             AS `n_Name`              @id("v2a002") @isChangeTracking @defaultValue("'NA'"),
    CAST(DATE(`F`.`last_Modified`) AS DATE)  AS `Load_Date`           @id("v2a003") @partitionBy,
    `F`.`last_Modified`                      AS `last_Modified`       @id("v2a004") @lastModifiedTracking("2"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("v2a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("v2a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
