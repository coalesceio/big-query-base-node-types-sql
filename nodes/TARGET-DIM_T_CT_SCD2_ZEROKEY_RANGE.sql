@id("5f6344b2-797e-4df0-a57e-34c5f96c906a")
@nodeType("728")
@description("Test - changeTracking SCD Type 2 with zeroKey; integer-range partition (partitionExpirationDays must be ignored)")
@mergeStrategy("changeTracking")
@partitionBy("RANGE_BUCKET(N_NATIONKEY, GENERATE_ARRAY(-1, 100, 5))")
@partitionExpirationDays(30)
SELECT
    0                                        AS `DIM_T_CT_SCD2_ZEROKEY_RANGE_KEY` @id("b60001") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`                     @id("b60002") @isBusinessKey @not_null @uniqueness ,
    `N_NAME`                                 AS `N_NAME`                          @id("b60003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`                     @id("b60004"),
    `N_COMMENT`                              AS `N_COMMENT`                       @id("b60005"),
    `last_modified`                          AS `last_modified`                   @id("b60006"),
    `N_COMMENT`                              AS `N_COMMENT_DEFAULTED`             @id("b60007"),
    1                                        AS `SYSTEM_VERSION`                  @id("b60008") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`             @id("b60009") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`              @id("b6000a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`              @id("b6000b") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`                 @id("b6000c") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
