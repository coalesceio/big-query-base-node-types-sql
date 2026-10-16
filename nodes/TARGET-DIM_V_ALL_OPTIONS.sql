@id("108d648a-27f4-4c6a-8717-94e2946bc13c")
@nodeType("SQLDimension")
@materializationType("view")
@description("Create test - view with description, tags and table expiration; every column has a description")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `n_NationKey`   AS `N_NATIONKEY`   @id("c7e964") @description("Nation key"),
    `n_Name`        AS `N_NAME`        @id("9eb5b2") @description("Nation name"),
    `n_RegionKey`   AS `N_REGIONKEY`   @id("35c81a") @description("Region key"),
    `n_Comment`     AS `N_COMMENT`     @id("450216") @description("Free-text comment"),
    `last_Modified` AS `last_modified` @id("fdb53f") @description("Source last modified time")
FROM {{ ref('SRC', 'Nation_Test_CamelCase') }} `Nation_Test_CamelCase`