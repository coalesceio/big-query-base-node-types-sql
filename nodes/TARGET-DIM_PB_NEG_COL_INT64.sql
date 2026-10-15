@id("cad95e2d-2983-409d-b304-829be0032c00")
@nodeType("SQLDimension")
@description("PartitionBy NEGATIVE test - bare column-level @partitionBy on an INT64 column (needs node-level RANGE_BUCKET); create should stop")
@mergeStrategy("lastModified")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NEG_COL_INT64_KEY` @id("e10001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("e10002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`@id("e10003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("e10004") @partitionBy,
    `N_COMMENT`                              AS `N_COMMENT`@id("e10005"),
    `last_modified`                          AS `last_modified`        @id("e10006") @lastModifiedTracking(1) @not_null,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("e10007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("e10008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
