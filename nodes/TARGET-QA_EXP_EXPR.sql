@id("0e1f2a3b-4c5d-4e6f-8a7b-9c0d1e2f3a43")
@nodeType("SQLWork")
@materializationType("table")
@description("QA tableExpiration - expression: warns; re-evaluated on every create or alter")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("ex3a1"),
    `F`.`n_Name`                             AS `n_Name`              @id("ex3a2"),
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("ex3a3")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
