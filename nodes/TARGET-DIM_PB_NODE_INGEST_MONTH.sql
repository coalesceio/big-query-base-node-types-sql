@id("fde64173-467f-4e41-89e8-523a3e94ffd9")
@nodeType("SQLDimension")
@description("PartitionBy test - node-level monthly ingestion-time partition DATE_TRUNC(_PARTITIONTIME, MONTH); lastModified SCD Type 2")
@mergeStrategy("lastModified")
@partitionBy("DATE_TRUNC(_PARTITIONTIME, MONTH)")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NODE_INGEST_MONTH_KEY` @id("d20001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("d20002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("d20003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("d20004"),
    `N_COMMENT`                              AS `N_COMMENT`            @id("d20005"),
    `last_modified`                          AS `last_modified`        @id("d20006") @lastModifiedTracking(2) @not_null,
    1                                        AS `SYSTEM_VERSION`       @id("d20007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`  @id("d20008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d20009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d2000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`      @id("d2000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
