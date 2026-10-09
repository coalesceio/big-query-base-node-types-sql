@id("0ed8f710-5515-4111-8538-c5a4462a5a17")
@nodeType("728")
@description("SCD test - no @mergeStrategy (defaults to changeTracking SCD1) on WRK_REGION_ANNOTATIONS, truncateInsert, zero key with column overrides")
@writeMode("truncateInsert")
@zeroKey("-1", "'UNKNOWN'", "1900-01-01 00:00:00", true)
@tests("SELECT 1 FROM {{ this }} WHERE DIM_REGION_SCD1_DEFAULT_KEY = -1 HAVING COUNT(*) <> 1", false, "After")
@tests("SELECT 1 FROM {{ this }} GROUP BY R_REGIONKEY HAVING COUNT(*) > 1")
SELECT
    0                                         AS `DIM_REGION_SCD1_DEFAULT_KEY` @id("0ed801") @isSurrogateKey,
    `R_REGIONKEY`                             AS `R_REGIONKEY`                 @id("0ed802") @isBusinessKey @primaryKey @not_null @uniqueness @zeroKey("-1"),
    `R_NAME`                                  AS `R_NAME`                      @id("0ed803") @not_null @accepted_values("'AFRICA'") @accepted_values("'AMERICA'") @accepted_values("'ASIA'") @accepted_values("'EUROPE'") @accepted_values("'MIDDLE EAST'") @accepted_values("'UNKNOWN'"),
    `R_COMMENT`                               AS `R_COMMENT`                   @id("0ed804") @zeroKey("'N/A'") @description("Region comment"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE`          @id("0ed805") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE`          @id("0ed806") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_REGION_ANNOTATIONS') }} `WRK_REGION_ANNOTATIONS`
