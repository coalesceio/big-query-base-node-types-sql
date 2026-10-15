@id("3ee708cf-f0da-4949-8323-f7cb8d81af64")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA partition - corrected README SCD2 example: TIMESTAMP_TRUNC(SYSTEM_CREATE_DATE, MONTH); changeTracking SCD2")
@mergeStrategy("changeTracking")
@partitionBy("TIMESTAMP_TRUNC(SYSTEM_CREATE_DATE, MONTH)")
SELECT
    CAST('0' AS STRING)                      AS `QA_PART_D_TS_MONTH_KEY` @id("e7a000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("e7a001") @isBusinessKey,
    `F`.`n_Name`                             AS `n_Name`              @id("e7a002") @isChangeTracking,
    1                                        AS `SYSTEM_VERSION`      @id("e7a004") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("e7a005") @isSystemCurrentFlag,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("e7a006") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("e7a007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("e7a008") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
