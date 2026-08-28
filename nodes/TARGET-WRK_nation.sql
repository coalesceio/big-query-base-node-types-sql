@id("9b7afbc0-269f-41ba-ac77-217fb6e42178")
@nodeType("705")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY` @notNull @description("<text>") @defaultValue("0"),
     `N_NAME` AS `N_NAME` @notNull @description("<text>") @defaultValue("'<value>'"),
     `N_REGIONKEY` AS `N_REGIONKEY` @notNull @description("<text>") @defaultValue("0"),
     `N_COMMENT` AS `N_COMMENT` @notNull @description("<text>") @defaultValue("'<value>'"),
     `last_modified` AS `LAST_MODIFIED` @notNull @description("<text>") @defaultValue("CURRENT_TIMESTAMP")
FROM {{ ref('SRC', 'nation') }} `nation`