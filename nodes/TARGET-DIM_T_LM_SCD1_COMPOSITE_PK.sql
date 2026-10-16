@id("2082b8fc-7162-40d5-8c6c-81af94d1f468")
@nodeType("SQLDimension")
@description("Test - lastModified SCD Type 1; composite primaryKey ordered by position, tableExpiration in days")
@mergeStrategy("lastModified")
@tableExpiration("2999-12-31")
SELECT
    0                                    AS `DIM_T_LM_SCD1_COMPOSITE_PK_KEY` @id("b30001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`                    @id("b30002") @isBusinessKey @not_null @uniqueness @primaryKey(2),
    `N_NAME`                             AS `N_NAME`                         @id("b30003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`                    @id("b30004") @primaryKey(1),
    `N_COMMENT`                          AS `N_COMMENT`                      @id("b30005"),
    `last_modified`                      AS `last_modified`                  @id("b30006") @lastModifiedTracking(1) @not_null,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`             @id("b30007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`             @id("b30008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`