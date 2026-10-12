@id("5faea46e-6ec8-49a1-9f4a-6f19d7806d04")
@nodeType("728")
@description("Test - defaultRoundingMode ROUND_HALF_AWAY_FROM_ZERO on a NUMERIC column; lastModified SCD Type 1")
@mergeStrategy("lastModified")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
SELECT
    0                                    AS `DIM_T_ROUNDING_AWAY_FROM_ZERO_KEY` @id("c50001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`                       @id("c50002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`                            @id("c50003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`                       @id("c50004"),
    `N_COMMENT`                          AS `N_COMMENT`                         @id("c50005"),
    `last_modified`                      AS `last_modified`                     @id("c50006") @lastModifiedTracking(1) @not_null,
    CAST(`N_NATIONKEY` / 7 AS NUMERIC)   AS `N_NATIONKEY_RATIO`                 @id("c50007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`                @id("c50008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`                @id("c50009") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
