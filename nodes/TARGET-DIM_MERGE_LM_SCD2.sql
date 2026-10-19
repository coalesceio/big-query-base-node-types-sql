@id("124ca0ac-43e7-4a8d-aa84-6f2d6ff5827e")
@nodeType("SQLDimension")
@description("Dimension test - lastModified SCD Type 2: a newer last_modified expires the row and inserts a new version")
@mergeStrategy("lastModified")
SELECT
    CAST("0" AS STRING)                      AS `DIM_MERGE_LM_SCD2_KEY` @id("fc0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`           @id("fc0002") @isBusinessKey,
    `N_NAME`                                 AS `N_NAME`                @id("fc0003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`           @id("fc0004"),
    `N_COMMENT`                              AS `N_COMMENT`             @id("fc0005"),
    `last_modified`                          AS `last_modified`         @id("fc0006") @lastModifiedTracking(2),
    1                                        AS `SYSTEM_VERSION`        @id("fc0007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`   @id("fc0008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`    @id("fc0009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`    @id("fc000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`       @id("fc000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
