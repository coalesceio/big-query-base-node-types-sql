@id("e899ecb9-1bde-4423-8e04-213a09d0f1f5")
@nodeType("SQLDimension")
@description("Dimension test - column-level bare @partitionBy on the DATE column O_ORDERDATE; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
SELECT
    CAST("0" AS STRING)                  AS `DIM_PARTITION_BY_COLUMN_KEY` @id("f80001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`                  @id("f80002") @isBusinessKey,
    `O_CUSTKEY`                          AS `O_CUSTKEY`                   @id("f80003"),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`               @id("f80004"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`                @id("f80005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`                 @id("f80006") @partitionBy,
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`             @id("f80007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`          @id("f80008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`          @id("f80009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
