@id("dbe27eb1-95d6-459d-a674-34a40c6cc65c")
@nodeType("SQLFact")
@description("Fact test - lastModified merge; primaryKey, tableExpiration as a datetime")
@mergeStrategy("lastModified")
@tableExpiration("2026-12-31 23:59:59")
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("d20001") @isBusinessKey @not_null @uniqueness @primaryKey(1),
    `N_NAME`                             AS `N_NAME`             @id("d20002"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("d20003"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("d20004"),
    `last_modified`                      AS `last_modified`      @id("d20005") @lastModifiedTracking @not_null,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("d20006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("d20007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
