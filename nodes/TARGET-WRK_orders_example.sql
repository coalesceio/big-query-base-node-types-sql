@id("ae922c97-fbf7-4ff5-b7c0-cb533c4074c0")
@nodeType("705")
@disableTests
SELECT
     CAST(`order_id` AS INT64) AS `order_id`,
    CAST(item.PRODUCT_ID AS INT64) AS PRODUCT_ID,
    CAST(item.QUANTITY AS INT64) AS QUANTITY
FROM {{ ref('SRC', 'orders_example') }} `orders_example`
CROSS JOIN UNNEST(line_items) AS item;