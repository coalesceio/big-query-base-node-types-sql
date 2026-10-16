@id("d4e5f6a7-2b3c-4d5e-8f9a-0b1c2d3e4f51")
@nodeType("SQLWork")
@materializationType("table")
@description("QA upstream table for views - deploy 2 renames n_Name and drops n_Comment while the views stay unchanged")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("up0001"),
    `F`.`n_Name`                             AS `Nation_Name`         @id("up0002"),
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("up0003")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
