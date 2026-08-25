@id("f602cfcd-87c3-432e-acbf-b6fd8cd05189")
@nodeType("705")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY`,
     `N_NAME` AS `N_NAME`,
     `N_REGIONKEY` AS `N_REGIONKEY`,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`