@id("9abeb219-c030-4fc4-8024-66a963bad596")
@nodeType("SQLWork")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY`,
     `N_NAME` AS `N_NAME`,
     `N_REGIONKEY` AS `N_REGIONKEY`,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`