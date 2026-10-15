@id("e014de6a-4ed6-4dd7-9e15-70332f8ff9cc")
@nodeType("SQLFact")
@materializationType("table")
@description("QA partition - monthly on a DATETIME column (not in the definitions): DATETIME_TRUNC(Loaded_Dt, MONTH); upsert")
@mergeStrategy("upsert")
@partitionBy("DATETIME_TRUNC(Loaded_Dt, MONTH)")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("e6a001") @isBusinessKey,
    CAST(DATETIME(`F`.`last_Modified`) AS DATETIME) AS `Loaded_Dt`    @id("e6a002")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
