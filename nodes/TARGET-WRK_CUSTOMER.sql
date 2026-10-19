@id("40b1acbd-668a-44db-b584-7f458d067693")
@nodeType("SQLWork")
@description("Pipeline - staging: customers with their nation and region (CTE + join), clustered by segment and region")
@writeMode("truncateInsert")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tableExpiration("2027-12-31 23:59:59")
WITH `customer_clean` AS (
    SELECT
        `C_CUSTKEY`                              AS `CUSTOMER_KEY`,
        TRIM(`C_NAME`)                           AS `CUSTOMER_NAME`,
        UPPER(TRIM(`C_MKTSEGMENT`))              AS `MARKET_SEGMENT`,
        -- DE_SRC.customer stores this as FLOAT64
        CAST(`C_ACCTBAL` AS NUMERIC)             AS `ACCOUNT_BALANCE`,
        `C_PHONE`                                AS `PHONE`,
        `C_NATIONKEY`                            AS `NATION_KEY`
    FROM {{ ref('SRC', 'customer') }}
)
SELECT
    CAST(`c`.`CUSTOMER_KEY` AS INT64)       AS `CUSTOMER_KEY`    @primaryKey(1) @not_null @uniqueness @inHash("CUSTOMER_HK", 1),
    CAST(`c`.`CUSTOMER_NAME` AS STRING)     AS `CUSTOMER_NAME`   @not_null @empty @inHash("CUSTOMER_HK", 2),
    CAST(`c`.`MARKET_SEGMENT` AS STRING)    AS `MARKET_SEGMENT`  @clusterKey(1) @accepted_values("'AUTOMOBILE', 'BUILDING', 'FURNITURE', 'HOUSEHOLD', 'MACHINERY'"),
    CAST(`c`.`ACCOUNT_BALANCE` AS NUMERIC)  AS `ACCOUNT_BALANCE` @min_max("-1000", "10000"),
    CAST(`c`.`PHONE` AS STRING)             AS `PHONE`           @rejected_values("''"),
    `g`.`NATION_NAME`                       AS `NATION_NAME`,
    `g`.`REGION_NAME`                       AS `REGION_NAME`     @clusterKey(2),
    CAST(TO_HEX(SHA256(CONCAT(CAST(`c`.`CUSTOMER_KEY` AS STRING), '||', `c`.`CUSTOMER_NAME`))) AS STRING) AS `CUSTOMER_HASH` @not_null
FROM `customer_clean` `c`
INNER JOIN {{ ref('TARGET', 'WRK_GEOGRAPHY') }} `g`
    ON `c`.`NATION_KEY` = `g`.`NATION_KEY`
