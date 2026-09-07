@id("5b141e63-4dd9-4da3-aefa-02c0b5f5687c")
@nodeType("705")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY`,
     `N_NAME` AS `N_NAME`,
     `N_REGIONKEY` AS `N_REGIONKEY`,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS `last_modified`
FROM {{ ref('TARGET', 'wrk_nation_v1_VIEW') }} `wrk_nation_v1_VIEW`