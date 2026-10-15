@id("67147401-eda4-4dcd-ab98-f440bb76f391")
@nodeType("SQLDimension")
@description("PartitionBy test - column-level bare @partitionBy on a DATETIME column (partitions by DATE(LOAD_DATETIME)); changeTracking SCD Type 2")
@mergeStrategy("changeTracking")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_COL_DATETIME_KEY` @id("db0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("db0002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("db0003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`@id("db0004"),
    `N_COMMENT`                              AS `N_COMMENT`@id("db0005"),
    CAST(`last_modified` AS DATETIME)        AS `LOAD_DATETIME`        @id("db0006") @partitionBy,
    1                                        AS `SYSTEM_VERSION`       @id("db0007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`  @id("db0008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("db0009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("db000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`      @id("db000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
