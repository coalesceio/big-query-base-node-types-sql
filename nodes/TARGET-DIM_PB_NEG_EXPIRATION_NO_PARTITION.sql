@id("36f458a8-ce40-494b-9022-91fa23437daa")
@nodeType("SQLDimension")
@description("PartitionBy NEGATIVE test - @partitionExpirationDays without any @partitionBy; create should stop")
@mergeStrategy("changeTracking")
@partitionExpirationDays(30)
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NEG_EXPIRATION_NO_PARTITION_KEY` @id("e30001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("e30002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("e30003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("e30004"),
    `N_COMMENT`                              AS `N_COMMENT`            @id("e30005"),
    `last_modified`                          AS `last_modified`        @id("e300010") @partitionBy,
    1                                        AS `SYSTEM_VERSION`       @id("e30006") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`  @id("e30007") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("e30008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("e30009") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`      @id("e3000a") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
