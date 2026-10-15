@id("eafa1304-e461-4976-bf47-5d9d4bd44ef8")
@nodeType("729")
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("f177c6"),
    `N_NAME`                             AS `N_NAME`             @id("d4337a"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("150400"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("84c532"),
    `last_modified`                      AS `last_modified`      @id("dcefa8"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("f9ef86") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("7a9049") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`