@id("1bcfabbf-a801-42a1-8588-c716b04e3840")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA get_hash in a Dimension - SHA256 hash of the natural key as the business key, MD5 row hash as the tracked column (SCD2), SHA512 no-delimiter hash, NULL handling")
@mergeStrategy("changeTracking")
@tests("SELECT 1 FROM {{ this }} WHERE `Nation_HK` IS DISTINCT FROM TO_HEX(SHA256(IFNULL(CAST(`n_NationKey` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `Row_Hash` IS DISTINCT FROM TO_HEX(MD5(IFNULL(CAST(`n_Name` AS STRING), 'null') || '~' || IFNULL(CAST(`n_RegionKey` AS STRING), 'null') || '~' || IFNULL(CAST(`Maybe_Null` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `Concat_Hash` IS DISTINCT FROM TO_HEX(SHA512(IFNULL(CAST(`n_RegionKey` AS STRING), 'null') || IFNULL(CAST(`n_NationKey` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `Nation_HK` HAVING COUNT(*) > 1")
SELECT
    CAST('0' AS STRING)                      AS `QA_DIM_HASH_KEY`     @id("h1a000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    CAST({{ get_hash('NATION_HK', algo='SHA256') }} AS STRING) AS `Nation_HK` @id("h1a001") @isBusinessKey @not_null @uniqueness,
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("h1a002") @inHash("NATION_HK", 1) @inHash("CONCAT_HASH", 2),
    `F`.`n_Name`                             AS `n_Name`              @id("h1a003") @inHash("ROW_HASH", 1),
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("h1a004") @inHash("ROW_HASH", 2) @inHash("CONCAT_HASH", 1),
    CAST(CASE WHEN MOD(`F`.`n_NationKey`, 2) = 0 THEN NULL ELSE `F`.`n_Comment` END AS STRING) AS `Maybe_Null` @id("h1a005") @inHash("ROW_HASH", 3),
    CAST({{ get_hash('ROW_HASH', 'MD5', '~') }} AS STRING) AS `Row_Hash`  @id("h1a006") @isChangeTracking,
    CAST({{ get_hash('CONCAT_HASH', 'SHA512', '') }} AS STRING) AS `Concat_Hash` @id("h1a007"),
    1                                        AS `SYSTEM_VERSION`      @id("h1a008") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("h1a009") @isSystemCurrentFlag,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("h1a00a") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("h1a00b") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("h1a00c") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
