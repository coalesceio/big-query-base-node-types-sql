@id("a3eb8efe-0850-4990-a97c-81678a18779e")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA zero key - STRING(5) column with the default 'UNKNOWN' (7 chars): expect Warning: Zero Key Value Too Long, then the Zero Key Record stage fails")
@zeroKey("-1")
SELECT
    CAST(0 AS INT64)                         AS `ZK5_KEY`             @id("z5a000") @isSurrogateKey @defaultValue("0"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("z5a001") @isBusinessKey,
    CAST(SUBSTR(`F`.`n_Name`, 1, 5) AS STRING(5)) AS `Short_Name`     @id("z5a002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("z5a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("z5a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
