@id("b9bc7b8b-3911-446f-983a-3e75faf4ac2d")
@nodeType("705")
@description("Annotation test - customer in append mode with hash keys, range and deny-list column tests")
@writeMode("append")
@tests("SELECT 1 FROM {{ this }} WHERE C_ACCTBAL IS NULL", true)
@preSQL("DELETE FROM {{ this }} WHERE LOAD_TS < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)")
SELECT
    `C_CUSTKEY`                  AS `C_CUSTKEY`    @id("b9bc71") @notNull @not_null @min_value("1") @inHash("HK_CUSTOMER", 1) @inHash("HD_CUSTOMER", 1),
    `C_NAME`                     AS `C_NAME`       @id("b9bc72") @not_null @empty @inHash("HD_CUSTOMER", 2),
    `C_ADDRESS`                  AS `C_ADDRESS`    @id("b9bc73") @inHash("HD_CUSTOMER", 3),
    `C_NATIONKEY`                AS `C_NATIONKEY`  @id("b9bc74") @min_max("0", "24"),
    `C_PHONE`                    AS `C_PHONE`      @id("b9bc75") @empty @inHash("HD_CUSTOMER", 4),
    `C_ACCTBAL`                  AS `C_ACCTBAL`    @id("b9bc76") @min_value("-999.99") @max_value("9999.99") @description("Account balance"),
    `C_MKTSEGMENT`               AS `C_MKTSEGMENT` @id("b9bc77") @accepted_values("'AUTOMOBILE'") @accepted_values("'BUILDING'") @accepted_values("'FURNITURE'") @accepted_values("'HOUSEHOLD'") @accepted_values("'MACHINERY'") @rejected_values("'UNKNOWN'") @rejected_values("''"),
    `C_COMMENT`                  AS `C_COMMENT`    @id("b9bc78") @defaultValue("'NA'"),
    CAST({{ get_hash('HK_CUSTOMER') }} AS STRING)                                  AS `HK_CUSTOMER` @id("b9bc79") @not_null @description("Customer hash key (SHA1)"),
    CAST({{ get_hash('HD_CUSTOMER', algo='SHA256', delimiter='~') }} AS STRING)  AS `HD_CUSTOMER` @id("b9bc7a") @description("Customer hash diff (SHA256, ~ delimited)"),
    CAST(CURRENT_TIMESTAMP() AS TIMESTAMP)                                         AS `LOAD_TS`     @id("b9bc7b") @freshness(1, "DAY")
FROM {{ ref('SRC', 'customer') }} `customer`
