@id("7ae88ea6-a2f0-4f1c-bcf8-5ab387a3c6c8")
@nodeType("SQLDimension")
@description("Dimension test - column @primaryKey(1) on the business key O_ORDERKEY (NOT ENFORCED); changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
SELECT
    CAST("0" AS STRING)                  AS `DIM_PRIMARY_KEY_KEY` @id("f60001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`          @id("f60002") @isBusinessKey @primaryKey(1),
    `O_CUSTKEY`                          AS `O_CUSTKEY`           @id("f60003"),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`       @id("f60004"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`        @id("f60005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`         @id("f60006"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`     @id("f60007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`  @id("f60008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`  @id("f60009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
