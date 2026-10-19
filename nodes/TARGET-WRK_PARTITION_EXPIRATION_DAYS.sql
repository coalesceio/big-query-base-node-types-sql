@id("2b089399-a3a3-4640-aae4-dcc937c9bf21")
@nodeType("SQLWork")
@description("Work test - @partitionExpirationDays(30) on an ingestion-time partition (rows land in the load date partition)")
@partitionBy("_PARTITIONDATE")
@partitionExpirationDays(30)
SELECT
    `N_NATIONKEY`   AS `N_NATIONKEY`,
    `N_NAME`        AS `N_NAME`,
    `N_REGIONKEY`   AS `N_REGIONKEY`,
    `N_COMMENT`     AS `N_COMMENT`,
    `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`
