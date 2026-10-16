@id("4c194b5c-ab25-4b63-a22e-c3dd7e3e932b")
@nodeType("SQLDimension")
@materializationType("table")
@description("Dimension - customer from SRC with every table option: changeTracking SCD1, monthly partition on create date, clustering, primary key, fixed table expiration, rounding mode, tags")
@mergeStrategy("changeTracking")
@writeMode("append")
@partitionBy("TIMESTAMP_TRUNC(SYSTEM_CREATE_DATE, MONTH)")
@tableExpiration("2031-12-31")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ ref('SRC', 'customer') }} GROUP BY `C_CUSTKEY` HAVING COUNT(*) > 1 OR `C_CUSTKEY` IS NULL", true, "Before")
SELECT
    `C_CUSTKEY`                              AS `C_CUSTKEY`           @id("4c1901") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @description("Customer key - business key"),
    `C_NAME`                                 AS `C_NAME`              @id("4c1902"),
    `C_NATIONKEY`                            AS `C_NATIONKEY`         @id("4c1903") @clusterKey(2) @description("Nation key"),
    `C_MKTSEGMENT`                           AS `C_MKTSEGMENT`        @id("4c1904") @clusterKey(3) @description("Market segment"),
    CAST(`C_ACCTBAL` AS NUMERIC)             AS `C_ACCTBAL`           @id("4c1905") @description("Account balance"),
    CAST(`C_ACCTBAL` / 12 AS NUMERIC)        AS `C_ACCTBAL_MONTHLY`   @id("4c1906") @description("Balance per month, rounded with the table default_rounding_mode"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("4c1907") @isSystemCreateDate @notNull @description("Row create time - partition column"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("4c1908") @isSystemUpdateDate @description("Row update time")
FROM {{ ref('SRC', 'customer') }} `customer`
