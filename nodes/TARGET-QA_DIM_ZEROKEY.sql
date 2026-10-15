@id("376a40a5-a378-4ed9-9a83-1ac517920ec9")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - zero key record (node defaults + column overrides) on an INT64 surrogate key with a non-UUID default (must only warn)")
@zeroKey("-1", "'UNKNOWN'", "1900-01-01 00:00:00", "false")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} WHERE `QA_DIM_ZEROKEY_KEY` = -1 HAVING COUNT(*) <> 1")
@tests("SELECT 1 FROM {{ this }} WHERE `QA_DIM_ZEROKEY_KEY` = -1 AND NOT (`n_NationKey` = -1 AND `n_Name` = 'NO NATION' AND `n_RegionKey` = -99 AND `n_Comment` = 'UNKNOWN' AND `IS_KNOWN_REGION` = FALSE)")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> 2 + (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
@tests("SELECT 1 FROM {{ this }} WHERE `QA_DIM_ZEROKEY_KEY` = -1 AND `Region_Label` IS DISTINCT FROM 'NONE'")
SELECT
    CAST(0 AS INT64)                         AS `QA_DIM_ZEROKEY_KEY`  @id("d6a000") @isSurrogateKey @defaultValue("0"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("d6a001") @isBusinessKey @clusterKey(1) @zeroKey("-1"),
    `F`.`n_Name`                             AS `n_Name`              @id("d6a002") @zeroKey("'NO NATION'"),
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("d6a003") @zeroKey("-99"),
    `F`.`n_Comment`                          AS `n_Comment`           @id("d6a004"),
    `F`.`n_RegionKey` <> -1                  AS `IS_KNOWN_REGION`     @id("d6a005"),
    CAST(DATE(`F`.`last_Modified`) AS DATE)  AS `LOAD_DATE`           @id("d6a006"),
    CAST(CONCAT('R', CAST(`F`.`n_RegionKey` AS STRING)) AS STRING) AS `Region_Label` @id("d6a00a") @zeroKey("'NONE'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d6a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d6a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
