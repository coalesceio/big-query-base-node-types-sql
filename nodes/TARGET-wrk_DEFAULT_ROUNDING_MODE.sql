@id("e0002eed-7574-47cb-9120-e477e7291250")
@nodeType("SQLWork")
@description("Work test - @defaultRoundingMode ROUND_HALF_AWAY_FROM_ZERO on a table with a NUMERIC column")
SELECT
    `O_ORDERKEY`                    AS `O_ORDERKEY`,
    `O_CUSTKEY`                     AS `O_CUSTKEY`,
    `O_ORDERSTATUS`                 AS `O_ORDERSTATUS`,
    CAST(`O_TOTALPRICE` AS NUMERIC) AS `O_TOTALPRICE`,
    `O_ORDERDATE`                   AS `O_ORDERDATE`,
    `O_ORDERPRIORITY`               AS `O_ORDERPRIORITY`
FROM {{ ref('SRC', 'orders') }} `orders`
