@id("e591f33a-4415-4a1b-b1ac-b06dfc72679e")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA zero key - a BYTES column with the node-level defaults (resolve_zero_key matches 'BYT' as numeric and writes 0)")
@zeroKey("-1")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} WHERE `ZK3_KEY` = -1 HAVING COUNT(*) <> 1")
SELECT
    CAST(0 AS INT64)                         AS `ZK3_KEY`             @id("z3a000") @isSurrogateKey @defaultValue("0"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("z3a001") @isBusinessKey,
    CAST(`F`.`n_Name` AS BYTES)              AS `Bytes_Col`           @id("z3a002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("z3a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("z3a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
