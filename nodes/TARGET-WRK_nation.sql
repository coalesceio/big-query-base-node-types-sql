@id("1012afe3-138a-48da-be26-c0268711e117")
@nodeType("705")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY`,
     `N_NAME` AS `N_NAME`,
     `N_REGIONKEY` AS `N_REGIONKEY`,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`