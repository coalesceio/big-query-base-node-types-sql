@id("26c13110-0da1-4cbe-990b-d891130adbc2")
@nodeType("705")
@description("Orders pass-through with a freshness test on O_ORDERDATE")
SELECT
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
