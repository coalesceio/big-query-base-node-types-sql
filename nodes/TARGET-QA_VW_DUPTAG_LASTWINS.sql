@id("b3f1c2a4-7d2e-4c61-9a0b-5e8f1d3c7a21")
@nodeType("SQLWork")
@materializationType("view")
@description("QA duplicate tags on a view - env applied 3 times (short, qualified, short): warning only, last value 'prod' applied; cost_center once")
@tag("env", "dev")
@tag("cls-dev-bigquery/env", "test")
@tag("cost_center", "finance")
@tag("env", "prod")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`,
    `F`.`n_Name`                             AS `n_Name`
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
