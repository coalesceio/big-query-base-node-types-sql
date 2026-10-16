@id("6740bc9a-75f5-497f-ab8c-98af01174a21")
@nodeType("SQLWork")
@materializationType("table")
@description("Work 3 - customer staged from SRC: append mode with preSQL cleanup, hash key and hash diff, column tests")
@writeMode("append")
@tag("env", "dev")
@tag("cost_center", "finance")
@preSQL("DELETE FROM {{ this }} WHERE `LOAD_TS` < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)")
@tests("SELECT 1 FROM {{ this }} WHERE `C_ACCTBAL` IS NULL", true)
SELECT
    `C_CUSTKEY`                            AS `C_CUSTKEY`    @id("6740b1") @notNull @primaryKey(1) @clusterKey(1) @not_null @min_value("1") @inHash("HK_CUSTOMER", 1) @description("Customer key"),
    `C_NAME`                               AS `C_NAME`       @id("6740b2") @not_null @empty @inHash("HD_CUSTOMER", 1) @description("Customer name"),
    `C_ADDRESS`                            AS `C_ADDRESS`    @id("6740b3") @inHash("HD_CUSTOMER", 2) @description("Customer address"),
    `C_NATIONKEY`                          AS `C_NATIONKEY`  @id("6740b4") @clusterKey(2) @min_max("0", "24") @inHash("HD_CUSTOMER", 3) @description("Nation key"),
    `C_PHONE`                              AS `C_PHONE`      @id("6740b5") @empty @inHash("HD_CUSTOMER", 4) @description("Phone number"),
    CAST(`C_ACCTBAL` AS NUMERIC)           AS `C_ACCTBAL`    @id("6740b6") @min_value("-999.99") @max_value("9999.99") @inHash("HD_CUSTOMER", 5) @description("Account balance"),
    `C_MKTSEGMENT`                         AS `C_MKTSEGMENT` @id("6740b7") @accepted_values("'AUTOMOBILE', 'BUILDING', 'FURNITURE', 'HOUSEHOLD', 'MACHINERY'") @rejected_values("'UNKNOWN'") @inHash("HD_CUSTOMER", 6) @description("Market segment"),
    `C_COMMENT`                            AS `C_COMMENT`    @id("6740b8") @defaultValue("'NA'") @description("Free-text comment"),
    CAST({{ get_hash('HK_CUSTOMER') }}  AS STRING)                              AS `HK_CUSTOMER` @id("6740b9") @not_null @description("Customer hash key (SHA1)"),
    CAST({{ get_hash('HD_CUSTOMER', algo='SHA256', delimiter='~') }} AS STRING)   AS `HD_CUSTOMER` @id("6740ba") @not_null @description("Customer hash diff (SHA256, ~ delimited)"),
    CAST(CURRENT_TIMESTAMP() AS TIMESTAMP) AS `LOAD_TS`      @id("6740bb") @notNull @freshness(1, "DAY") @description("Load timestamp")
FROM {{ ref('SRC', 'customer') }} `customer`
