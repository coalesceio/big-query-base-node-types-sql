@id("e3f401a5-29f5-46e2-8a0d-62b5e564a8f2")
@nodeType("SQLWork")
@description("Pipeline - staging: orders, partitioned by order date (column-level), with pre/post SQL and node tests")
@writeMode("truncateInsert")
@disableTests(false)
@tests("SELECT x FROM UNNEST([1, 2, 3]) AS x WHERE x IS NULL", true, "Before")
@tests("SELECT x FROM UNNEST([1, 2, 3]) AS x WHERE x > 3", true, "After")
@preSQL("SELECT 'WRK_ORDERS pre-load' AS STEP")
@postSQL("SELECT 'WRK_ORDERS post-load' AS STEP")
SELECT
    `O_ORDERKEY`                    AS `ORDER_KEY`      @primaryKey(1) @not_null @uniqueness,
    `O_CUSTKEY`                     AS `CUSTOMER_KEY`   @not_null @min_value("1"),
    `O_ORDERSTATUS`                 AS `ORDER_STATUS`   @accepted_values("'F'", "'O'", "'P'"),
    -- DE_SRC.orders stores this as FLOAT64
    CAST(`O_TOTALPRICE` AS NUMERIC) AS `TOTAL_PRICE`    @min_value("0"),
    `O_ORDERDATE`                   AS `ORDER_DATE`     @partitionBy @not_null @max_value("DATE '2099-12-31'"),
    `O_ORDERPRIORITY`               AS `ORDER_PRIORITY` @empty,
    `O_CLERK`                       AS `CLERK`,
    `O_SHIPPRIORITY`                AS `SHIP_PRIORITY`
FROM {{ ref('SRC', 'orders') }} `orders`
