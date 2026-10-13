@id("19710ee8-deb0-4fbc-916d-a50728668447")
@nodeType("729")
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("4169bc"),
    `N_NAME`                             AS `N_NAME`             @id("366b71"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("f761fa"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("c61d0b"),
    `last_modified`                      AS `last_modified`      @id("1fcf6b"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("175f48") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("5dfe11") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`