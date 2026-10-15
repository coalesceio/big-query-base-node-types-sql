@id("3c576835-79a2-4cef-8710-dcd8ac726b8e")
@nodeType("SQLDimension")
@materializationType("table")
@description("Dimension 2 - nation from WRK_NATION: lastModified SCD Type 2, clustering, zero key, tags")
@mergeStrategy("lastModified")
@writeMode("append")
@zeroKey("'0'")
@tag("env", "dev")
@tests("SELECT 1 FROM {{ ref('TARGET', 'WRK_NATION') }} GROUP BY `N_NATIONKEY` HAVING COUNT(*) > 1 OR `N_NATIONKEY` IS NULL", false, "Before")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `N_NATIONKEY` HAVING COUNT(*) > 1", false, "After")
SELECT
    CAST("0" AS STRING)                      AS `DIM_NATION_KEY`      @id("3c5701") @isSurrogateKey @defaultValue("GENERATE_UUID()") @description("Surrogate key"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("3c5702") @isBusinessKey @notNull @clusterKey(1) @not_null @zeroKey("-1") @description("Nation key - business key"),
    `N_NAME`                                 AS `N_NAME`              @id("3c5703") @clusterKey(2) @not_null @description("Nation name"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("3c5704") @zeroKey("-1") @description("Region key"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("3c5705") @description("Free-text comment"),
    `LAST_MODIFIED`                          AS `LAST_MODIFIED`       @id("3c5706") @lastModifiedTracking(2) @not_null @description("Source last modified time - drives SCD Type 2"),
    1                                        AS `SYSTEM_VERSION`      @id("3c5707") @isSystemVersion @zeroKey("1") @min_value("1"),
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("3c5708") @isSystemCurrentFlag @zeroKey("'Y'") @accepted_values("'Y', 'N'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("3c5709") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("3c570a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("3c570b") @isSystemEndDate @zeroKey("TIMESTAMP '2999-12-31 00:00:00'") @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'WRK_NATION') }} `WRK_NATION`
