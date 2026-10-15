@id("05903e82-0eb2-42a5-883a-b039dcb34235")
@nodeType("SQLDimension")
@description("PartitionBy test - node-level ingestion-time partition _PARTITIONDATE + partitionExpirationDays; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@partitionBy("_PARTITIONDATE")
@partitionExpirationDays(30)
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NODE_INGEST_DAY_KEY` @id("d10001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("d10002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("d10003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("d10004"),
    `N_COMMENT`                              AS `N_COMMENT`            @id("d10005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d10006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d10007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
