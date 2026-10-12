@id("0fb88ba4-1854-40cb-a593-1680782f0d4b")
@nodeType("728")
@description("Test - upsert; defaultRoundingMode on a NUMERIC column and two table tags")
@mergeStrategy("upsert")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    0                                    AS `DIM_T_UPSERT_ROUNDING_TAGS_KEY` @id("b50001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`                    @id("b50002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`                         @id("b50003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`                    @id("b50004"),
    `N_COMMENT`                          AS `N_COMMENT`                      @id("b50005"),
    `last_modified`                      AS `last_modified`                  @id("b50006"),
    CAST(`N_NATIONKEY` / 7 AS NUMERIC)   AS `N_NATIONKEY_RATIO`              @id("b50007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`             @id("b50008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`             @id("b50009") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
