@id("d17931d4-289b-47f5-96b8-43f56e746f34")
@nodeType("728")
SELECT
    0                                        AS `DIM_nation_KEY`      @id("657e5a") @isSurrogateKey ,
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("36cec4") @isBusinessKey,
    `N_NAME`                                 AS `N_NAME`              @id("3e1070"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("95bb63"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("8360c7"),
    `last_modified`                          AS `last_modified`       @id("a52f7a"),
    1                                        AS `SYSTEM_VERSION`      @id("cde022") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("1b1646") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("86371b") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("b1a9fb") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("23533d") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`