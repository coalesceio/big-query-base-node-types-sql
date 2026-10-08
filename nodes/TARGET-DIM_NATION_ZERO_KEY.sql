@id("b6b50482-2b15-4b75-846c-9e0e892aaafa")
@nodeType("728")
@description("Zero key test - changeTracking SCD Type 2 with a -1 ghost record")
@mergeStrategy("changeTracking")
@zeroKey("-1", "'UNKNOWN'", "1900-01-01 00:00:00", true)
SELECT
    0                                        AS `DIM_NATION_ZERO_KEY_KEY` @id("f10001") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`             @id("f10002") @isBusinessKey @zeroKey("-1") @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`                  @id("f10003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`             @id("f10004") @zeroKey("-1"),
    `N_COMMENT`                              AS `N_COMMENT`               @id("f10005"),
    `last_modified`                          AS `last_modified`           @id("f10006"),
    `N_COMMENT`                              AS `N_COMMENT_DEFAULTED`     @id("f10007") @zeroKey("'N/A'"),
    1                                        AS `SYSTEM_VERSION`          @id("f10008") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`     @id("f10009") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`      @id("f1000a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`      @id("f1000b") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`         @id("f1000c") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
