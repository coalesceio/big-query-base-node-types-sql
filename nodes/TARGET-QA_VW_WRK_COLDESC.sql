@id("7ccee5ef-dd8b-49fc-8089-b74a06118e98")
@nodeType("SQLWork")
@materializationType("view")
@description("QA view - deploy 2 changes a column description only")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`     @description("Nation key"),
    `F`.`n_Name`                             AS `n_Name`          @description("Nation name")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
