@id("527833b0-2da7-4fad-9afe-f23e3637c35d")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA zero key - ARRAY, STRUCT and GEOGRAPHY columns with the node-level defaults (no type match: written as NULL)")
@zeroKey("-1")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} WHERE `ZK4_KEY` = -1 HAVING COUNT(*) <> 1")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK4_KEY` = -1 AND NOT (ARRAY_LENGTH(`Arr_Col`) = 0 AND `Struct_Col` IS NULL AND `Geo_Col` IS NULL)")
SELECT
    CAST(0 AS INT64)                         AS `ZK4_KEY`             @id("z4a000") @isSurrogateKey @defaultValue("0"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("z4a001") @isBusinessKey,
    CAST([`F`.`n_Name`] AS ARRAY<STRING>)    AS `Arr_Col`             @id("z4a002"),
    CAST(STRUCT(`F`.`n_Name` AS `nm`, `F`.`n_RegionKey` AS `rk`) AS STRUCT<`nm` STRING, `rk` INT64>) AS `Struct_Col` @id("z4a003"),
    CAST(ST_GEOGPOINT(CAST(`F`.`n_NationKey` AS FLOAT64), 0) AS GEOGRAPHY) AS `Geo_Col` @id("z4a004"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("z4a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("z4a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
