@id("802b3088-1c4f-43de-add2-a76c30c7e059")
@nodeType("SQLWork")
@description("Work test - repeatable @tag: env = dev and cost_center = finance")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `N_NATIONKEY`   AS `N_NATIONKEY`,
    `N_NAME`        AS `N_NAME`,
    `N_REGIONKEY`   AS `N_REGIONKEY`,
    `N_COMMENT`     AS `N_COMMENT`,
    `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`
