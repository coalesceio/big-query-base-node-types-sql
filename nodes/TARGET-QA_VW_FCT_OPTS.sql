@id("428d3442-b6fb-4812-b06a-48869db19846")
@nodeType("SQLFact")
@materializationType("view")
@tableExpiration("2027-09-30 12:00:00")
@tag("env", "dev")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("v3a001") @not_null,
    CAST(`F`.`n_NationKey` * 3 AS NUMERIC)   AS `Amount`              @id("v3a002")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
