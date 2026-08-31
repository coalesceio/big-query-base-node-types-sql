@id("48249bc7-a597-4502-b298-341512817135")
@nodeType("705")
SELECT DISTINCT
     `N_NATIONKEY` AS `N_NATIONKEY`,
     `N_NAME` AS `N_NAME`,
     `N_REGIONKEY` AS `N_REGIONKEY`,
     `N_COMMENT` AS `N_COMMENT`,
     `last_modified` AS L_M_1 @relative_time("<", "L_M_2"),
     `last_modified` AS L_M_2
FROM {{ ref('SRC', 'nation') }} `nation`