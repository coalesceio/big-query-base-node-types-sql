@id("4c72786a-ae26-4e5a-a13f-e3ed7aeb0d52")
@nodeType("SQLFact")
@materializationType("view")
@description("QA view - deploy 2 changes a column AND the options (tag + expiration) together, same name")
@tableExpiration("2027-06-30")
@tag("env", "dev")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("v5a001"),
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("v5a002")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
