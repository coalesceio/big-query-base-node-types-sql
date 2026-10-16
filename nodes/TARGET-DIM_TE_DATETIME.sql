@id("3b8cf9bd-3908-4f61-ad19-8464ae56915f")
@nodeType("SQLDimension")
@description("Table expiration test - tableExpiration as a full datetime (2027-06-30 18:30:00); upsert")
@mergeStrategy("upsert")
@tableExpiration("2027-06-30 18:30:00")
SELECT
    CAST("0" AS STRING)                  AS `DIM_TE_DATETIME_KEY` @id("a30001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`          @id("a30002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                          AS `O_CUSTKEY`           @id("a30003"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`        @id("a30005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`         @id("a30006"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`     @id("a30007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`  @id("a30008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`  @id("a30009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
