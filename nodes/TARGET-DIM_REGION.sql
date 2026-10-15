@id("46dd37b1-e44e-4e2e-9cf6-89da53abe6ea")
@nodeType("SQLDimension")
@materializationType("table")
@description("Dimension 1 - region from WRK_REGION: changeTracking SCD Type 1 with a zero key record")
@mergeStrategy("changeTracking")
@writeMode("append")
@zeroKey("'0'", "'UNKNOWN'", "1900-01-01 00:00:00", "true")
@tests("SELECT 1 FROM {{ ref('TARGET', 'WRK_REGION') }} GROUP BY `R_REGIONKEY` HAVING COUNT(*) > 1 OR `R_REGIONKEY` IS NULL", false, "Before")
SELECT
    CAST("0" AS STRING)                  AS `DIM_REGION_KEY`     @id("46dd01") @isSurrogateKey @defaultValue("GENERATE_UUID()") @description("Surrogate key"),
    `R_REGIONKEY`                        AS `R_REGIONKEY`        @id("46dd02") @isBusinessKey @notNull @primaryKey(1) @not_null @uniqueness @zeroKey("-1") @description("Region key - business key"),
    `R_NAME`                             AS `R_NAME`             @id("46dd03") @not_null @description("Region name"),
    `R_COMMENT`                          AS `R_COMMENT`          @id("46dd04") @zeroKey("'N/A'") @description("Free-text comment"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("46dd05") @isSystemCreateDate @description("Row create time"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("46dd06") @isSystemUpdateDate @relative_time(">=", "SYSTEM_CREATE_DATE") @description("Row update time")
FROM {{ ref('TARGET', 'WRK_REGION') }} `WRK_REGION`
