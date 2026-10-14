@id("cdd589c3-38d5-4f7f-a72d-0bae55e6bece")
@nodeType("SQLDimension")
@description("Test - partitionBy ingestion time, monthly partitions; upsert")
@mergeStrategy("upsert")
@partitionBy("DATE_TRUNC(_PARTITIONTIME, MONTH)")
SELECT
    0                                    AS `DIM_T_PART_INGESTION_MONTH_KEY` @id("c10001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`                    @id("c10002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`                         @id("c10003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`                    @id("c10004"),
    `N_COMMENT`                          AS `N_COMMENT`                      @id("c10005"),
    `last_modified`                      AS `last_modified`                  @id("c10006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`             @id("c10007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`             @id("c10008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`