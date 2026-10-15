@id("b894f845-2aa8-4ccd-873a-0045feb4baa7")
@nodeType("SQLDimension")
@description("PartitionBy NEGATIVE test - column-level @partitionBy given a parameter (it takes none); create should stop")
@mergeStrategy("changeTracking")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NEG_COL_WITH_PARAM_KEY` @id("e00001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                             AS `O_ORDERKEY`           @id("e00002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                              AS `O_CUSTKEY`            @id("e00003"),
    `O_ORDERSTATUS`                          AS `O_ORDERSTATUS`        @id("e00004"),
    `O_TOTALPRICE`                           AS `O_TOTALPRICE`         @id("e00005"),
    `O_ORDERDATE`                            AS `O_ORDERDATE`          @id("e00006") @partitionBy("MONTH"),
    `O_ORDERPRIORITY`                        AS `O_ORDERPRIORITY`      @id("e00007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("e00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("e00009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
