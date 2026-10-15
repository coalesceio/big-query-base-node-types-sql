@id("e2ca0647-97b5-47e6-976e-3d8b436b67ea")
@nodeType("SQLDimension")
@description("PartitionBy NEGATIVE test - bare column-level @partitionBy on a STRING column; create should stop")
@mergeStrategy("upsert")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NEG_COL_STRING_KEY` @id("e20001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("e20002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("e20003") @partitionBy,
    `N_REGIONKEY`                            AS `N_REGIONKEY`@id("e20004"),
    `N_COMMENT`                              AS `N_COMMENT`@id("e20005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("e20006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("e20007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
