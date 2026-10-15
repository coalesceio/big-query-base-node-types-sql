@id("e9713712-7656-4d8e-b044-7ffb29f4c0ee")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - allColumnMatch factless fact; business key present only to raise the ignored warning")
@mergeStrategy("allColumnMatch")
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_NationKey`, `n_RegionKey`, `n_Name` HAVING COUNT(*) > 1")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("f5a001") @isBusinessKey,
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("f5a002"),
    `F`.`n_Name`                             AS `n_Name`              @id("f5a003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f5a008") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
