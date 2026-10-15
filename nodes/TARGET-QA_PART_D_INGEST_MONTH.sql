@id("9b578542-a345-4770-ab6e-a73c01aba945")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA partition - ingestion time, monthly, as written in the definitions: DATE_TRUNC(_PARTITIONTIME, MONTH) (BigQuery stores TIMESTAMP_TRUNC); upsert")
@mergeStrategy("upsert")
@partitionBy("DATE_TRUNC(_PARTITIONTIME, MONTH)")
SELECT
    CAST('0' AS STRING)                      AS `QA_PART_D_INGEST_MONTH_KEY` @id("e1a000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("e1a001") @isBusinessKey,
    `F`.`n_Name`                             AS `n_Name`              @id("e1a002")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
