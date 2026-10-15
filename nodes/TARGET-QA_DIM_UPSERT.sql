@id("7efd8743-4d5e-4c7b-b34e-a6e583a6757c")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - upsert with no system columns; tracking annotations present only to raise the ignored-annotation warnings")
@mergeStrategy("upsert")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> 1 + (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
@tests("SELECT 1 FROM {{ this }} WHERE `n_NationKey` = 1 AND `n_Label` <> 'ARGENTINA_V2 / 0'")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("d5a001") @isBusinessKey @primaryKey(1),
    `F`.`n_Name`                             AS `n_Name`              @id("d5a002") @isChangeTracking,
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("d5a003"),
    CAST(CONCAT(`F`.`n_Name`, ' / ', CAST(`F`.`n_RegionKey` AS STRING)) AS STRING) AS `n_Label` @id("d5a004") @not_null,
    `F`.`last_Modified`                      AS `last_Modified`       @id("d5a005") @lastModifiedTracking("1")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
