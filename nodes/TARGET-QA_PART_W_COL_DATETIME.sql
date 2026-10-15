@id("f3e7b935-216a-405e-a318-093888ab6757")
@nodeType("SQLWork")
@materializationType("table")
@description("QA partition - column-level @partitionBy on a DATETIME column (must render DATE(column))")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`,
    CAST(DATETIME(`F`.`last_Modified`) AS DATETIME) AS `Loaded_Dt`    @partitionBy
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
