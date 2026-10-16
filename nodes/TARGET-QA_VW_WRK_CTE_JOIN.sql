@id("ad08b04a-2719-4ca4-bef5-8f95dae7efd4")
@nodeType("SQLWork")
@materializationType("view")
@description("QA view - CTE + join of two upstream nodes, tag, fixed expiration")
@tableExpiration("2027-06-30")
@tag("env", "dev")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
WITH `REGION_COUNTS` AS (
    SELECT
        `D`.`n_RegionKey`                    AS `n_RegionKey`,
        MAX(`D`.`Nation_Count`)              AS `NATION_COUNT`
    FROM {{ ref('TARGET', 'QA_WRK_CTE_DISTINCT') }} `D`
    GROUP BY `D`.`n_RegionKey`
)
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`     @uniqueness,
    UPPER(`F`.`n_Name`)                      AS `Nation_Label`    @not_null,
    CAST(`R`.`NATION_COUNT` AS NUMERIC)      AS `Region_Nations`  @min_value("1")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
INNER JOIN `REGION_COUNTS` `R`
    ON `F`.`n_RegionKey` = `R`.`n_RegionKey`
