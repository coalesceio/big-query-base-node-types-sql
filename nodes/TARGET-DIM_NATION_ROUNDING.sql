@id("44af238c-fc7e-47d8-9d10-181cd47a843f")
@nodeType("728")
@description("Default rounding mode test - upsert, NUMERIC columns round half to even")
@mergeStrategy("upsert")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
SELECT
    0                                    AS `DIM_NATION_ROUNDING_KEY` @id("d10001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`             @id("d10002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`                  @id("d10003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`             @id("d10004"),
    `N_COMMENT`                          AS `N_COMMENT`               @id("d10005"),
    `last_modified`                      AS `last_modified`           @id("d10006"),
    CAST(`N_NATIONKEY` / 7 AS NUMERIC)   AS `N_NATIONKEY_RATIO`       @id("d10007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`      @id("d10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`      @id("d10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
