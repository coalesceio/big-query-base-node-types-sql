@id("b989e33e-d021-4634-94a7-94fceeae057b")
@nodeType("SQLWork")
@description("Work test - multiple primary keys")
SELECT
    `O_ORDERKEY`                    AS `O_ORDERKEY`      @primaryKey(1),
    `O_CUSTKEY`                     AS `O_CUSTKEY`       @primaryKey(2),      
    `O_ORDERSTATUS`                 AS `O_ORDERSTATUS`,
    CAST(`O_TOTALPRICE` AS NUMERIC) AS `O_TOTALPRICE`,
    `O_ORDERDATE`                   AS `O_ORDERDATE`,
    `O_ORDERPRIORITY`               AS `O_ORDERPRIORITY`
FROM {{ ref('SRC', 'orders') }} `orders`
