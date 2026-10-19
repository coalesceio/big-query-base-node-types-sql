@id("ae916b7b-26c7-4e72-8cc0-6ea0761f313e")
@nodeType("SQLDimension")
@description("Dimension test - node-level @partitionBy with an expression: monthly partitions on O_ORDERDATE; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@partitionBy("DATE_TRUNC(O_ORDERDATE, MONTH)")
SELECT
    CAST("0" AS STRING)                  AS `DIM_PARTITION_BY_NODE_KEY` @id("f10001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`                @id("f10002") @isBusinessKey,
    `O_CUSTKEY`                          AS `O_CUSTKEY`                 @id("f10003"),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`             @id("f10004"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`              @id("f10005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`               @id("f10006"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`           @id("f10007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`        @id("f10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`        @id("f10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
