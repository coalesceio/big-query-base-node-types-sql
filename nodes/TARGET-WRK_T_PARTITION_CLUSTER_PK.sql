@id("d7a9dfa2-456b-46ca-996f-5e6fecabd1a5")
@nodeType("SQLWork")
@description("Work test - partitionBy with partitionExpirationDays, clusterKey, composite primaryKey")
@partitionBy("DATE(last_modified)")
@partitionExpirationDays(30)
SELECT
    `N_NATIONKEY`   AS `N_NATIONKEY`   @primaryKey(2) @clusterKey(2),
    `N_NAME`        AS `N_NAME`,
    `N_REGIONKEY`   AS `N_REGIONKEY`   @primaryKey(1) @clusterKey(1),
    `N_COMMENT`     AS `N_COMMENT`,
    `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`
