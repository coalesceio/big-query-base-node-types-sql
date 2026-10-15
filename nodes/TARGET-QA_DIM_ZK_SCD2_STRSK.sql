@id("6a48def4-0f9a-48dc-be8b-f59918adb1f1")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA zero key - SCD2 with a STRING (UUID) surrogate key; the zero surrogate value is given as a quoted string ('ZERO-KEY') to test the documented STRING-key limitation")
@mergeStrategy("changeTracking")
@zeroKey("'ZERO-KEY'")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} WHERE `ZK2_KEY` = 'ZERO-KEY' HAVING COUNT(*) <> 1")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK2_KEY` = 'ZERO-KEY' AND NOT (`n_NationKey` = 0 AND `n_Name` = 'UNKNOWN' AND `SYSTEM_VERSION` = 1 AND `SYSTEM_CURRENT_FLAG` = 'Y' AND `SYSTEM_END_DATE` = TIMESTAMP '2999-12-31 00:00:00 UTC' AND `Is_Known` = TRUE AND `Loaded_On` = DATE '1900-01-01')")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK2_KEY` <> 'ZERO-KEY' AND NOT REGEXP_CONTAINS(`ZK2_KEY`, r'^[0-9a-f]{8}-[0-9a-f]{4}-')")
SELECT
    CAST('0' AS STRING)                      AS `ZK2_KEY`             @id("z2a000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("z2a001") @isBusinessKey,
    `F`.`n_Name`                             AS `n_Name`              @id("z2a002") @isChangeTracking,
    CAST(`F`.`n_RegionKey` >= 0 AS BOOL)     AS `Is_Known`            @id("z2a003"),
    CAST(DATE(`F`.`last_Modified`) AS DATE)  AS `Loaded_On`           @id("z2a004"),
    1                                        AS `SYSTEM_VERSION`      @id("z2a005") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("z2a006") @isSystemCurrentFlag,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("z2a007") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("z2a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("z2a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
