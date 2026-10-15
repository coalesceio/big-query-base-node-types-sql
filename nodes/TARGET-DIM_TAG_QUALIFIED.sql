@id("c23a2a87-a5d1-44df-86f1-b42cdf6c8ae5")
@nodeType("SQLDimension")
@description("Tag test - fully-qualified tag key (cls-dev-bigquery/cost_center) used as-is; lastModified SCD Type 1")
@mergeStrategy("lastModified")
@tag("cls-dev-bigquery/cost_center", "finance")
SELECT
    CAST("0" AS STRING)                  AS `DIM_TAG_QUALIFIED_KEY` @id("a70001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`           @id("a70002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`                @id("a70003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`           @id("a70004"),
    `N_COMMENT`                          AS `N_COMMENT`             @id("a70005"),
    `last_modified`                      AS `last_modified`         @id("a70006") @lastModifiedTracking(1) @not_null,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`    @id("a70007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`    @id("a70008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
