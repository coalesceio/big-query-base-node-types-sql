@id("0527254c-6804-4d3f-929f-d6dd7934349e")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - region-level SCD2 from an aggregate CTE with SELECT DISTINCT; Nation_Count is tracked, so adding/removing nations versions the region")
@mergeStrategy("changeTracking")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `n_RegionKey` HAVING COUNT(*) > 1")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' HAVING COUNT(*) <> (SELECT COUNT(DISTINCT `n_RegionKey`) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
WITH `REGION_STATS` AS (
    SELECT
        `F`.`n_RegionKey`                    AS `n_RegionKey`,
        COUNT(*)                             AS `NATION_COUNT`,
        MAX(`F`.`last_Modified`)             AS `LAST_CHANGE`
    FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
    GROUP BY `F`.`n_RegionKey`
)
SELECT DISTINCT
    CAST('0' AS STRING)                      AS `QA_DIM_CTE_DISTINCT_KEY` @id("d8a000") @isSurrogateKey @defaultValue("GENERATE_UUID()") @uniqueness,
    CAST(`S`.`n_RegionKey` AS INT64)         AS `n_RegionKey`         @id("d8a001") @isBusinessKey @not_null,
    CAST(`S`.`NATION_COUNT` AS INT64)        AS `Nation_Count`        @id("d8a002") @isChangeTracking @min_value("1"),
    CAST(`S`.`LAST_CHANGE` AS TIMESTAMP)     AS `Last_Change`         @id("d8a003"),
    1                                        AS `SYSTEM_VERSION`      @id("d8a004") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("d8a005") @isSystemCurrentFlag,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("d8a006") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d8a007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d8a008") @isSystemUpdateDate
FROM `REGION_STATS` `S`
