@id("daf5b4bd-e5b1-4b2a-b133-79142dc4b379")
@nodeType("728")
SELECT
    0                                        AS `DIM_nation_KEY`      @id("a05d14") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("d6e16a"),
    `N_NAME`                                 AS `N_NAME`              @id("c574a7"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("8648a4"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("1f0d47"),
    `last_modified`                          AS `last_modified`       @id("e15e4e"),
    1                                        AS `SYSTEM_VERSION`      @id("ba2ed8") @isSystemVersion,
    'Y'                                      AS `SYSTEM_CURRENT_FLAG` @id("2b4d4b") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("6d2e61") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("33511b") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("69f122") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`