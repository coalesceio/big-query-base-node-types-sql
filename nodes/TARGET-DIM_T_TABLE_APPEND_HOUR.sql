@id("2628c102-665c-42a7-bd54-33edfb598565")
@nodeType("728")
@description("Test - explicit table materialization, append writeMode, hourly partition plus cluster key")
@materializationType("table")
@writeMode("append")
@mergeStrategy("changeTracking")
@partitionBy("TIMESTAMP_TRUNC(last_modified, HOUR)")
SELECT
    0                                    AS `DIM_T_TABLE_APPEND_HOUR_KEY` @id("b70001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`                 @id("b70002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`                      @id("b70003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`                 @id("b70004") @clusterKey(1),
    `N_COMMENT`                          AS `N_COMMENT`                   @id("b70005"),
    `last_modified`                      AS `last_modified`               @id("b70006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`          @id("b70007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`          @id("b70008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
