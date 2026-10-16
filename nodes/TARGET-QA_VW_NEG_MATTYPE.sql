@id("a7b8c9d0-5e6f-4a7b-9c2d-3e4f5a6b7c84")
@nodeType("SQLFact")
@materializationType("materialized view")
@description("QA negative - unsupported materialization type on a new node must stop the deploy before create")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`,
    `F`.`n_Name`                             AS `n_Name`
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
