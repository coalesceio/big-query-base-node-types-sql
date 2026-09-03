@id("f6db96d5-97b3-4876-9570-c8f87a19036a")
@nodeType("705")
SELECT
     `order_id` AS `order_id`,
    F.product_id AS PRODUCT_ID,
    F.quantity AS QUANTITY
FROM {{ ref('SRC', 'orders_example') }} `orders_example`,
UNNEST(S.line_items) AS F;
