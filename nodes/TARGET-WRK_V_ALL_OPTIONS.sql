@id("53fa4898-f37f-422b-9b8a-79b6ece6271c")
@nodeType("SQLWork")
@materializationType("view")
@description("Create test - Work view with description, tags and table expiration; every column has a description")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `n_NationKey`   AS `N_NATIONKEY`   @id("157369") @description("Nation key"),
    `n_Name`        AS `N_NAME`        @id("3c2da4") @description("Nation name"),
    `n_RegionKey`   AS `N_REGIONKEY`   @id("6e1988") @description("Region key"),
    `n_Comment`     AS `N_COMMENT`     @id("21d8c2") @description("Free-text comment"),
    `last_Modified` AS `last_modified` @id("d5bfb0") @description("Source last modified time")
FROM {{ ref('SRC', 'Nation_Test_CamelCase') }} `Nation_Test_CamelCase`
