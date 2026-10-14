@id("25862a23-f915-46e0-af0a-3c409fc8ed78")
@nodeType("SQLFact")
@description("Fact test - upsert merge with truncateInsert; defaultRoundingMode and tags")
@mergeStrategy("upsert")
@writeMode("truncateInsert")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
@tag("env", "dev")
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("d30001") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`             @id("d30002"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("d30003"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("d30004"),
    `last_modified`                      AS `last_modified`      @id("d30005"),
    CAST(`N_NATIONKEY` / 7 AS NUMERIC)   AS `N_NATIONKEY_RATIO`  @id("d30006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("d30007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("d30008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
