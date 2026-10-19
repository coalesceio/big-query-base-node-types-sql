@id("3a9feb45-2650-40ff-a52e-c86808c9e81b")
@nodeType("SQLDimension")
@description("Dimension test - upsert: no change detection, a matched row is always updated and an unmatched row inserted")
@mergeStrategy("upsert")
SELECT
    CAST("0" AS STRING)                  AS `DIM_MERGE_UPSERT_KEY` @id("fd0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`           @id("fd0002") @isBusinessKey,
    `O_CUSTKEY`                          AS `O_CUSTKEY`            @id("fd0003"),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`        @id("fd0004"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`         @id("fd0005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`          @id("fd0006"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`      @id("fd0007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`   @id("fd0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`   @id("fd0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
