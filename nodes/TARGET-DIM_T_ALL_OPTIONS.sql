@id("0c817b9a-085e-4062-abf9-ef09cf81e81b")
@nodeType("SQLDimension")
@materializationType("table")
@description("Create test - table with every create option: column partition + expiration, clustering, composite primary key, NOT NULL, default, descriptions, tags, table expiration, rounding mode, zero key")
@mergeStrategy("changeTracking")
@partitionExpirationDays("365")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
@zeroKey("0")
SELECT
    0                                        AS `DIM_T_ALL_OPTIONS_KEY`  @id("846ca8") @isSurrogateKey @description("Surrogate key"),
    `n_NationKey`                            AS `N_NATIONKEY`            @id("1ab55d") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @description("Nation key - business key"),
    `n_Name`                                 AS `N_NAME`                 @id("37c4d0") @notNull @clusterKey(2) @description("Nation name"),
    CAST(COALESCE(`n_RegionKey`, -1) AS INT64) AS `N_REGIONKEY`            @id("4e49a5") @notNull @primaryKey(2) @clusterKey(3) @description("Region key"),
    `n_Comment`                              AS `N_COMMENT`              @id("74f596") @defaultValue("'NA'") @description("Free-text comment, defaults to NA"),
    CAST(`n_NationKey` / 7 AS NUMERIC)         AS `N_NATIONKEY_RATIO`      @id("8c855e") @description("Rounded with the table default_rounding_mode"),
    CAST(DATE(`last_Modified`) AS DATE)        AS `LOAD_DATE`              @id("9335b5") @partitionBy @notNull @zeroKey("CURRENT_DATE()") @description("Partition column (column-level partitionBy)"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`     @id("9ca7bf") @isSystemCreateDate @description("Row create time"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`     @id("4b2965") @isSystemUpdateDate @description("Row update time")
FROM {{ ref('SRC', 'Nation_Test_CamelCase') }} `Nation_Test_CamelCase`