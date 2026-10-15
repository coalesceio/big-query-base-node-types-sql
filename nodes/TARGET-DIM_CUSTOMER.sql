@id("6b8aac2b-48d1-48a1-89fb-0a0a3c2e3a71")
@nodeType("SQLDimension")
@materializationType("table")
@description("Dimension 3 - customer from WRK_CUSTOMER_GEO_V: changeTracking SCD Type 2 on address-like columns, zero key, partition on create date, clustering, tags, rounding mode")
@mergeStrategy("changeTracking")
@writeMode("append")
@zeroKey("'0'", "'UNKNOWN'", "1900-01-01 00:00:00", "true")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ ref('TARGET', 'WRK_CUSTOMER_GEO_V') }} GROUP BY `C_CUSTKEY` HAVING COUNT(*) > 1 OR `C_CUSTKEY` IS NULL", false, "Before")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `C_CUSTKEY` HAVING COUNT(*) > 1", false, "After")
SELECT
    CAST("0" AS STRING)                      AS `DIM_CUSTOMER_KEY`    @id("6b8a01") @isSurrogateKey @defaultValue("GENERATE_UUID()") @description("Surrogate key"),
    CAST(`C_CUSTKEY` AS NUMERIC)                             AS `C_CUSTKEY`           @id("6b8a02") @isBusinessKey @notNull @clusterKey(1) @not_null @zeroKey("-1") @description("Customer key - business key"),
    CAST(`C_NAME` AS STRING)                                 AS `C_NAME`              @id("6b8a03") @description("Customer name - SCD1 overwrite"),
    CAST(`C_MKTSEGMENT` AS STRING)                           AS `C_MKTSEGMENT`        @id("6b8a04") @isChangeTracking @clusterKey(2) @description("Market segment - new version on change"),
    CAST(`C_ACCTBAL` AS NUMERIC)                              AS `C_ACCTBAL`           @id("6b8a05") @zeroKey("0.00") @description("Account balance - SCD1 overwrite"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("6b8a06") @isChangeTracking @zeroKey("-1") @description("Nation key - new version on change"),
    `N_NAME`                                 AS `N_NAME`              @id("6b8a07") @isChangeTracking @description("Nation name - new version on change"),
    `R_REGIONKEY`                            AS `R_REGIONKEY`         @id("6b8a08") @zeroKey("-1") @description("Region key"),
    `R_NAME`                                 AS `R_NAME`              @id("6b8a09") @description("Region name"),
    CAST(`HK_CUSTOMER` AS STRING)                            AS `HK_CUSTOMER`         @id("6b8a0a") @description("Customer hash key from Work"),
    1                                        AS `SYSTEM_VERSION`      @id("6b8a0b") @isSystemVersion @zeroKey("1") @min_value("1"),
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("6b8a0c") @isSystemCurrentFlag @zeroKey("'Y'") @accepted_values("'Y', 'N'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("6b8a0d") @isSystemCreateDate @partitionBy @notNull,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("6b8a0e") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("6b8a0f") @isSystemEndDate @zeroKey("TIMESTAMP '2999-12-31 00:00:00'") @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'WRK_CUSTOMER_GEO_V') }} `WRK_CUSTOMER_GEO_V`
