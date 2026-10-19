@id("584f245c-803f-493f-a32a-6237a4561bcf")
@nodeType("SQLDimension")
@description("Dimension test - no @mergeStrategy: defaults to changeTracking, SCD Type 1 (no @isChangeTracking column)")
SELECT
    CAST("0" AS STRING)                  AS `DIM_MERGE_DEFAULT_KEY` @id("f90001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`           @id("f90002") @isBusinessKey,
    `N_NAME`                             AS `N_NAME`                @id("f90003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`           @id("f90004"),
    `N_COMMENT`                          AS `N_COMMENT`             @id("f90005"),
    `last_modified`                      AS `last_modified`         @id("f90006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`    @id("f90007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`    @id("f90008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
