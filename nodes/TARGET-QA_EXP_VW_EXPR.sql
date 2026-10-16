@id("0e1f2a3b-4c5d-4e6f-8a7b-9c0d1e2f3a44")
@nodeType("SQLWork")
@materializationType("view")
@description("QA tableExpiration - expression on a view: warns")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")
@tag("env", "dev")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`        ,
    `F`.`n_Name`                             AS `n_Name`             
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
