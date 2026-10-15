@id("6675c877-48b4-4c83-b636-a33d86bf6f69")
@nodeType("SQLFact")
@materializationType("view")
@description("QA Fact view - system columns become typed NULLs; merge/table annotations are ignored")
@mergeStrategy("upsert")
@tableExpiration("2027-06-30 12:00:00")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` IS NOT NULL")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("f6a001") @isBusinessKey @not_null,
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("f6a002") @clusterKey(1),
    CAST(`F`.`n_NationKey` * 2 AS NUMERIC)   AS `AMOUNT`              @id("f6a003") @max_value("1000"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f6a008") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
