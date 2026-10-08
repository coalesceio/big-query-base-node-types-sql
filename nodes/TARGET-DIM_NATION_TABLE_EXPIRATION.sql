@id("281c815e-f30f-419d-8e89-13ad3f8ced54")
@nodeType("728")
@description("Table expiration test - lastModified SCD Type 2, table expires 30 days after creation")
@mergeStrategy("lastModified")
@tableExpiration("daysFromNow", "30")
SELECT
    0                                        AS `DIM_NATION_TABLE_EXPIRATION_KEY` @id("e10001") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`                     @id("e10002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`                          @id("e10003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`                     @id("e10004"),
    `N_COMMENT`                              AS `N_COMMENT`                       @id("e10005"),
    `last_modified`                          AS `last_modified`                   @id("e10006") @lastModifiedTracking(2) @not_null,
    1                                        AS `SYSTEM_VERSION`                  @id("e10007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`             @id("e10008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`              @id("e10009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`              @id("e1000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`                 @id("e1000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
