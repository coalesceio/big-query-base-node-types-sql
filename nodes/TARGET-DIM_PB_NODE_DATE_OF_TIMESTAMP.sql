@id("48952b8b-3f35-4f5e-92cb-db4188ce9bc6")
@nodeType("SQLDimension")
@description("PartitionBy test - node-level DATE(last_modified) over a TIMESTAMP column; lastModified SCD Type 1")
@mergeStrategy("lastModified")
@partitionBy("DATE(last_modified)")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NODE_DATE_OF_TIMESTAMP_KEY` @id("d50001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("d50002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("d50003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("d50004"),
    `N_COMMENT`                              AS `N_COMMENT`            @id("d50005"),
    `last_modified`                          AS `last_modified`        @id("d50006") @lastModifiedTracking(1) @not_null,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d50007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d50008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
