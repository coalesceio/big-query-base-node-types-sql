@id("0e1f2a3b-4c5d-4e6f-8a7b-9c0d1e2f3a41")
@nodeType("SQLWork")
@materializationType("table")
@description("QA tableExpiration - date only: expires 2999-12-31 23:59:59, fixed")
@tableExpiration("2999-12-31")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("ex1a1"),
    `F`.`n_Name`                             AS `n_Name`              @id("ex1a2"),
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("ex1a3")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
