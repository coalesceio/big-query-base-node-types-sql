@id("df3d6196-3d3f-4bc1-bf84-3d50f2319b60")
@nodeType("SQLDimension")
@description("PartitionBy test - node-level partition by a plain DATE column name O_ORDERDATE; upsert")
@mergeStrategy("upsert")
@partitionBy("O_ORDERDATE")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NODE_DATE_COLUMN_KEY` @id("d30001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                             AS `O_ORDERKEY`           @id("d30002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                              AS `O_CUSTKEY`@id("d30003"),
    `O_ORDERSTATUS`                          AS `O_ORDERSTATUS`@id("d30004"),
    `O_TOTALPRICE`                           AS `O_TOTALPRICE`@id("d30005"),
    `O_ORDERDATE`                            AS `O_ORDERDATE`@id("d30006"),
    `O_ORDERPRIORITY`                        AS `O_ORDERPRIORITY`@id("d30007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d30008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d30009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
