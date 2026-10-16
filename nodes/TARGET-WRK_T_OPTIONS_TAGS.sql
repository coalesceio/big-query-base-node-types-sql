@id("518bf292-e432-40f4-94ff-435477e764ac")
@nodeType("SQLWork")
@description("Work test - tableExpiration in days, defaultRoundingMode, tags")
@tableExpiration("2999-12-31")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `N_NATIONKEY`                      AS `N_NATIONKEY`,
    `N_NAME`                           AS `N_NAME`,
    `N_REGIONKEY`                      AS `N_REGIONKEY`,
    CAST(`N_NATIONKEY` / 7 AS NUMERIC) AS `N_NATIONKEY_RATIO`,
    `last_modified`                    AS `last_modified`
FROM {{ ref('SRC', 'nation') }} `nation`