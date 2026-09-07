@id("3d7d5493-9ef0-4507-a08e-48d2ddc282ff")
@nodeType("705")
@description("Orders pass-through with a freshness test on O_ORDERDATE")
SELECT ALL
    `O_ORDERKEY` AS `O_ORDERKEY`,
    `O_CUSTKEY` AS `O_CUSTKEY`,
    `O_ORDERSTATUS` AS `O_ORDERSTATUS`,
    `O_TOTALPRICE` AS `O_TOTALPRICE`,
    `O_ORDERDATE` AS `O_ORDERDATE` @description("Date the order was placed") @freshness(7, "DAY"),
    `O_ORDERPRIORITY` AS `O_ORDERPRIORITY`,
    `O_CLERK` AS `O_CLERK`,
    `O_SHIPPRIORITY` AS `O_SHIPPRIORITY`,
    `O_COMMENT` AS `O_COMMENT`
FROM {{ ref('SRC', 'orders') }}
