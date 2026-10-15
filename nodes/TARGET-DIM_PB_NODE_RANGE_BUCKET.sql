@id("e6d57613-8f83-436e-9f1b-708da7d97a9b")
@nodeType("SQLDimension")
@description("PartitionBy test - node-level integer range RANGE_BUCKET on N_REGIONKEY; partitionExpirationDays is ignored with a warning; upsert")
@mergeStrategy("upsert")
@partitionBy("RANGE_BUCKET(N_REGIONKEY, GENERATE_ARRAY(0, 10, 1))")
@partitionExpirationDays(30)
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NODE_RANGE_BUCKET_KEY` @id("d70001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("d70002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("d70003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("d70004"),
    `N_COMMENT`                              AS `N_COMMENT`            @id("d70005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d70006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d70007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
