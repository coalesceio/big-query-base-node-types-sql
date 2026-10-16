@id("039b5088-dec2-4006-88df-a10a3edf5503")
@nodeType("SQLFact")
@materializationType("table")
@description("Fact - order revenue and tax from WRK_ORDERS_TBL_OPTIONS and DIM_CUSTOMER_TBL_OPTIONS: monthly partition with 730-day partition expiration, clustered on order and customer key, primary key, fixed table expiration, rounding mode, tags")
@mergeStrategy("changeTracking")
@writeMode("append")
@partitionBy("DATE_TRUNC(O_ORDERDATE, MONTH)")
@partitionExpirationDays("730")
@tableExpiration("2999-12-31")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ this }} GROUP BY `O_ORDERKEY` HAVING COUNT(*) > 1", false, "After")
SELECT
    `o`.`O_ORDERKEY`                          AS `O_ORDERKEY`         @id("039b01") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @description("Order key - business key"),
    `o`.`O_CUSTKEY`                           AS `O_CUSTKEY`          @id("039b02") @notNull @clusterKey(2) @not_null @description("Customer key"),
    CAST(COALESCE(`c`.`C_MKTSEGMENT`, 'UNKNOWN') AS STRING) AS `C_MKTSEGMENT` @id("039b03") @description("Customer market segment, UNKNOWN when unresolved"),
    `o`.`O_ORDERSTATUS`                       AS `O_ORDERSTATUS`      @id("039b04") @accepted_values("'F', 'O', 'P'"),
    `o`.`O_TOTALPRICE`                        AS `O_TOTALPRICE`       @id("039b05") @min_value("0") @description("Order total price"),
    CAST(`o`.`O_TOTALPRICE` * NUMERIC '0.075' AS NUMERIC) AS `O_TAX_AMT`        @id("039b06") @description("7.5% tax, rounded with the table default_rounding_mode"),
    `o`.`O_ORDERDATE`                         AS `O_ORDERDATE`        @id("039b07") @notNull @not_null @description("Order date - partitioned by month"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE` @id("039b08") @isSystemCreateDate @description("Row create time"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE` @id("039b09") @isSystemUpdateDate @description("Row update time")
FROM {{ ref('TARGET', 'WRK_ORDERS_TBL_OPTIONS') }} `o`
LEFT JOIN {{ ref('TARGET', 'DIM_CUSTOMER_TBL_OPTIONS') }} `c`
    ON `c`.`C_CUSTKEY` = `o`.`O_CUSTKEY`
