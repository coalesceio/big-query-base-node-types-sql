@id("35819892-5665-471d-814d-cc365479d8b4")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - lastModified SCD1, node-level TIMESTAMP_TRUNC partition, relative table expiration, tags (phase 2: renamed from QA_FCT_LM - expiration and tags must carry over)")
@mergeStrategy("lastModified")
@partitionBy("TIMESTAMP_TRUNC(last_Modified, DAY)")
@tableExpiration("90")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> 1 + (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
@tests("SELECT 1 FROM {{ this }} WHERE (`n_NationKey` = 1 AND `n_Name` <> 'ARGENTINA') OR (`n_NationKey` = 3 AND `n_Name` <> 'CANADA_V2')")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("f3a001") @isBusinessKey,
    `F`.`n_Name`                             AS `n_Name`              @id("f3a002"),
    CAST(`F`.`n_RegionKey` * 100 AS NUMERIC) AS `AMOUNT`              @id("f3a003"),
    `F`.`last_Modified`                      AS `last_Modified`       @id("f3a004") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f3a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("f3a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
