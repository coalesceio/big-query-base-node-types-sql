@id("3c626c22-82b7-43ab-9837-a4dc41884a00")
@nodeType("SQLDimension")
@description("Combined test - tableExpiration, tags, defaultRoundingMode together with partitionBy, partitionExpirationDays, primary/cluster keys, tests, pre/post SQL; changeTracking SCD Type 2")
@mergeStrategy("changeTracking")
@tableExpiration("2027-12-31 23:59:59")
@tag("env", "dev")
@tag("cost_center", "finance")
@defaultRoundingMode("ROUND_HALF_EVEN")
@partitionBy("DATE_TRUNC(O_ORDERDATE, MONTH)")
@partitionExpirationDays(36500)
@preSQL("SELECT 1")
@postSQL("SELECT 1")
@tests("SELECT O_ORDERKEY FROM `cls-dev-bigquery`.`DE_TGT`.`DIM_ALL_OPTIONS` WHERE SYSTEM_CURRENT_FLAG = 'Y' GROUP BY O_ORDERKEY HAVING COUNT(*) > 1", true, "After")
SELECT
    CAST("0" AS STRING)                      AS `DIM_ALL_OPTIONS_KEY` @id("ab0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                             AS `O_ORDERKEY`          @id("ab0002") @isBusinessKey @primaryKey(1) @not_null,
    `O_CUSTKEY`                              AS `O_CUSTKEY`           @id("ab0003") @clusterKey(1) @not_null,
    `O_ORDERSTATUS`                          AS `O_ORDERSTATUS`       @id("ab0004") @isChangeTracking @clusterKey(2) @accepted_values("'F'") @accepted_values("'O'") @accepted_values("'P'"),
    CAST(`O_TOTALPRICE` AS NUMERIC)          AS `O_TOTALPRICE`        @id("ab0005") @min_value("0"),
    `O_ORDERDATE`                            AS `O_ORDERDATE`         @id("ab0006") @not_null,
    `O_ORDERPRIORITY`                        AS `O_ORDERPRIORITY`     @id("ab0007"),
    1                                        AS `SYSTEM_VERSION`      @id("ab0008") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("ab0009") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("ab000a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("ab000b") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("ab000c") @isSystemEndDate
FROM {{ ref('SRC', 'orders') }} `orders`
