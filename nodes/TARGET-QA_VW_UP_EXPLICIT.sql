@id("e5f6a7b8-3c4d-4e5f-9a0b-1c2d3e4f5a62")
@nodeType("SQLWork")
@materializationType("view")
@description("QA view naming upstream columns explicitly - breaks when QA_VW_UP_SRC renames/drops them")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) = 0")
SELECT
    `S`.`n_NationKey`                        AS `n_NationKey`,
    `S`.`n_Name`                             AS `n_Name`,
    `S`.`n_Comment`                          AS `n_Comment`
FROM {{ ref('TARGET', 'QA_VW_UP_SRC') }} `S`
