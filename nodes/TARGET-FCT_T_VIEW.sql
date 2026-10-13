@id("5f97a79e-f17d-4538-bd92-ede0258231fe")
@nodeType("729")
@description("Fact test - view; system columns come out as NULL and table-only annotations are ignored")
@materializationType("view")
@partitionBy("DATE(last_modified)")
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("d50001") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`             @id("d50002"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("d50003"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("d50004"),
    `last_modified`                      AS `last_modified`      @id("d50005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("d50006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("d50007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
