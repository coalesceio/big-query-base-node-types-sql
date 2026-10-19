@id("561d575c-1fec-45ed-9bb6-122e8903d557")
@nodeType("SQLDimension")
@description("Pipeline - customer dimension: changeTracking SCD Type 2 on market segment and account balance, zero key record, clustered by segment and region")
@writeMode("append")
@mergeStrategy("changeTracking")
@zeroKey("'0'", "'UNKNOWN'", "1900-01-01 00:00:00", true)
@defaultRoundingMode("ROUND_HALF_EVEN")
@tableExpiration("2027-12-31 23:59:59")
@tag("cost_center", "finance")
SELECT
    CAST("0" AS STRING)                      AS `DIM_CUSTOMER_KEY`    @id("b20001") @isSurrogateKey @defaultValue("GENERATE_UUID()") @primaryKey(1) @uniqueness,
    `c`.`CUSTOMER_KEY`                       AS `CUSTOMER_KEY`        @id("b20002") @isBusinessKey @not_null,
    `c`.`CUSTOMER_NAME`                      AS `CUSTOMER_NAME`       @id("b20003") @empty,
    `c`.`MARKET_SEGMENT`                     AS `MARKET_SEGMENT`      @id("b20004") @isChangeTracking @clusterKey(1) @accepted_values("'AUTOMOBILE', 'BUILDING', 'FURNITURE', 'HOUSEHOLD', 'MACHINERY'") @accepted_values("'UNKNOWN'"),
    `c`.`ACCOUNT_BALANCE`                    AS `ACCOUNT_BALANCE`     @id("b20005") @isChangeTracking @min_max("-1000", "10000"),
    `c`.`NATION_NAME`                        AS `NATION_NAME`         @id("b20006"),
    `c`.`REGION_NAME`                        AS `REGION_NAME`         @id("b20007") @clusterKey(2),
    `c`.`CUSTOMER_HASH`                      AS `CUSTOMER_HASH`       @id("b20008"),
    1                                        AS `SYSTEM_VERSION`      @id("b20009") @isSystemVersion @min_value("1"),
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("b2000a") @isSystemCurrentFlag @accepted_values("'Y', 'N'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("b2000b") @isSystemCreateDate @relative_time("<=", "SYSTEM_END_DATE"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("b2000c") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("b2000d") @isSystemEndDate
FROM {{ ref('TARGET', 'WRK_CUSTOMER') }} `c`
