@id("d03fff12-ef65-4a9d-a260-b3dbd0672fb0")
@nodeType("705")
@description("Annotation test - lineitem with composite hash key, ship/receipt date ordering and numeric range tests")
@tests("SELECT 1 FROM {{ this }} WHERE L_EXTENDEDPRICE < 0", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE L_COMMITDATE IS NULL", true, "Before")
@postSQL("DELETE FROM {{ this }} WHERE L_QUANTITY <= 0")
SELECT
    `L_ORDERKEY`                 AS `L_ORDERKEY`      @id("d03f01") @notNull @not_null @inHash("HK_LINEITEM", 1),
    `L_PARTKEY`                  AS `L_PARTKEY`       @id("d03f02") @not_null,
    `L_SUPPKEY`                  AS `L_SUPPKEY`       @id("d03f03") @not_null,
    `L_LINENUMBER`               AS `L_LINENUMBER`    @id("d03f04") @notNull @min_max("1", "7") @inHash("HK_LINEITEM", 2),
    `L_QUANTITY`                 AS `L_QUANTITY`      @id("d03f05") @min_max("1", "50"),
    `L_EXTENDEDPRICE`            AS `L_EXTENDEDPRICE` @id("d03f06") @min_value("0"),
    `L_DISCOUNT`                 AS `L_DISCOUNT`      @id("d03f07") @min_max("0", "0.10"),
    `L_TAX`                      AS `L_TAX`           @id("d03f08") @min_max("0", "0.08"),
    `L_RETURNFLAG`               AS `L_RETURNFLAG`    @id("d03f09") @accepted_values("'A'") @accepted_values("'N'") @accepted_values("'R'"),
    `L_LINESTATUS`               AS `L_LINESTATUS`    @id("d03f0a") @accepted_values("'F'") @accepted_values("'O'"),
    `L_SHIPDATE`                 AS `L_SHIPDATE`      @id("d03f0b") @not_null @relative_time("<", "L_RECEIPTDATE"),
    `L_COMMITDATE`               AS `L_COMMITDATE`    @id("d03f0c"),
    `L_RECEIPTDATE`              AS `L_RECEIPTDATE`   @id("d03f0d") @max_value("DATE '1998-12-31'"),
    `L_SHIPINSTRUCT`             AS `L_SHIPINSTRUCT`  @id("d03f0e") @rejected_values("'NONE'"),
    `L_SHIPMODE`                 AS `L_SHIPMODE`      @id("d03f0f") @accepted_values("'AIR'") @accepted_values("'FOB'") @accepted_values("'MAIL'") @accepted_values("'RAIL'") @accepted_values("'REG AIR'") @accepted_values("'SHIP'") @accepted_values("'TRUCK'"),
    `L_COMMENT`                  AS `L_COMMENT`       @id("d03f10"),
    CAST({{ get_hash('HK_LINEITEM', 'SHA256') }} AS STRING) AS `HK_LINEITEM` @id("d03f11") @not_null @uniqueness @description("Composite key hash of order key + line number")
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
