@id("55f5a4d3-7788-4bba-89ce-f57a1c481f6f")
@nodeType("SQLDimension")
@description("Dimension test - writeMode, mergeStrategy, zeroKey, disableTests, tests, preSQL, postSQL and every column test in one node; changeTracking SCD Type 1")
@writeMode("append")
@mergeStrategy("changeTracking")
@zeroKey("'0'", "'UNKNOWN'", "1900-01-01 00:00:00", true)
@disableTests(false)
@tests("SELECT x FROM UNNEST([1, 2, 3]) AS x WHERE x IS NULL", true, "Before")
@tests("SELECT x FROM UNNEST([1, 2, 3]) AS x WHERE x > 3", true, "After")
@preSQL("SELECT 'pre-load' AS STEP")
@postSQL("SELECT 'post-load' AS STEP")
SELECT
    CAST("0" AS STRING)                  AS `DIM_ALL_RUN_ANNOTATIONS_KEY` @id("fe0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`                  @id("fe0002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                          AS `O_CUSTKEY`                   @id("fe0003") @min_value("0"),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`               @id("fe0004") @accepted_values("'F', 'O', 'P'") @accepted_values("'UNKNOWN'"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`                @id("fe0005") @min_max("0", "10000000"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`                 @id("fe0006") @max_value("DATE '2099-12-31'"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`             @id("fe0007") @empty @rejected_values("'0-NONE'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`          @id("fe0008") @isSystemCreateDate @relative_time("<=", "SYSTEM_UPDATE_DATE"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`          @id("fe0009") @isSystemUpdateDate @freshness(1, "DAY")
FROM {{ ref('SRC', 'orders') }} `orders`
