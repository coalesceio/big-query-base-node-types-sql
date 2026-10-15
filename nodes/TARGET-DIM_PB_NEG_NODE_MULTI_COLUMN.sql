@id("c6ca4e9d-b9b8-4fa8-8a9c-e17ca903a234")
@nodeType("SQLDimension")
@description("PartitionBy NEGATIVE test - node-level @partitionBy lists two columns (top-level comma); create should stop")
@mergeStrategy("upsert")
@partitionBy("O_ORDERDATE, O_CUSTKEY")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NEG_NODE_MULTI_COLUMN_KEY` @id("df0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                             AS `O_ORDERKEY`           @id("df0002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                              AS `O_CUSTKEY`@id("df0003"),
    `O_ORDERSTATUS`                          AS `O_ORDERSTATUS`@id("df0004"),
    `O_TOTALPRICE`                           AS `O_TOTALPRICE`@id("df0005"),
    `O_ORDERDATE`                            AS `O_ORDERDATE`@id("df0006"),
    `O_ORDERPRIORITY`                        AS `O_ORDERPRIORITY`@id("df0007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("df0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("df0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
