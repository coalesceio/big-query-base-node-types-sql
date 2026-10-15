@id("450dca4a-480c-40d6-a087-16de00f5e60a")
@nodeType("SQLDimension")
@description("PartitionBy test - column-level bare @partitionBy on a TIMESTAMP column (partitions by DATE(last_modified)) + partitionExpirationDays; lastModified SCD Type 2")
@mergeStrategy("lastModified")
@partitionExpirationDays(36500)
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_COL_TIMESTAMP_KEY` @id("d90001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("d90002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`@id("d90003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`@id("d90004"),
    `N_COMMENT`                              AS `N_COMMENT`@id("d90005"),
    `last_modified`                          AS `last_modified`        @id("d90006") @lastModifiedTracking(2) @not_null @partitionBy,
    1                                        AS `SYSTEM_VERSION`       @id("d90007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`  @id("d90008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d90009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d9000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`      @id("d9000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
