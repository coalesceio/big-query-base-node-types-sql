@id("9933b852-21b8-43aa-a655-f49255628598")
@nodeType("SQLFact")
@materializationType("table")
@description("Create test - Fact table with every create option: column partition + expiration, clustering, composite primary key, NOT NULL, default, descriptions, tags, table expiration, rounding mode")
@mergeStrategy("changeTracking")
@partitionExpirationDays("365")
@tableExpiration("30")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `n_NationKey`                            AS `N_NATIONKEY`            @id("0a8ac1") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @description("Nation key - business key"),
    `n_Name`                                 AS `N_NAME`                 @id("26c970") @notNull @clusterKey(2) @description("Nation name"),
    CAST(COALESCE(`n_RegionKey`, -1) AS INT64) AS `N_REGIONKEY`            @id("477456") @notNull @primaryKey(2) @clusterKey(3) @description("Region key"),
    `n_Comment`                              AS `N_COMMENT`              @id("e11899") @defaultValue("'NA'") @description("Free-text comment, defaults to NA"),
    CAST(`n_NationKey` / 7 AS NUMERIC)         AS `N_NATIONKEY_RATIO`      @id("d9af30") @description("Rounded with the table default_rounding_mode"),
    CAST(DATE(`last_Modified`) AS DATE)        AS `LOAD_DATE`              @id("ef6d40") @partitionBy @notNull @description("Partition column (column-level partitionBy)"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`     @id("84a1d4") @isSystemCreateDate @description("Row create time"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`     @id("6180c1") @isSystemUpdateDate @description("Row update time")
FROM {{ ref('SRC', 'Nation_Test_CamelCase') }} `Nation_Test_CamelCase`
