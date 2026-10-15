@id("406dac2b-535c-467f-aebd-07ac1f0024c8")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA partition - integer range as in the README: RANGE_BUCKET(n_NationKey, GENERATE_ARRAY(0, 100, 5)); changeTracking SCD1")
@partitionBy("RANGE_BUCKET(n_NationKey, GENERATE_ARRAY(0, 100, 5))")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("e5a001") @isBusinessKey,
    `F`.`n_Name`                             AS `n_Name`              @id("e5a002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("e5a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("e5a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
