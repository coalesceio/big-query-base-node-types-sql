@id("09af93a6-8b9b-4269-8082-b625a9db9d1f")
@nodeType("SQLFact")
@description("Pipeline - order fact: orders joined to their line-item totals and the current customer / order status dimensions; changeTracking SCD Type 1, monthly partitions")
@writeMode("append")
@mergeStrategy("changeTracking")
@partitionBy("DATE_TRUNC(ORDER_DATE, MONTH)")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `o`.`ORDER_KEY`                                                          AS `ORDER_KEY`            @id("c10001") @isBusinessKey @primaryKey(1) @not_null @uniqueness,
    CAST(COALESCE(`c`.`DIM_CUSTOMER_KEY`, '0') AS STRING)                    AS `CUSTOMER_SK`          @id("c10002") @clusterKey(1) @not_null,
    CAST(COALESCE(`s`.`DIM_ORDER_STATUS_KEY`, '0') AS STRING)                AS `ORDER_STATUS_SK`      @id("c10003") @clusterKey(2) @not_null,
    `o`.`ORDER_DATE`                                                         AS `ORDER_DATE`           @id("c10004") @not_null,
    `o`.`ORDER_PRIORITY`                                                     AS `ORDER_PRIORITY`       @id("c10005") @accepted_values("'1-URGENT', '2-HIGH', '3-MEDIUM', '4-NOT SPECIFIED', '5-LOW'"),
    `o`.`TOTAL_PRICE`                                                        AS `TOTAL_PRICE`          @id("c10006") @min_value("0"),
    CAST(COALESCE(`l`.`LINE_COUNT`, 0) AS INT64)                             AS `LINE_COUNT`           @id("c10007") @min_value("0"),
    CAST(COALESCE(`l`.`NET_AMOUNT`, 0) AS NUMERIC)                           AS `NET_AMOUNT`           @id("c10008") @min_value("0"),
    CAST(COALESCE(`l`.`GROSS_AMOUNT` - `l`.`NET_AMOUNT`, 0) AS NUMERIC)      AS `DISCOUNT_AMOUNT`      @id("c10009") @min_value("0"),
    CAST(COALESCE(`l`.`RETURNED_LINES`, 0) AS INT64)                         AS `RETURNED_LINES`       @id("c1000a") @min_value("0"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                                     AS `SYSTEM_CREATE_DATE`   @id("c1000b") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                                     AS `SYSTEM_UPDATE_DATE`   @id("c1000c") @isSystemUpdateDate @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'WRK_ORDERS') }} `o`
LEFT JOIN {{ ref('TARGET', 'WRK_LINEITEM_AGG') }} `l`
    ON `o`.`ORDER_KEY` = `l`.`ORDER_KEY`
LEFT JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `c`
    ON `o`.`CUSTOMER_KEY` = `c`.`CUSTOMER_KEY`
   AND `c`.`SYSTEM_CURRENT_FLAG` = 'Y'
LEFT JOIN {{ ref('TARGET', 'DIM_ORDER_STATUS') }} `s`
    ON `o`.`ORDER_STATUS` = `s`.`ORDER_STATUS`
