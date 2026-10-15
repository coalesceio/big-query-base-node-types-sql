@id("f12a1008-90e2-4d4a-b06f-7645c1dd15d9")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - lastModified SCD1, column-level partition on the tracking TIMESTAMP")
@mergeStrategy("lastModified")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("d3a001") @isBusinessKey @uniqueness,
    `F`.`n_Name`                             AS `n_Name`              @id("d3a002"),
    `F`.`n_Comment`                          AS `n_Comment`           @id("d3a003"),
    `F`.`last_Modified`                      AS `last_Modified`       @id("d3a004") @lastModifiedTracking("1") @partitionBy,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d3a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d3a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
