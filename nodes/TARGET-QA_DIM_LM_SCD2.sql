@id("23438459-ff26-4c79-adc4-e18b8caa1e06")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - lastModified SCD2, explicit append, cluster on the business key, before-load duplicate key check")
@mergeStrategy("lastModified")
@writeMode("append")
@tests("SELECT `n_NationKey` FROM {{ ref('TARGET', 'QA_WRK_FEED') }} GROUP BY `n_NationKey` HAVING COUNT(*) > 1 OR `n_NationKey` IS NULL", false, "Before")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `n_NationKey` HAVING COUNT(*) > 1")
@tests("SELECT `n_NationKey` FROM {{ this }} WHERE `n_NationKey` IN (1, 3) GROUP BY `n_NationKey` HAVING COUNT(*) <> IF(`n_NationKey` = 3, 2, 1)")
SELECT
    CAST('0' AS STRING)                      AS `QA_DIM_LM_SCD2_KEY`  @id("d4a000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("d4a001") @isBusinessKey @clusterKey(1),
    `F`.`n_Name`                             AS `n_Name`              @id("d4a002"),
    CAST(`F`.`n_RegionKey` AS NUMERIC)       AS `n_RegionKey`         @id("d4a003"),
    `F`.`last_Modified`                      AS `last_Modified`       @id("d4a004") @lastModifiedTracking("2"),
    1                                        AS `SYSTEM_VERSION`      @id("d4a005") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("d4a006") @isSystemCurrentFlag,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("d4a007") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d4a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d4a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
