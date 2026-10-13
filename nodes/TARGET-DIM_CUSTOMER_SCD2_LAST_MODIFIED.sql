@id("3e129650-be49-4640-bfe3-721b2e78a0ce")
@nodeType("728")
@description("SCD test - lastModified SCD2 on WRK_CUSTOMER_ORDER_SUMMARY; a newer LAST_ORDER_DATE expires the current version and inserts a new one")
@mergeStrategy("lastModified")
@partitionBy("ingestionTime")
@tests("SELECT 1 FROM {{ this }} WHERE SYSTEM_CURRENT_FLAG = 'Y' GROUP BY C_CUSTKEY HAVING COUNT(*) > 1", false, "After")
@preSQL("SELECT COUNT(*) AS CURRENT_ROWS FROM {{ this }} WHERE SYSTEM_CURRENT_FLAG = 'Y'")
SELECT
    0                                         AS `DIM_CUSTOMER_SCD2_LAST_MODIFIED_KEY` @id("3e1201") @isSurrogateKey,
    `C_CUSTKEY`                               AS `C_CUSTKEY`           @id("3e1202") @isBusinessKey @clusterKey(1) @not_null,
    `C_NAME`                                  AS `C_NAME`              @id("3e1203"),
    `C_MKTSEGMENT`                            AS `C_MKTSEGMENT`        @id("3e1204"),
    `N_NAME`                                  AS `N_NAME`              @id("3e1205") @clusterKey(3),
    `R_NAME`                                  AS `R_NAME`              @id("3e1206") @clusterKey(2),
    `ORDER_COUNT`                             AS `ORDER_COUNT`         @id("3e1207") @min_value("1"),
    `NET_REVENUE`                             AS `NET_REVENUE`         @id("3e1208") @min_value("0"),
    `FIRST_ORDER_DATE`                        AS `FIRST_ORDER_DATE`    @id("3e1209") @relative_time("<=", "LAST_ORDER_DATE"),
    `LAST_ORDER_DATE`                         AS `LAST_ORDER_DATE`     @id("3e120a") @lastModifiedTracking(2) @not_null,
    `HK_CUSTOMER`                             AS `HK_CUSTOMER`         @id("3e120b"),
    1                                         AS `SYSTEM_VERSION`      @id("3e120c") @isSystemVersion,
    CAST('Y' AS STRING)                       AS `SYSTEM_CURRENT_FLAG` @id("3e120d") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE`  @id("3e120e") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE`  @id("3e120f") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP)  AS `SYSTEM_END_DATE`     @id("3e1210") @isSystemEndDate
FROM {{ ref('TARGET', 'WRK_CUSTOMER_ORDER_SUMMARY') }} `WRK_CUSTOMER_ORDER_SUMMARY`
