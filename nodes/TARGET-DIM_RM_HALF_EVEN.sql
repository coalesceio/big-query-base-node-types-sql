@id("51b0d09c-c535-46cd-aa3a-a01c5e002e67")
@nodeType("SQLDimension")
@description("Rounding mode test - defaultRoundingMode ROUND_HALF_EVEN on NUMERIC columns; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@defaultRoundingMode("ROUND_HALF_EVEN")
SELECT
    CAST("0" AS STRING)                  AS `DIM_RM_HALF_EVEN_KEY` @id("a90001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`           @id("a90002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                          AS `O_CUSTKEY`            @id("a90003"),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`        @id("a90004"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`         @id("a90005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`          @id("a90006"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`      @id("a90007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`   @id("a90008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`   @id("a90009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
