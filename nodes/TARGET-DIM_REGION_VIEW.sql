@id("bfcc3de7-b128-4f5a-b08e-cd6fe117ee1e")
@nodeType("728")
@description("SCD test - Dimension materialized as a view on WRK_REGION_ANNOTATIONS; merge, zero key, write mode and pre/post SQL are ignored")
@materializationType("view")
@mergeStrategy("changeTracking")
@writeMode("truncateInsert")
@zeroKey("-1")
@preSQL("SELECT 1")
@postSQL("SELECT 1")
@tests("SELECT 1 FROM {{ this }} GROUP BY R_REGIONKEY HAVING COUNT(*) > 1")
SELECT
    0                                         AS `DIM_REGION_VIEW_KEY` @id("bfcc01") @isSurrogateKey,
    `R_REGIONKEY`                             AS `R_REGIONKEY`         @id("bfcc02") @isBusinessKey @primaryKey @not_null @uniqueness,
    `R_NAME`                                  AS `R_NAME`              @id("bfcc03") @isChangeTracking,
    `R_COMMENT`                               AS `R_COMMENT`           @id("bfcc04"),
    1                                         AS `SYSTEM_VERSION`      @id("bfcc05") @isSystemVersion,
    CAST('Y' AS STRING)                       AS `SYSTEM_CURRENT_FLAG` @id("bfcc06") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE`  @id("bfcc07") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE`  @id("bfcc08") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP)  AS `SYSTEM_END_DATE`     @id("bfcc09") @isSystemEndDate
FROM {{ ref('TARGET', 'WRK_REGION_ANNOTATIONS') }} `WRK_REGION_ANNOTATIONS`
