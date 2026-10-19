@id("79b598f1-1b5a-484f-a36a-e613c8803fbb")
@nodeType("SQLWork")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY`,
     `N_NAME` AS `N_NAME`,
     `N_REGIONKEY` AS `N_REGIONKEY`,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`