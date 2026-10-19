@id("6ce7bf5d-1cf6-4fa1-b8e4-282ae81e2471")
@nodeType("SQLFact")
@description("Pipeline - order event fact: no business key, so a plain insert (truncateInsert); events joined to the date dimension, partitioned by event date (column-level); tests disabled")
@writeMode("truncateInsert")
@disableTests
SELECT
    `e`.`ORDER_KEY`                                 AS `ORDER_KEY`      @id("c20001") @not_null,
    `e`.`EVENT_TYPE`                                AS `EVENT_TYPE`     @id("c20002") @clusterKey(1),
    `e`.`EVENT_SEQUENCE`                            AS `EVENT_SEQUENCE` @id("c20003"),
    `e`.`EVENT_DATE`                                AS `EVENT_DATE`     @id("c20004") @partitionBy,
    CAST(COALESCE(`d`.`DIM_DATE_KEY`, '0') AS STRING) AS `DATE_SK`      @id("c20005") @clusterKey(2),
    `d`.`IS_WEEKEND`                                AS `IS_WEEKEND`     @id("c20006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)            AS `LOADED_AT`      @id("c20007")
FROM {{ ref('TARGET', 'WRK_ORDER_EVENTS') }} `e`
LEFT JOIN {{ ref('TARGET', 'DIM_DATE') }} `d`
    ON `e`.`EVENT_DATE` = `d`.`DATE_KEY`
