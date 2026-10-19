@id("00f82020-2230-45eb-a279-2cbbd7fec70f")
@nodeType("SQLDimension")
@description("Dimension test - changeTracking SCD Type 2: a change to N_NAME (@isChangeTracking) expires the row and inserts a new version")
@mergeStrategy("changeTracking")
SELECT
    CAST("0" AS STRING)                      AS `DIM_MERGE_CT_SCD2_KEY` @id("fa0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`           @id("fa0002") @isBusinessKey,
    `N_NAME`                                 AS `N_NAME`                @id("fa0003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`           @id("fa0004"),
    `N_COMMENT`                              AS `N_COMMENT`             @id("fa0005"),
    `last_modified`                          AS `last_modified`         @id("fa0006"),
    1                                        AS `SYSTEM_VERSION`        @id("fa0007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`   @id("fa0008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`    @id("fa0009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`    @id("fa000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`       @id("fa000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
