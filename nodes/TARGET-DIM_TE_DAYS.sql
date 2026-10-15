@id("764bc39a-be72-4456-8f40-a4ebde08de21")
@nodeType("SQLDimension")
@description("Table expiration test - tableExpiration as a number of days (30); changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@tableExpiration("30")
SELECT
    CAST("0" AS STRING)                  AS `DIM_TE_DAYS_KEY`    @id("a10001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("a10002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`             @id("a10003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("a10004"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("a10005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("a10006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("a10007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
