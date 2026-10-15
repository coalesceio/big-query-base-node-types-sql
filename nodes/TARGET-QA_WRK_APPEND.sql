@id("2294c12c-2cc3-4e50-9684-e3d863a5fa99")
@nodeType("SQLWork")
@materializationType("table")
@description("QA Work table - append write mode, integer-range partition (partitionExpirationDays must only warn)")
@writeMode("append")
@partitionBy("RANGE_BUCKET(n_NationKey, GENERATE_ARRAY(0, 100, 10))")
@partitionExpirationDays("30")
@tests("SELECT 1 FROM {{ this }} WHERE `LOADED_AT` = (SELECT MAX(`LOADED_AT`) FROM {{ this }}) HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})", true, "After")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`    @not_null,
    `F`.`n_Name`                             AS `n_Name`,
    CAST(CURRENT_TIMESTAMP() AS TIMESTAMP)   AS `LOADED_AT`      @not_null @description("One value per load batch")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
