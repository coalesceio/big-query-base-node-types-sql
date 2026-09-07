@id("15b11388-4b5f-4edc-b816-f541c1280090")
@nodeType("705")
@writeMode("append")
SELECT
     `O_ORDERKEY` AS `O_ORDERKEY`,
     `O_CUSTKEY` AS `O_CUSTKEY`,
     `O_ORDERSTATUS` AS `O_ORDERSTATUS`,
     `O_TOTALPRICE` AS `O_TOTALPRICE`,
     `O_ORDERDATE` AS `O_ORDERDATE`,
     `O_ORDERPRIORITY` AS `O_ORDERPRIORITY`,
     `GH_COL1` AS `GH_COL1`
FROM {{ ref('TARGET', 'wrk_orders_v1_view') }} `wrk_orders_v1_view`