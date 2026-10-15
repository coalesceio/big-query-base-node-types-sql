@id("4a965af4-3201-4901-81d7-80ebe8d66b18")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - business key with no merge strategy (default changeTracking SCD1), truncateInsert, rounding, composite PK, NOT NULL")
@writeMode("truncateInsert")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    `F`.`N_NATIONKEY`                        AS `N_NATIONKEY`         @id("f2a001") @isBusinessKey @notNull @primaryKey(1) @uniqueness,
    `F`.`N_REGIONKEY`                        AS `N_REGIONKEY`         @id("f2a002") @notNull @primaryKey(2),
    `F`.`N_NAME`                             AS `N_NAME`              @id("f2a003"),
    CAST(`F`.`N_NATIONKEY` / 3 AS NUMERIC)   AS `AMOUNT`              @id("f2a004"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f2a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("f2a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
