@id("fe2f30d6-1800-4350-afd5-4cd3f9a978cf")
@nodeType("SQLFact")
@materializationType("table")
@description("QA partition - ingestion time, monthly, BigQuery's own form: TIMESTAMP_TRUNC(_PARTITIONTIME, MONTH); plain insert, truncateInsert")
@writeMode("truncateInsert")
@partitionBy("TIMESTAMP_TRUNC(_PARTITIONTIME, MONTH)")
@partitionExpirationDays("400")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("e2a001"),
    CAST(`F`.`n_NationKey` * 10 AS NUMERIC)  AS `AMOUNT`              @id("e2a002")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
