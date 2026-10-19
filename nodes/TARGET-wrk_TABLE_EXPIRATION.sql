@id("2e9dd738-716a-4af0-81c8-5dace00223e6")
@nodeType("SQLWork")
@description("Work test - @tableExpiration with a fixed datetime")
@tableExpiration("2027-12-31 23:59:59")
SELECT
    `N_NATIONKEY`   AS `N_NATIONKEY`,
    `N_NAME`        AS `N_NAME`,
    `N_REGIONKEY`   AS `N_REGIONKEY`,
    `N_COMMENT`     AS `N_COMMENT`,
    `last_modified` AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`
