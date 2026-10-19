@id("1e8b9a71-810e-4c00-a4c9-ede591ed6c28")
@nodeType("SQLWork")
@description("Pipeline - view: revenue per customer (join + GROUP BY), tagged and with a table expiration")
@materializationType("view")
@tag("env", "dev")
@tag("cost_center", "finance")
@tableExpiration("2027-12-31")
SELECT
    `c`.`CUSTOMER_KEY`                          AS `CUSTOMER_KEY`,
    `c`.`CUSTOMER_NAME`                         AS `CUSTOMER_NAME`,
    `c`.`MARKET_SEGMENT`                        AS `MARKET_SEGMENT`,
    `c`.`REGION_NAME`                           AS `REGION_NAME`,
    CAST(COUNT(`o`.`ORDER_KEY`) AS INT64)       AS `ORDER_COUNT`,
    CAST(SUM(`o`.`TOTAL_PRICE`) AS NUMERIC)     AS `TOTAL_REVENUE`
FROM {{ ref('TARGET', 'WRK_CUSTOMER') }} `c`
LEFT JOIN {{ ref('TARGET', 'WRK_ORDERS') }} `o`
    ON `c`.`CUSTOMER_KEY` = `o`.`CUSTOMER_KEY`
GROUP BY 1, 2, 3, 4
