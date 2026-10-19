@id("8eed608d-752e-4ce3-bff2-0aa0f7e9a3cb")
@nodeType("SQLWork")
@description("Work test - node-level @partitionBy with an expression: monthly partitions on O_ORDERDATE")
@partitionBy("DATE_TRUNC(O_ORDERDATE, MONTH)")
SELECT
    `O_ORDERKEY`                    AS `O_ORDERKEY`,
    `O_CUSTKEY`                     AS `O_CUSTKEY`,
    `O_ORDERSTATUS`                 AS `O_ORDERSTATUS`,
    CAST(`O_TOTALPRICE` AS NUMERIC) AS `O_TOTALPRICE`,
    `O_ORDERDATE`                   AS `O_ORDERDATE`,
    `O_ORDERPRIORITY`               AS `O_ORDERPRIORITY`
FROM {{ ref('SRC', 'orders') }} `orders`
