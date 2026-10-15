@id("f12a1008-90e2-4d4a-b06f-7645c1dd15d9")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - lastModified SCD1, column-level partition on the tracking TIMESTAMP")
@mergeStrategy("lastModified")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`N_NATIONKEY`                        AS `N_NATIONKEY`         @id("d3a001") @isBusinessKey @uniqueness,
    `F`.`N_NAME`                             AS `N_NAME`              @id("d3a002"),
    `F`.`N_COMMENT`                          AS `N_COMMENT`           @id("d3a003"),
    `F`.`LAST_MODIFIED`                      AS `LAST_MODIFIED`       @id("d3a004") @lastModifiedTracking("1") @partitionBy,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d3a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d3a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
