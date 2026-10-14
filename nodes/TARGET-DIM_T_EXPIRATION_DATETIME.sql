@id("90281c0e-1a7a-412b-9454-6f047788ac76")
@nodeType("SQLDimension")
@description("Test - tableExpiration as a full datetime; changeTracking SCD Type 2")
@mergeStrategy("changeTracking")
@tableExpiration("2026-10-23 23:59:59")
SELECT
    0                                        AS `DIM_T_EXPIRATION_DATETIME_KEY` @id("c40001") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`                   @id("c40002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`                        @id("c40003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`                   @id("c40004"),
    `N_COMMENT`                              AS `N_COMMENT`                     @id("c40005"),
    `last_modified`                          AS `last_modified`                 @id("c40006"),
    1                                        AS `SYSTEM_VERSION`                @id("c40007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`           @id("c40008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`            @id("c40009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`            @id("c4000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`               @id("c4000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`