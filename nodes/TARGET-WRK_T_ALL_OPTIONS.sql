@id("3ad73f01-5c3b-4c3c-80f6-19ad2893c86b")
@nodeType("SQLWork")
@materializationType("table")
@description("Create test - Work table with every create option: column partition + expiration, clustering, composite primary key, NOT NULL, default, descriptions, tags, table expiration, rounding mode")
@partitionExpirationDays("365")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `n_NationKey`                            AS `N_NATIONKEY`            @id("955b0b") @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @description("Nation key"),
    `n_Name`                                 AS `N_NAME`                 @id("8cb686") @notNull @clusterKey(2) @description("Nation name"),
    CAST(COALESCE(`n_RegionKey`, -1) AS INT64) AS `N_REGIONKEY`            @id("12b7d6") @notNull @primaryKey(2) @clusterKey(3) @description("Region key"),
    `n_Comment`                              AS `N_COMMENT`              @id("0e3cd7") @defaultValue("'NA'") @description("Free-text comment, defaults to NA"),
    CAST(`n_NationKey` / 7 AS NUMERIC)         AS `N_NATIONKEY_RATIO`      @id("100262") @description("Rounded with the table default_rounding_mode"),
    CAST(DATE(`last_Modified`) AS DATE)        AS `LOAD_DATE`              @id("ce0733") @partitionBy @notNull @description("Partition column (column-level partitionBy)")
FROM {{ ref('SRC', 'Nation_Test_CamelCase') }} `Nation_Test_CamelCase`