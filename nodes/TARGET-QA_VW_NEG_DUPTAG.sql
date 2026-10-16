@id("e6246995-c78b-4f65-a4e6-65340c096a52")
@nodeType("SQLWork")
@materializationType("view")
@description("QA negative - the same tag key twice (env written short and project-qualified) must stop the deploy; a column @tag must only warn")
@tag("env", "dev")
@tag("cls-dev-bigquery/env", "dev")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`     @tag("env", "dev"),
    `F`.`n_Name`                             AS `n_Name`
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
