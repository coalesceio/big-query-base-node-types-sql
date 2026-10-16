@id("15f1b8dc-dbff-4ee9-ad7b-df9e3b447c09")
@nodeType("SQLWork")
@materializationType("table")
@description("QA switch - deploy 1 table, deploy 2 view, deploy 3 table again")
@tableExpiration("2027-06-30")
@tag("env", "dev")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`,
    `F`.`n_Name`                             AS `n_Name`
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
