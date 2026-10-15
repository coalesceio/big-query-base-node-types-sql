@id("5471d497-e299-420d-a39f-4c37df3a00d9")
@nodeType("SQLFact")
@materializationType("table")
@description("QA get_hash in a Fact - upsert on a SHA1 hash key of two columns, lowercase sha256 measure hash, no-column hash -> NULL")
@mergeStrategy("upsert")
@tests("SELECT 1 FROM {{ this }} WHERE `Fact_HK` IS DISTINCT FROM TO_HEX(SHA1(IFNULL(CAST(`n_NationKey` AS STRING), 'null') || '||' || IFNULL(CAST(`n_RegionKey` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `Amount_Hash` IS DISTINCT FROM TO_HEX(SHA256(IFNULL(CAST(`Amount` AS STRING), 'null')))")
@tests("SELECT 1 FROM {{ this }} WHERE `No_Hash` IS NOT NULL")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    CAST({{ get_hash('FACT_HK') }} AS STRING) AS `Fact_HK`            @id("h2a001") @isBusinessKey @uniqueness,
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("h2a002") @inHash("FACT_HK", 1),
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("h2a003") @inHash("FACT_HK", 2),
    CAST(`F`.`n_NationKey` * 1.5 AS NUMERIC) AS `Amount`              @id("h2a004") @inHash("AMOUNT_HASH", 1),
    CAST({{ get_hash('AMOUNT_HASH', 'sha256') }} AS STRING) AS `Amount_Hash` @id("h2a005"),
    CAST({{ get_hash('NOT_MARKED') }} AS STRING) AS `No_Hash`         @id("h2a006")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
