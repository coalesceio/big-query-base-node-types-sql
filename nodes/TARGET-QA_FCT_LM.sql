@id("35819892-5665-471d-814d-cc365479d8b4")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - lastModified SCD1, node-level TIMESTAMP_TRUNC partition, relative table expiration, tags")
@mergeStrategy("lastModified")
@partitionBy("TIMESTAMP_TRUNC(last_Modified, DAY)")
@tableExpiration("90")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("f3a001") @isBusinessKey,
    `F`.`n_Name`                             AS `n_Name`              @id("f3a002"),
    CAST(`F`.`n_RegionKey` * 100 AS NUMERIC) AS `AMOUNT`              @id("f3a003"),
    `F`.`last_Modified`                      AS `last_Modified`       @id("f3a004") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f3a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("f3a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
