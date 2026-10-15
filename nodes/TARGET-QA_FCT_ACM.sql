@id("e9713712-7656-4d8e-b044-7ffb29f4c0ee")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - allColumnMatch factless fact; business key present only to raise the ignored warning")
@mergeStrategy("allColumnMatch")
@tests("SELECT 1 FROM {{ this }} GROUP BY `N_NATIONKEY`, `N_REGIONKEY`, `N_NAME` HAVING COUNT(*) > 1")
SELECT
    `F`.`N_NATIONKEY`                        AS `N_NATIONKEY`         @id("f5a001") @isBusinessKey,
    `F`.`N_REGIONKEY`                        AS `N_REGIONKEY`         @id("f5a002"),
    `F`.`N_NAME`                             AS `N_NAME`              @id("f5a003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f5a008") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
