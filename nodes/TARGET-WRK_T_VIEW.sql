@id("167fa3a6-daa4-4786-99fa-aa82f4f7d8dd")
@nodeType("SQLWork")
@description("Work test - view; table-only annotations below must be ignored")
@materializationType("view")
@partitionBy("DATE(last_modified)")
@tableExpiration("30")
@tag("env", "dev")
SELECT
    `N_NATIONKEY`   AS `N_NATIONKEY`   @primaryKey(1),
    `N_NAME`        AS `N_NAME`,
    `N_REGIONKEY`   AS `N_REGIONKEY`   @clusterKey(1),
    `N_COMMENT`     AS `N_COMMENT`,
    `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`
