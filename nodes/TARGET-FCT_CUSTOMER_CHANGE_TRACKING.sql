@id("f5889137-b557-4db3-b0ca-b1420a55d945")
@nodeType("729")
@description("Fact annotation test - explicit changeTracking merge on customer; integer-range partition, clustering, pre-load key test")
@materializationType("table")
@mergeStrategy("changeTracking")
@partitionBy("RANGE_BUCKET(C_NATIONKEY, GENERATE_ARRAY(0, 25, 5))")
@tests("SELECT 1 FROM {{ ref('SRC', 'customer') }} GROUP BY C_CUSTKEY HAVING COUNT(*) > 1", false, "Before")
@tests("SELECT 1 FROM {{ this }} GROUP BY C_CUSTKEY HAVING COUNT(*) > 1", false, "After")
SELECT
    `C_CUSTKEY`                          AS `C_CUSTKEY`          @id("f58801") @isBusinessKey @notNull @not_null @uniqueness @min_value("1"),
    `C_NAME`                             AS `C_NAME`             @id("f58802") @not_null @empty,
    `C_ADDRESS`                          AS `C_ADDRESS`          @id("f58803"),
    `C_NATIONKEY`                        AS `C_NATIONKEY`        @id("f58804") @min_max("0", "24"),
    `C_PHONE`                            AS `C_PHONE`            @id("f58805") @empty,
    CAST(`C_ACCTBAL` AS FLOAT64)         AS `C_ACCTBAL`          @id("f58806") @min_value("-999.99") @max_value("9999.99") @description("Account balance"),
    `C_MKTSEGMENT`                       AS `C_MKTSEGMENT`       @id("f58807") @accepted_values("'AUTOMOBILE'") @accepted_values("'BUILDING'") @accepted_values("'FURNITURE'") @accepted_values("'HOUSEHOLD'") @accepted_values("'MACHINERY'"),
    `C_COMMENT`                          AS `C_COMMENT`          @id("f58808") @defaultValue("'NA'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("f58809") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("f5880a") @isSystemUpdateDate @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('SRC', 'customer') }} `customer`
