@id("2385da2b-1218-411d-aff7-187fb9dd4b2c")
@nodeType("SQLWork")
@description("Pipeline - staging: line items aggregated per order (GROUP BY), integer-range partition on the order key")
@writeMode("truncateInsert")
@partitionBy("RANGE_BUCKET(ORDER_KEY, GENERATE_ARRAY(0, 60000000, 1000000))")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
SELECT
    `L_ORDERKEY`                                                                AS `ORDER_KEY`         @not_null @uniqueness,
    CAST(COUNT(*) AS INT64)                                                     AS `LINE_COUNT`        @min_value("1"),
    CAST(SUM(`L_QUANTITY`) AS NUMERIC)                                          AS `TOTAL_QUANTITY`    @min_value("0"),
    CAST(SUM(`L_EXTENDEDPRICE`) AS NUMERIC)                                     AS `GROSS_AMOUNT`      @min_value("0"),
    CAST(SUM(`L_EXTENDEDPRICE` * (1 - `L_DISCOUNT`)) AS NUMERIC)                AS `NET_AMOUNT`        @min_value("0"),
    CAST(COUNTIF(`L_RETURNFLAG` = 'R') AS INT64)                                AS `RETURNED_LINES`    @min_value("0"),
    CAST(MIN(`L_SHIPDATE`) AS DATE)                                             AS `FIRST_SHIP_DATE`   @relative_time("<=", "LAST_RECEIPT_DATE"),
    CAST(MAX(`L_RECEIPTDATE`) AS DATE)                                          AS `LAST_RECEIPT_DATE` @not_null
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
GROUP BY `L_ORDERKEY`
