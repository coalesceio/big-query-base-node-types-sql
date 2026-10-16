@id("c8a2d4e6-1b3f-4e5a-8c7d-9f0e2a4b6c83")
@nodeType("SQLFact")
@materializationType("table")
@description("QA duplicate tags on a table - env applied twice (short then qualified): warning only, last value 'prod' applied")
@tag("env", "dev")
@tag("cost_center", "finance")
@tag("cls-dev-bigquery/env", "prod")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("dt0001"),
    `F`.`n_Name`                             AS `n_Name`              @id("dt0002")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
