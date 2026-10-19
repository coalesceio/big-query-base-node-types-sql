@id("3f2579a4-9890-46aa-9a18-eb74fb9f81b3")
@nodeType("SQLWork")
@description("Work test - column @clusterKey on O_CUSTKEY (1) and O_ORDERSTATUS (2)")
SELECT
    `O_ORDERKEY`                    AS `O_ORDERKEY`,
    `O_CUSTKEY`                     AS `O_CUSTKEY`       @clusterKey(1),
    `O_ORDERSTATUS`                 AS `O_ORDERSTATUS`,
    CAST(`O_TOTALPRICE` AS NUMERIC) AS `O_TOTALPRICE`,
    `O_ORDERDATE`                   AS `O_ORDERDATE`,
    `O_ORDERPRIORITY`               AS `O_ORDERPRIORITY`
FROM {{ ref('SRC', 'orders') }} `orders`
