@id("b1d8fe49-1c29-40f7-a489-816595091b2b")
@nodeType("728")
@description("Primary key test - lastModified SCD Type 1, PK on N_NATIONKEY")
@mergeStrategy("lastModified")
SELECT
    0                                    AS `DIM_NATION_PRIMARY_KEY_KEY` @id("b10001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`                @id("b10002") @isBusinessKey @not_null @uniqueness @primaryKey,
    `N_NAME`                             AS `N_NAME`                     @id("b10003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`                @id("b10004"),
    `N_COMMENT`                          AS `N_COMMENT`                  @id("b10005"),
    `last_modified`                      AS `last_modified`              @id("b10006") @lastModifiedTracking(1) @not_null,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`         @id("b10007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`         @id("b10008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
