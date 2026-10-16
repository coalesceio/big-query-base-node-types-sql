@id("2e889f7a-2975-4657-9c22-a43144a0a2f4")
@nodeType("SQLFact")
@materializationType("view")
@description("Create test - Fact view with description, tags and table expiration; every column has a description")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `n_NationKey`   AS `N_NATIONKEY`   @id("09cfa8") @description("Nation key"),
    `n_Name`        AS `N_NAME`        @id("192503") @description("Nation name"),
    `n_RegionKey`   AS `N_REGIONKEY`   @id("ba644e") @description("Region key"),
    `n_Comment`     AS `N_COMMENT`     @id("954614") @description("Free-text comment"),
    `last_Modified` AS `last_modified` @id("80f1a1") @description("Source last modified time")
FROM {{ ref('SRC', 'Nation_Test_CamelCase') }} `Nation_Test_CamelCase`