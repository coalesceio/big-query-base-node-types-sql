@id("11c25f55-08ac-4d5a-b740-5c897bc3e367")
@nodeType("SQLDimension")
@tag("cost_center", "finance")
@defaultRoundingMode("ROUND_HALF_EVEN")
SELECT
    CAST("0" AS STRING)                      AS `DIM_nation_KEY`      @id("0b1c20") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("376059") @isBusinessKey,
    `N_NAME`                                 AS `N_NAME`              @id("acef36"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("e234bd"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("c7bc9a"),
    `last_modified`                          AS `last_modified`       @id("0d5952") @partitionBy,
    1                                        AS `SYSTEM_VERSION`      @id("758c88") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("285211") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("354524") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("dba442") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("6abfc3") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`