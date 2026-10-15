@id("332ae012-a731-4fc0-86b4-353157b842ce")
@nodeType("SQLDimension")
@description("PartitionBy NEGATIVE test - @partitionBy on the node AND on a column; create should stop (one partition per table)")
@mergeStrategy("changeTracking")
@partitionBy("DATE_TRUNC(O_ORDERDATE, MONTH)")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NEG_NODE_AND_COLUMN_KEY` @id("dd0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                             AS `O_ORDERKEY`           @id("dd0002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                              AS `O_CUSTKEY`            @id("dd0003"),
    `O_ORDERSTATUS`                          AS `O_ORDERSTATUS`        @id("dd0004"),
    `O_TOTALPRICE`                           AS `O_TOTALPRICE`         @id("dd0005"),
    `O_ORDERDATE`                            AS `O_ORDERDATE`          @id("dd0006"),
    `O_ORDERPRIORITY`                        AS `O_ORDERPRIORITY`      @id("dd0007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("dd0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("dd0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
