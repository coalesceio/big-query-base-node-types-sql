@id("0e1f2a3b-4c5d-4e6f-8a7b-9c0d1e2f3a42")
@nodeType("SQLFact")
@materializationType("table")
@description("QA tableExpiration - datetime: expires 2999-12-31 00:00:00, fixed")
@tableExpiration("2999-12-31 00:00:00")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("ex2a1"),
    `F`.`n_Name`                             AS `n_Name`              @id("ex2a2")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
