@id("7c072b64-e563-47d9-bb3c-c9fae55aee0b")
@nodeType("705")
@materializationType("view")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY`,
     `N_NAME` AS `N_NAME`,
     `N_REGIONKEY` AS `N_REGIONKEY`,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS `last_modified`
FROM {{ ref('TARGET', 'wrk_nation_v1_VIEW') }} `wrk_nation_v1_VIEW`