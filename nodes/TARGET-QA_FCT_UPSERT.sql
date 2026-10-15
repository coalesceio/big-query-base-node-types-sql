@id("49869e7e-fb49-40d4-b059-89939e1b3c63")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - upsert, create date only (kept on update); lastModifiedTracking present only to raise the ignored warning")
@mergeStrategy("upsert")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("f4a001") @isBusinessKey,
    `F`.`n_Name`                             AS `n_Name`              @id("f4a002"),
    CAST(`F`.`n_RegionKey` + 0.5 AS NUMERIC) AS `AMOUNT`              @id("f4a003"),
    `F`.`last_Modified`                      AS `last_Modified`       @id("f4a004") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f4a008") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
