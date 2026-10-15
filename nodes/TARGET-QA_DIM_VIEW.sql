@id("a50eadfd-c546-4834-be0b-f8ce08a48a71")
@nodeType("SQLDimension")
@materializationType("view")
@description("QA Dimension view - system columns become typed NULLs; merge/table annotations are ignored")
@mergeStrategy("changeTracking")
@tableExpiration("60")
@tag("env", "dev")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` IS NOT NULL OR `QA_DIM_VIEW_KEY` IS NOT NULL")
SELECT
    CAST('0' AS STRING)                      AS `QA_DIM_VIEW_KEY`     @id("d7a000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("d7a001") @isBusinessKey @uniqueness @description("Nation key"),
    `F`.`n_Name`                             AS `n_Name`              @id("d7a002") @not_null,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d7a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d7a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
