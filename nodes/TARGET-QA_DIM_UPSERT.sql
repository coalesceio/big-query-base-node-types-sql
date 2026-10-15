@id("7efd8743-4d5e-4c7b-b34e-a6e583a6757c")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - upsert with no system columns; tracking annotations present only to raise the ignored-annotation warnings")
@mergeStrategy("upsert")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`N_NATIONKEY`                        AS `N_NATIONKEY`         @id("d5a001") @isBusinessKey @primaryKey(1),
    `F`.`N_NAME`                             AS `N_NAME`              @id("d5a002") @isChangeTracking,
    `F`.`N_REGIONKEY`                        AS `N_REGIONKEY`         @id("d5a003"),
    CONCAT(`F`.`N_NAME`, ' / ', CAST(`F`.`N_REGIONKEY` AS STRING)) AS `N_LABEL` @id("d5a004") @not_null,
    `F`.`LAST_MODIFIED`                      AS `LAST_MODIFIED`       @id("d5a005") @lastModifiedTracking("1")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
