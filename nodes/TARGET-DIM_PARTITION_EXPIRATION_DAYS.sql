@id("55ca0709-d16a-43ad-a4fb-b541a474cb80")
@nodeType("SQLDimension")
@description("Dimension test - @partitionExpirationDays(30) on an ingestion-time partition (rows land in the load date partition); changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@partitionBy("_PARTITIONDATE")
@partitionExpirationDays(30)
SELECT
    CAST("0" AS STRING)                  AS `DIM_PARTITION_EXPIRATION_DAYS_KEY` @id("f20001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`                       @id("f20002") @isBusinessKey,
    `N_NAME`                             AS `N_NAME`                            @id("f20003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`                       @id("f20004"),
    `N_COMMENT`                          AS `N_COMMENT`                         @id("f20005"),
    `last_modified`                      AS `last_modified`                     @id("f20006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`                @id("f20007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`                @id("f20008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
