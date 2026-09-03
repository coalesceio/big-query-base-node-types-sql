@id("ba6285ad-ebb3-4ac8-acb1-742f1f668aab")
@nodeType("705")
SELECT ALL
     `N_NATIONKEY` AS `N_NATIONKEY`,
     `N_NAME` AS `N_NAME`,
     `N_REGIONKEY` AS `N_REGIONKEY`,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`
where `N_NATIONKEY` = {{ parameters.nationkey }}