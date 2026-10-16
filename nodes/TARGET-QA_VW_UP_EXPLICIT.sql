@id("e5f6a7b8-3c4d-4e5f-9a0b-1c2d3e4f5a62")
@nodeType("SQLWork")
@materializationType("view")
@description("QA view naming upstream columns explicitly - deploy 4 points it at the renamed column; the dropped column is gone")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) = 0")
SELECT
    `S`.`n_NationKey`                        AS `n_NationKey`,
    `S`.`Nation_Name`                        AS `n_Name`
FROM {{ ref('TARGET', 'QA_VW_UP_SRC') }} `S`
