@id("f3e9eb5f-b040-4d05-90fa-5d6b5a7e1963")
@nodeType("SQLDimension")
@description("PartitionBy test - node-level hourly partition TIMESTAMP_TRUNC(last_modified, HOUR); changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@partitionBy("TIMESTAMP_TRUNC(last_modified, HOUR)")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NODE_TIMESTAMP_TRUNC_HOUR_KEY` @id("d60001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("d60002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("d60003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("d60004"),
    `N_COMMENT`                              AS `N_COMMENT`            @id("d60005"),
    `last_modified`                          AS `last_modified`        @id("d60006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d60007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d60008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
