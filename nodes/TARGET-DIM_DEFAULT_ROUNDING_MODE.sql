@id("d7600b78-41c1-475d-a47d-5b9bf0590378")
@nodeType("SQLDimension")
@description("Dimension test - @defaultRoundingMode ROUND_HALF_EVEN on a table with a NUMERIC column; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@defaultRoundingMode("ROUND_HALF_EVEN")
SELECT
    CAST("0" AS STRING)                  AS `DIM_DEFAULT_ROUNDING_MODE_KEY` @id("f40001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`                    @id("f40002") @isBusinessKey,
    `O_CUSTKEY`                          AS `O_CUSTKEY`                     @id("f40003"),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`                 @id("f40004"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`                  @id("f40005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`                   @id("f40006"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`               @id("f40007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`            @id("f40008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`            @id("f40009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
