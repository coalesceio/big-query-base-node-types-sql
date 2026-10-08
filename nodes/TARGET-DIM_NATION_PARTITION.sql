@id("af2fa996-27c6-4433-92b8-8df719ca4d98")
@nodeType("728")
@description("Partition test - changeTracking SCD Type 2, partitioned by day of last_modified")
@mergeStrategy("changeTracking")
@partitionBy("timeUnitColumn", "DATE(last_modified)")
@partitionExpirationDays(365)
SELECT
    0                                        AS `DIM_NATION_PARTITION_KEY` @id("a10001") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`              @id("a10002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`                   @id("a10003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`              @id("a10004"),
    `N_COMMENT`                              AS `N_COMMENT`                @id("a10005"),
    `last_modified`                          AS `last_modified`            @id("a10006"),
    1                                        AS `SYSTEM_VERSION`           @id("a10007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`      @id("a10008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`       @id("a10009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`       @id("a1000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`          @id("a1000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
