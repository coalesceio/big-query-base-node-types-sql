@id("f602cfcd-87c3-432e-acbf-b6fd8cd05189")
@nodeType("705")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY` @notNull @defaultValue("0"),
     `N_NAME` AS `N_NAME` @description("Name") @notNull @defaultValue("NA"),
     `N_REGIONKEY` AS `N_REGIONKEY` @notNull,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS `last_modified` @description("TimeStamp")
FROM {{ ref('SRC', 'nation') }} `nation`