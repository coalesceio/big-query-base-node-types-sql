@id("0cdb6779-04cb-4f4a-b6c5-e3cb6490c065")
@nodeType("SQLDimension")
@description("Rounding mode test - defaultRoundingMode ROUND_HALF_AWAY_FROM_ZERO (explicit BigQuery default) on NUMERIC columns; changeTracking SCD Type 2")
@mergeStrategy("changeTracking")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
SELECT
    CAST("0" AS STRING)                      AS `DIM_RM_HALF_AWAY_FROM_ZERO_KEY` @id("aa0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `L_ORDERKEY`                             AS `L_ORDERKEY`                     @id("aa0002") @isBusinessKey @not_null,
    `L_LINENUMBER`                           AS `L_LINENUMBER`                   @id("aa0003") @isBusinessKey @not_null,
    CAST(`L_QUANTITY` AS NUMERIC)            AS `L_QUANTITY`                     @id("aa0004"),
    CAST(`L_EXTENDEDPRICE` AS NUMERIC)       AS `L_EXTENDEDPRICE`                @id("aa0005"),
    CAST(`L_DISCOUNT` AS NUMERIC)            AS `L_DISCOUNT`                     @id("aa0006"),
    `L_LINESTATUS`                           AS `L_LINESTATUS`                   @id("aa0007") @isChangeTracking,
    `L_SHIPDATE`                             AS `L_SHIPDATE`                     @id("aa0008"),
    1                                        AS `SYSTEM_VERSION`                 @id("aa0009") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`            @id("aa000a") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`             @id("aa000b") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`             @id("aa000c") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`                @id("aa000d") @isSystemEndDate
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
