@id("856a308a-8000-4e10-8364-fed8e708449a")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - plain insert (no merge strategy, no business key), explicit append, column DATE partition + expiration, cluster")
@writeMode("append")
@partitionExpirationDays("365")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` = (SELECT MAX(`SYSTEM_CREATE_DATE`) FROM {{ this }}) HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("f1a001") @clusterKey(1),
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("f1a002") @clusterKey(2),
    CAST(DATE(`F`.`last_Modified`) AS DATE)  AS `EVENT_DATE`          @id("f1a004") @partitionBy @min_max("DATE '2026-01-01'", "CURRENT_DATE()"),
    CAST('repro' AS STRING)                  AS `Repro_Col`           @id("f1a009"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f1a008") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
