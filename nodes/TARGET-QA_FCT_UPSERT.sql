@id("49869e7e-fb49-40d4-b059-89939e1b3c63")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - upsert, create date only (kept on update); lastModifiedTracking present only to raise the ignored warning")
@mergeStrategy("upsert")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`N_NATIONKEY`                        AS `N_NATIONKEY`         @id("f4a001") @isBusinessKey,
    `F`.`N_NAME`                             AS `N_NAME`              @id("f4a002"),
    CAST(`F`.`N_REGIONKEY` + 0.5 AS NUMERIC) AS `AMOUNT`              @id("f4a003"),
    `F`.`LAST_MODIFIED`                      AS `LAST_MODIFIED`       @id("f4a004") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f4a008") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
