@id("a80b39c6-4ab6-4c0b-a703-5a70ffd67151")
@nodeType("SQLWork")
@materializationType("table")
@description("QA get_hash - every option: SHA1 default, MD5, SHA256, SHA512, lowercase algo, positional/keyword delimiter, empty delimiter, hashOrder != column order, one column in several hashes, NULL -> 'null', no marked columns -> NULL")
@tests("SELECT 1 FROM {{ this }} WHERE `H_SHA1` IS DISTINCT FROM TO_HEX(SHA1(IFNULL(CAST(`n_NationKey` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `H_MD5` IS DISTINCT FROM TO_HEX(MD5(IFNULL(CAST(`n_Name` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `H_SHA256` IS DISTINCT FROM TO_HEX(SHA256(IFNULL(CAST(`n_Name` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `H_SHA512` IS DISTINCT FROM TO_HEX(SHA512(IFNULL(CAST(`n_Name` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `H_LOWER_MD5` IS DISTINCT FROM `H_MD5`")
@tests("SELECT 1 FROM {{ this }} WHERE `H_ORDERED` IS DISTINCT FROM TO_HEX(SHA1(IFNULL(CAST(`n_Name` AS STRING), 'null') || '||' || IFNULL(CAST(`n_RegionKey` AS STRING), 'null') || '||' || IFNULL(CAST(`n_NationKey` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `H_KW_TILDE` IS DISTINCT FROM TO_HEX(SHA256(IFNULL(CAST(`n_NationKey` AS STRING), 'null') || '~' || IFNULL(CAST(`n_Name` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `H_POS_PIPE` IS DISTINCT FROM TO_HEX(MD5(IFNULL(CAST(`n_NationKey` AS STRING), 'null') || '|' || IFNULL(CAST(`Maybe_Null` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `H_NO_DELIM` IS DISTINCT FROM TO_HEX(SHA512(IFNULL(CAST(`n_NationKey` AS STRING), 'null') || IFNULL(CAST(`n_Name` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `Maybe_Null` IS NULL AND `H_NULLS` <> TO_HEX(SHA1('null'))")
@tests("SELECT 1 FROM {{ this }} WHERE `H_NONE` IS NOT NULL")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNTIF(`Maybe_Null` IS NULL) = 0")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`     @inHash("H_SHA1", 1) @inHash("H_ORDERED", 3) @inHash("H_KW_TILDE", 1) @inHash("H_POS_PIPE", 1) @inHash("H_NO_DELIM", 1),
    `F`.`n_Name`                             AS `n_Name`          @inHash("H_MD5", 1) @inHash("H_SHA256", 1) @inHash("H_SHA512", 1) @inHash("H_LOWER_MD5", 1) @inHash("H_ORDERED", 1) @inHash("H_KW_TILDE", 2) @inHash("H_NO_DELIM", 2),
    `F`.`n_RegionKey`                        AS `n_RegionKey`     @inHash("H_ORDERED", 2),
    CAST(CASE WHEN MOD(`F`.`n_NationKey`, 2) = 0 THEN NULL ELSE `F`.`n_Comment` END AS STRING) AS `Maybe_Null` @inHash("H_POS_PIPE", 2) @inHash("H_NULLS", 1),
    CAST({{ get_hash('H_SHA1') }} AS STRING)                                   AS `H_SHA1`      @not_null @uniqueness,
    CAST({{ get_hash('H_MD5', 'MD5') }} AS STRING)                             AS `H_MD5`,
    CAST({{ get_hash('H_SHA256', 'SHA256') }} AS STRING)                       AS `H_SHA256`,
    CAST({{ get_hash('H_SHA512', 'SHA512') }} AS STRING)                       AS `H_SHA512`,
    CAST({{ get_hash('H_LOWER_MD5', 'md5') }} AS STRING)                       AS `H_LOWER_MD5`,
    CAST({{ get_hash('H_ORDERED') }} AS STRING)                                AS `H_ORDERED`   @uniqueness,
    CAST({{ get_hash('H_KW_TILDE', algo='SHA256', delimiter='~') }} AS STRING) AS `H_KW_TILDE`,
    CAST({{ get_hash('H_POS_PIPE', 'MD5', '|') }} AS STRING)                   AS `H_POS_PIPE`,
    CAST({{ get_hash('H_NO_DELIM', 'SHA512', '') }} AS STRING)                 AS `H_NO_DELIM`,
    CAST({{ get_hash('H_NULLS') }} AS STRING)                                  AS `H_NULLS`     @not_null,
    CAST({{ get_hash('H_NONE') }} AS STRING)                                   AS `H_NONE`
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
