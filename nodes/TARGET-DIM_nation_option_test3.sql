@id("fbda9be1-c665-4726-bc08-df8df4254b25")
@nodeType("SQLDimension")
@description("Alter table options test")
@partitionBy("DATE_TRUNC(last_modified, MONTH)")
@partitionExpirationDays(2)
@defaultRoundingMode("ROUND_HALF_EVEN")
@tableExpiration("30")
SELECT
    CAST("0" AS STRING)                      AS `DIM_nation_KEY`      @id("3f6a04") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("276d07") @isBusinessKey,
    `N_NAME`                                 AS `N_NAME`              @id("578192"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("0df6fe"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("8e02b7"),
    `last_modified`                          AS `last_modified`       @id("f79ba4"),
    1                                        AS `SYSTEM_VERSION`      @id("0ccfd6") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("b95a45") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("0a7971") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("111a7b") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("502ec4") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`