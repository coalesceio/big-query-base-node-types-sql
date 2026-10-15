@id("a20cd209-844f-457d-88d7-e5fcbb7c4d72")
@nodeType("SQLWork")
@materializationType("table")
@description("QA Work - two CTEs (aggregate + projection) joined, SELECT DISTINCT")
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_RegionKey`, `Name_Initial`, `Nation_Count` HAVING COUNT(*) > 1")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(DISTINCT CONCAT(CAST(`n_RegionKey` AS STRING), '|', UPPER(SUBSTR(`n_Name`, 1, 1)))) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
WITH `REGION_COUNTS` AS (
    SELECT
        `F`.`n_RegionKey`                    AS `n_RegionKey`,
        COUNT(*)                             AS `NATION_COUNT`
    FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
    GROUP BY `F`.`n_RegionKey`
),
`NATIONS` AS (
    SELECT
        `F`.`n_NationKey`                    AS `n_NationKey`,
        `F`.`n_RegionKey`                    AS `n_RegionKey`,
        UPPER(SUBSTR(`F`.`n_Name`, 1, 1))    AS `NAME_INITIAL`
    FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
)
SELECT DISTINCT
    CAST(`N`.`n_RegionKey` AS INT64)         AS `n_RegionKey`     @not_null,
    CAST(`N`.`NAME_INITIAL` AS STRING)       AS `Name_Initial`    @not_null @empty,
    CAST(`R`.`NATION_COUNT` AS INT64)        AS `Nation_Count`    @min_value("1")
FROM `NATIONS` `N`
INNER JOIN `REGION_COUNTS` `R`
    ON `N`.`n_RegionKey` = `R`.`n_RegionKey`
