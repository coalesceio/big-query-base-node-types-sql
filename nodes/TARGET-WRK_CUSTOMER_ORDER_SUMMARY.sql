@id("dda17a32-4f52-4be5-b249-89fad3904159")
@nodeType("705")
@description("Customer order summary: aggregates the V1 order/lineitem fact by customer, enriched with customer geography from the V1 dimension layer. Capstone V2 node on top of the V1 star schema.")
WITH order_amounts AS (
    SELECT DISTINCT
        `CUSTOMER_KEY`,
        `ORDER_KEY`,
        `ORDER_TOTAL_PRICE`
    FROM {{ ref('TARGET', 'FCT_ORDER_LINEITEM') }}
),
customer_avg AS (
    SELECT
        `CUSTOMER_KEY`,
        AVG(`ORDER_TOTAL_PRICE`) AS AVG_ORDER_AMOUNT
    FROM order_amounts
    GROUP BY `CUSTOMER_KEY`
)
SELECT
    c.`CUSTOMER_KEY` AS `CUSTOMER_KEY` @description("Customer business key"),
    c.`CUSTOMER_NAME` AS `CUSTOMER_NAME` @description("Customer name"),
    nr.`NATION_NAME` AS `NATION_NAME` @description("Customer's nation"),
    nr.`REGION_NAME` AS `REGION_NAME` @description("Customer's region"),
    COUNT(DISTINCT f.`ORDER_KEY`) AS `ORDER_COUNT` @description("Distinct orders placed by this customer"),
    SUM(f.`LINE_QUANTITY`) AS `TOTAL_QUANTITY` @description("Total quantity ordered across all lineitems"),
    SUM(f.`LINE_EXTENDED_PRICE` * (1 - f.`LINE_DISCOUNT`)) AS `TOTAL_REVENUE` @description("Total revenue after discount across all lineitems"),
    ca.`AVG_ORDER_AMOUNT` AS `AVG_ORDER_AMOUNT_PER_CUSTOMER` @description("Average order total price across this customer's orders, computed once per customer (not skewed by lineitem count)")
FROM {{ ref('TARGET', 'FCT_ORDER_LINEITEM') }} f
JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} c ON f.`CUSTOMER_KEY` = c.`CUSTOMER_KEY`
JOIN {{ ref('TARGET', 'DIM_NATION_REGION') }} nr ON c.`NATION_KEY` = nr.`NATION_KEY`
JOIN customer_avg ca ON f.`CUSTOMER_KEY` = ca.`CUSTOMER_KEY`
GROUP BY c.`CUSTOMER_KEY`, c.`CUSTOMER_NAME`, nr.`NATION_NAME`, nr.`REGION_NAME`, ca.`AVG_ORDER_AMOUNT`
