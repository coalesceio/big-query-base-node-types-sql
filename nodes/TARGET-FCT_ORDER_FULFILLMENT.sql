@id("1d251d2f-94f5-466e-a91b-50e33a887985")
@nodeType("SQLFact")
@description("Pipeline - fulfillment fact: lastModified SCD Type 1 on the last receipt date; table expiration as an expression (raises a warning)")
@mergeStrategy("lastModified")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 365 DAY)")
@partitionBy("DATE_TRUNC(ORDER_DATE, YEAR)")
SELECT
    `o`.`ORDER_KEY`                                                           AS `ORDER_KEY`          @id("c40001") @isBusinessKey @not_null @uniqueness,
    `o`.`ORDER_DATE`                                                          AS `ORDER_DATE`         @id("c40002") @relative_time("<=", "FIRST_SHIP_DATE"),
    `l`.`FIRST_SHIP_DATE`                                                     AS `FIRST_SHIP_DATE`    @id("c40003"),
    `l`.`LAST_RECEIPT_DATE`                                                   AS `LAST_RECEIPT_DATE`  @id("c40004") @lastModifiedTracking @not_null,
    CAST(DATE_DIFF(`l`.`FIRST_SHIP_DATE`, `o`.`ORDER_DATE`, DAY) AS INT64)    AS `DAYS_TO_SHIP`       @id("c40005") @min_value("0"),
    CAST(DATE_DIFF(`l`.`LAST_RECEIPT_DATE`, `o`.`ORDER_DATE`, DAY) AS INT64)  AS `DAYS_TO_DELIVER`    @id("c40006") @min_max("0", "365"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                                      AS `SYSTEM_CREATE_DATE` @id("c40007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                                      AS `SYSTEM_UPDATE_DATE` @id("c40008") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_ORDERS') }} `o`
INNER JOIN {{ ref('TARGET', 'WRK_LINEITEM_AGG') }} `l`
    ON `o`.`ORDER_KEY` = `l`.`ORDER_KEY`
