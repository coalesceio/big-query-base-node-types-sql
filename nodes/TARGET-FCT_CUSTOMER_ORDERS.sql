@id("44be4919-48e0-4d60-b0ca-cb3aed9905e7")
@nodeType("SQLFact")
@materializationType("table")
@description("Fact 3 - per-customer order summary from FCT_ORDERS and DIM_CUSTOMER: lastModified SCD1 on the latest order date")
@mergeStrategy("lastModified")
@writeMode("append")
@tag("env", "dev")
@tests("SELECT 1 FROM {{ this }} GROUP BY `C_CUSTKEY` HAVING COUNT(*) > 1", false)
WITH CUSTOMER_ORDERS AS (
    SELECT
        `o`.`O_CUSTKEY`,
        COUNT(*)              AS `ORDER_COUNT`,
        SUM(`o`.`O_TOTALPRICE`) AS `TOTAL_SPEND`,
        MIN(`o`.`O_ORDERDATE`)  AS `FIRST_ORDER_DATE`,
        MAX(`o`.`O_ORDERDATE`)  AS `LAST_ORDER_DATE`
    FROM {{ ref('TARGET', 'FCT_ORDERS') }} `o`
    GROUP BY `o`.`O_CUSTKEY`
)
SELECT
    `co`.`O_CUSTKEY`                       AS `C_CUSTKEY`          @id("44be01") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @description("Customer key - business key"),
    COALESCE(`dc`.`DIM_CUSTOMER_KEY`, '0') AS `DIM_CUSTOMER_KEY`   @id("44be02") @description("Current customer surrogate key"),
    `dc`.`C_MKTSEGMENT`                    AS `C_MKTSEGMENT`       @id("44be03") @description("Current market segment"),
    `dc`.`R_NAME`                          AS `R_NAME`             @id("44be04") @description("Current region name"),
    `co`.`ORDER_COUNT`                     AS `ORDER_COUNT`        @id("44be05") @min_value("1") @description("Number of orders"),
    CAST(`co`.`TOTAL_SPEND` AS NUMERIC)    AS `TOTAL_SPEND`        @id("44be06") @min_value("0") @description("Sum of order total price"),
    `co`.`FIRST_ORDER_DATE`                AS `FIRST_ORDER_DATE`   @id("44be07") @relative_time("<=", "LAST_ORDER_DATE") @description("First order date"),
    `co`.`LAST_ORDER_DATE`                 AS `LAST_ORDER_DATE`    @id("44be08") @lastModifiedTracking @notNull @not_null @description("Latest order date - drives the lastModified merge"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)   AS `SYSTEM_CREATE_DATE` @id("44be09") @isSystemCreateDate @description("Row create time"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)   AS `SYSTEM_UPDATE_DATE` @id("44be0a") @isSystemUpdateDate @description("Row update time")
FROM CUSTOMER_ORDERS `co`
LEFT JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `dc`
    ON `dc`.`C_CUSTKEY` = `co`.`O_CUSTKEY`
   AND `dc`.`SYSTEM_CURRENT_FLAG` = 'Y'
