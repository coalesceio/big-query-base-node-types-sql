@id("25d22415-131c-43c8-b29f-dcdd91458259")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA partition - DATE(<timestamp column>): DATE(last_Modified); lastModified SCD1")
@mergeStrategy("lastModified")
@partitionBy("DATE(last_Modified)")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("e4a001") @isBusinessKey,
    `F`.`n_Name`                             AS `n_Name`              @id("e4a002"),
    `F`.`last_Modified`                      AS `last_Modified`       @id("e4a003") @lastModifiedTracking("1"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("e4a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("e4a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
