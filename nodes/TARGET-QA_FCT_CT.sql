@id("4a965af4-3201-4901-81d7-80ebe8d66b18")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - business key with no merge strategy (default changeTracking SCD1), truncateInsert, rounding, composite PK, NOT NULL (phase 2: PK column n_RegionKey renamed to Region_Key, column with default added)")
@writeMode("truncateInsert")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
@tests("SELECT 1 FROM {{ this }} WHERE `n_NationKey` = 24 OR `Load_Note` <> 'phase2' OR `Region_Key` IS NULL")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("f2a001") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @uniqueness,
    `F`.`n_RegionKey`                        AS `Region_Key`          @id("f2a002") @notNull @primaryKey(2),
    `F`.`n_Name`                             AS `n_Name`              @id("f2a003"),
    CAST(`F`.`n_NationKey` / 3 AS NUMERIC)   AS `AMOUNT`              @id("f2a004"),
    CAST('phase2' AS STRING)                 AS `Load_Note`           @id("f2a00a") @defaultValue("'n/a'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f2a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("f2a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
