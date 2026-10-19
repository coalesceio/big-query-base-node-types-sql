@id("c18a26be-e127-4b94-b9bc-c7c4590dc280")
@nodeType("SQLDimension")
@description("Dimension test - column @clusterKey on O_CUSTKEY (1) and O_ORDERSTATUS (2); changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
SELECT
    CAST("0" AS STRING)                  AS `DIM_CLUSTER_KEY_KEY` @id("f70001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`          @id("f70002") @isBusinessKey,
    `O_CUSTKEY`                          AS `O_CUSTKEY`           @id("f70003") @clusterKey(1),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`       @id("f70004") @clusterKey(2),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`        @id("f70005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`         @id("f70006"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`     @id("f70007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`  @id("f70008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`  @id("f70009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
