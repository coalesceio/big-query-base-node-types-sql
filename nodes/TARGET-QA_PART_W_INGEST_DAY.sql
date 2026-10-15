@id("c1ef4945-658f-40a0-9539-d801a90483d1")
@nodeType("SQLWork")
@materializationType("table")
@description("QA partition - ingestion time, daily: _PARTITIONDATE, with partition expiration")
@partitionBy("_PARTITIONDATE")
@partitionExpirationDays("30")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`,
    `F`.`n_Name`                             AS `n_Name`
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
