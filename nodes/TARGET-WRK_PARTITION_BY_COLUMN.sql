@id("d8656e95-dba7-4287-a49c-ec854f6091c0")
@nodeType("SQLWork")
@description("Work test - column-level bare @partitionBy on the DATE column O_ORDERDATE")
@tableExpiration("2026-12-31")
SELECT
    `O_ORDERKEY`                    AS `O_ORDERKEY`,
    `O_CUSTKEY`                     AS `O_CUSTKEY`,
    `O_ORDERSTATUS`                 AS `O_ORDERSTATUS`,
    CAST(`O_TOTALPRICE` AS NUMERIC) AS `O_TOTALPRICE`,
    `O_ORDERDATE`                   AS `O_ORDERDATE`     @partitionBy,
    `O_ORDERPRIORITY`               AS `O_ORDERPRIORITY`
FROM {{ ref('SRC', 'orders') }} `orders`
