@id("800a273f-84af-4d91-985d-37344e2552a8")
@nodeType("SQLDimension")
@description("PartitionBy test - column-level bare @partitionBy on a derived DATE column LOAD_DATE; upsert")
@mergeStrategy("upsert")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_COL_DERIVED_DATE_KEY` @id("da0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("da0002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("da0003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("da0004"),
    `N_COMMENT`                              AS `N_COMMENT`            @id("da0005"),
    `last_modified`                          AS `last_modified`        @id("da0006"),
    CAST(DATE(`last_modified`) AS DATE)      AS `LOAD_DATE`            @id("da0007") @partitionBy,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("da0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("da0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
