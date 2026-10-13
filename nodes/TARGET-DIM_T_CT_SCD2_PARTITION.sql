@id("20ab1233-6b27-437a-adda-bfd9b551c13d")
@nodeType("728")
@description("Test - changeTracking SCD Type 2; partitionBy on a TIMESTAMP column with partitionExpirationDays")
@mergeStrategy("changeTracking")
@partitionExpirationDays(2)
SELECT
    0                                        AS `DIM_T_CT_SCD2_PARTITION_KEY` @id("b20001") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`                 @id("b20002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`                      @id("b20003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`                 @id("b20004"),
    `N_COMMENT`                              AS `N_COMMENT`                   @id("b20005"),
    `last_modified`                          AS `last_modified`               @id("b20006") @partitionBy("last_modified"),
    1                                        AS `SYSTEM_VERSION`              @id("b20007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`         @id("b20008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`          @id("b20009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`          @id("b2000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`             @id("b2000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
