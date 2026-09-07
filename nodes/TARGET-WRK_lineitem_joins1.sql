@id("c541671f-7c7f-4de2-b3c1-b62b01586756")
@nodeType("705")
SELECT
     `NATION` AS `NATION`,
     `REGION` AS `REGION`,
     `CUSTOMER_COUNT` AS `CUSTOMER_COUNT`,
     `ORDER_COUNT` AS `ORDER_COUNT`
FROM {{ ref('TARGET', 'WRK_lineitem_joins') }} `WRK_lineitem_joins`