@id("805fa3f4-c1ef-4c3b-b88d-d741437419a9")
@nodeType("SQLFact")
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("999933"),
    `N_NAME`                             AS `N_NAME`             @id("d7ee88"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("8185d3"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("91b2db"),
    `last_modified`                      AS `last_modified`      @id("e8962b"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("5f2c1c") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("e4c716") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`