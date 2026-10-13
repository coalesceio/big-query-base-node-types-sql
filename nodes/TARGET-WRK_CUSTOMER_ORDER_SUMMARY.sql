@id("bd778aa9-47f7-481f-bfdb-733e023b7794")
@nodeType("705")
@description("Annotation test - CTE join of orders, lineitem, customer, nation and region aggregated per customer")
@writeMode("truncateInsert")
@tests("SELECT 1 FROM {{ this }} GROUP BY C_CUSTKEY HAVING COUNT(*) > 1", false)
@tests("SELECT 1 FROM {{ this }} WHERE ORDER_COUNT <= 0")
@postSQL("UPDATE {{ this }} SET R_NAME = TRIM(R_NAME) WHERE R_NAME IS NOT NULL")
WITH ORDER_LINES AS (
    SELECT
        `o`.`O_ORDERKEY`,
        `o`.`O_CUSTKEY`,
        `o`.`O_ORDERDATE`,
        SUM(`l`.`L_EXTENDEDPRICE` * (1 - `l`.`L_DISCOUNT`)) AS `NET_REVENUE`,
        COUNT(*) AS `LINE_COUNT`
    FROM {{ ref('SRC', 'orders') }} `o`
    INNER JOIN {{ ref('SRC', 'lineitem') }} `l` ON `l`.`L_ORDERKEY` = `o`.`O_ORDERKEY`
    GROUP BY `o`.`O_ORDERKEY`, `o`.`O_CUSTKEY`, `o`.`O_ORDERDATE`
),
CUSTOMER_ORDERS AS (
    SELECT
        `O_CUSTKEY`,
        COUNT(*) AS `ORDER_COUNT`,
        SUM(`LINE_COUNT`) AS `LINE_COUNT`,
        SUM(`NET_REVENUE`) AS `NET_REVENUE`,
        MIN(`O_ORDERDATE`) AS `FIRST_ORDER_DATE`,
        MAX(`O_ORDERDATE`) AS `LAST_ORDER_DATE`
    FROM ORDER_LINES
    GROUP BY `O_CUSTKEY`
)
SELECT
    `c`.`C_CUSTKEY`                              AS `C_CUSTKEY`        @id("bd7701") @notNull @not_null @uniqueness @inHash("HK_CUSTOMER", 1),
    `c`.`C_NAME`                                 AS `C_NAME`           @id("bd7702") @empty,
    `c`.`C_MKTSEGMENT`                           AS `C_MKTSEGMENT`     @id("bd7703") @rejected_values("'UNKNOWN'"),
    `n`.`N_NAME`                                 AS `N_NAME`           @id("bd7704") @not_null,
    `r`.`R_NAME`                                 AS `R_NAME`           @id("bd7705") @accepted_values("'AFRICA'") @accepted_values("'AMERICA'") @accepted_values("'ASIA'") @accepted_values("'EUROPE'") @accepted_values("'MIDDLE EAST'"),
    `co`.`ORDER_COUNT`                           AS `ORDER_COUNT`      @id("bd7706") @min_value("1"),
    `co`.`LINE_COUNT`                            AS `LINE_COUNT`       @id("bd7707") @min_value("1"),
    CAST(`co`.`NET_REVENUE` AS NUMERIC)          AS `NET_REVENUE`      @id("bd7708") @min_value("0") @description("Sum of extended price net of discount"),
    `co`.`FIRST_ORDER_DATE`                      AS `FIRST_ORDER_DATE` @id("bd7709") @relative_time("<=", "LAST_ORDER_DATE"),
    `co`.`LAST_ORDER_DATE`                       AS `LAST_ORDER_DATE`  @id("bd770a"),
    CAST({{ get_hash('HK_CUSTOMER') }} AS STRING) AS `HK_CUSTOMER`     @id("bd770b") @not_null @uniqueness,
    CAST(CURRENT_TIMESTAMP() AS TIMESTAMP)       AS `LOAD_TS`          @id("bd770c") @freshness(1, "HOUR")
FROM CUSTOMER_ORDERS `co`
INNER JOIN {{ ref('SRC', 'customer') }} `c` ON `c`.`C_CUSTKEY` = `co`.`O_CUSTKEY`
INNER JOIN {{ ref('SRC', 'nation') }} `n` ON `n`.`N_NATIONKEY` = `c`.`C_NATIONKEY`
INNER JOIN {{ ref('SRC', 'region') }} `r` ON `r`.`R_REGIONKEY` = `n`.`N_REGIONKEY`
