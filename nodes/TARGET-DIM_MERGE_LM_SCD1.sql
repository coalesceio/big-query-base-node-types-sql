@id("83cf6808-1986-4bfe-b9f7-f53272f8efba")
@nodeType("SQLDimension")
@description("Dimension test - lastModified SCD Type 1: a newer last_modified overwrites the row in place")
@mergeStrategy("lastModified")
SELECT
    CAST("0" AS STRING)                  AS `DIM_MERGE_LM_SCD1_KEY` @id("fb0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`           @id("fb0002") @isBusinessKey,
    `N_NAME`                             AS `N_NAME`                @id("fb0003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`           @id("fb0004"),
    `N_COMMENT`                          AS `N_COMMENT`             @id("fb0005"),
    `last_modified`                      AS `last_modified`         @id("fb0006") @lastModifiedTracking(1),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`    @id("fb0007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`    @id("fb0008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
