@id("162c545d-6542-4639-a541-7e7bb97c4277")
@nodeType("SQLWork")
@materializationType("table")
@description("QA partition - hourly on a TIMESTAMP column: TIMESTAMP_TRUNC(last_Modified, HOUR), with partition expiration")
@partitionBy("TIMESTAMP_TRUNC(last_Modified, HOUR)")
@partitionExpirationDays("400")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`,
    `F`.`last_Modified`                      AS `last_Modified`
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
