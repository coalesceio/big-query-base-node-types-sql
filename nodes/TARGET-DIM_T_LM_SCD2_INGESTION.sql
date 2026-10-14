@id("d256060c-e14d-4ff1-b3c5-d2726612dad1")
@nodeType("728")
@description("Test - lastModified SCD Type 2; ingestion-time partition, tableExpiration as a date")
@mergeStrategy("lastModified")
@tableExpiration("2026-12-31")
SELECT
    0                                        AS `DIM_T_LM_SCD2_INGESTION_KEY` @id("b40001") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`                 @id("b40002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`                      @id("b40003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`                 @id("b40004"),
    `N_COMMENT`                              AS `N_COMMENT`                   @id("b40005"),
    `last_modified`                          AS `last_modified`               @id("b40006") @lastModifiedTracking(2) @not_null,
    1                                        AS `SYSTEM_VERSION`              @id("b40007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`         @id("b40008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`          @id("b40009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`          @id("b4000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`             @id("b4000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
