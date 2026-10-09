@id("757aeda6-922d-4e54-a140-b60ebb4db58e")
@nodeType("728")
@description("SCD test - changeTracking SCD2 on WRK_CUSTOMER_ANNOTATIONS; hash diff and market segment version the row, account balance updates in place")
@mergeStrategy("changeTracking")
@tests("SELECT 1 FROM {{ this }} WHERE SYSTEM_CURRENT_FLAG = 'Y' GROUP BY C_CUSTKEY HAVING COUNT(*) > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} WHERE SYSTEM_CURRENT_FLAG = 'N' AND SYSTEM_END_DATE >= TIMESTAMP '2999-12-31 00:00:00'")
@postSQL("SELECT COUNT(*) AS EXPIRED_VERSIONS FROM {{ this }} WHERE SYSTEM_CURRENT_FLAG = 'N'")
WITH LATEST_CUSTOMER AS (
    -- WRK_CUSTOMER_ANNOTATIONS loads in append mode, so keep only the newest row per customer
    SELECT *
    FROM (
        SELECT
            `wc`.*,
            ROW_NUMBER() OVER (PARTITION BY `wc`.`C_CUSTKEY` ORDER BY `wc`.`LOAD_TS` DESC) AS `RN`
        FROM {{ ref('TARGET', 'WRK_CUSTOMER_ANNOTATIONS') }} `wc`
    )
    WHERE `RN` = 1
)
SELECT
    0                                         AS `DIM_CUSTOMER_SCD2_CHANGE_TRACKING_KEY` @id("757a01") @isSurrogateKey,
    `lc`.`C_CUSTKEY`                          AS `C_CUSTKEY`           @id("757a02") @isBusinessKey @primaryKey @clusterKey(1) @not_null,
    `lc`.`C_NAME`                             AS `C_NAME`              @id("757a03") @empty,
    `lc`.`C_ADDRESS`                          AS `C_ADDRESS`           @id("757a04"),
    `lc`.`C_NATIONKEY`                        AS `C_NATIONKEY`         @id("757a05") @clusterKey(2) @min_max("0", "24"),
    `lc`.`C_PHONE`                            AS `C_PHONE`             @id("757a06"),
    `lc`.`C_ACCTBAL`                          AS `C_ACCTBAL`           @id("757a07") @min_value("-999.99") @description("Plain attribute - SCD1 update in place on the current version"),
    `lc`.`C_MKTSEGMENT`                       AS `C_MKTSEGMENT`        @id("757a08") @isChangeTracking @rejected_values("'UNKNOWN'"),
    `lc`.`HD_CUSTOMER`                        AS `HD_CUSTOMER`         @id("757a09") @isChangeTracking @not_null @description("Hash diff of name, address and phone - a change creates a new version"),
    1                                         AS `SYSTEM_VERSION`      @id("757a0a") @isSystemVersion @min_value("1"),
    CAST('Y' AS STRING)                       AS `SYSTEM_CURRENT_FLAG` @id("757a0b") @isSystemCurrentFlag @accepted_values("'Y'") @accepted_values("'N'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE`  @id("757a0c") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE`  @id("757a0d") @isSystemUpdateDate @freshness(1, "DAY"),
    CAST('2999-12-31 00:00:00' AS TIMESTAMP)  AS `SYSTEM_END_DATE`     @id("757a0e") @isSystemEndDate @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM LATEST_CUSTOMER `lc`
