@id("c5410c31-5ec3-41d5-a32d-f4878c14d599")
@nodeType("SQLDimension")
@description("PartitionBy test - node-level DATE_TRUNC(O_ORDERDATE, MONTH) + partitionExpirationDays; changeTracking SCD Type 2")
@mergeStrategy("changeTracking")
@partitionBy("DATE_TRUNC(O_ORDERDATE, MONTH)")
@partitionExpirationDays(36500)
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NODE_DATE_TRUNC_MONTH_KEY` @id("d40001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                             AS `O_ORDERKEY`           @id("d40002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                              AS `O_CUSTKEY`            @id("d40003"),
    `O_ORDERSTATUS`                          AS `O_ORDERSTATUS`        @id("d40004") @isChangeTracking,
    `O_TOTALPRICE`                           AS `O_TOTALPRICE`         @id("d40005"),
    `O_ORDERDATE`                            AS `O_ORDERDATE`          @id("d40006"),
    `O_ORDERPRIORITY`                        AS `O_ORDERPRIORITY`      @id("d40007"),
    1                                        AS `SYSTEM_VERSION`       @id("d40008") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`  @id("d40009") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d4000a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d4000b") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`      @id("d4000c") @isSystemEndDate
FROM {{ ref('SRC', 'orders') }} `orders`
