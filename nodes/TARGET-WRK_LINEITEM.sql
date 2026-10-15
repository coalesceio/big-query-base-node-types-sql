@id("a8d62385-d0ae-46ed-ba08-0bc4e25580a3")
@nodeType("SQLWork")
@materializationType("table")
@description("Work 5 - lineitem staged from SRC: node-level monthly partition, composite primary key, hash key, rounding mode, postSQL")
@writeMode("truncateInsert")
@partitionBy("DATE_TRUNC(L_SHIPDATE, MONTH)")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
@tests("SELECT 1 FROM {{ this }} GROUP BY `L_ORDERKEY`, `L_LINENUMBER` HAVING COUNT(*) > 1", false, "After")
@postSQL("UPDATE {{ this }} SET `L_COMMENT` = TRIM(`L_COMMENT`) WHERE `L_COMMENT` IS NOT NULL")
SELECT
    `L_ORDERKEY`                       AS `L_ORDERKEY`      @id("a8d601") @notNull @primaryKey(1) @clusterKey(1) @not_null @inHash("HK_LINEITEM", 1) @description("Order key"),
    `L_LINENUMBER`                     AS `L_LINENUMBER`    @id("a8d602") @notNull @primaryKey(2) @clusterKey(2) @not_null @min_max("1", "7") @inHash("HK_LINEITEM", 2) @description("Line number within the order"),
    `L_PARTKEY`                        AS `L_PARTKEY`       @id("a8d603") @not_null @description("Part key"),
    `L_SUPPKEY`                        AS `L_SUPPKEY`       @id("a8d604") @not_null @description("Supplier key"),
    CAST(`L_QUANTITY` AS NUMERIC)      AS `L_QUANTITY`      @id("a8d605") @min_max("1", "50") @description("Quantity"),
    CAST(`L_EXTENDEDPRICE` AS NUMERIC) AS `L_EXTENDEDPRICE` @id("a8d606") @min_value("0") @description("Extended price"),
    CAST(`L_DISCOUNT` AS NUMERIC)      AS `L_DISCOUNT`      @id("a8d607") @min_max("0", "0.1") @description("Discount"),
    CAST(`L_TAX` AS NUMERIC)           AS `L_TAX`           @id("a8d608") @min_max("0", "0.08") @description("Tax"),
    CAST(`L_EXTENDEDPRICE` * (1 - `L_DISCOUNT`) AS NUMERIC)                AS `L_NET_PRICE`   @id("a8d609") @min_value("0") @description("Extended price net of discount"),
    CAST(`L_EXTENDEDPRICE` * (1 - `L_DISCOUNT`) * (1 + `L_TAX`) AS NUMERIC) AS `L_GROSS_PRICE` @id("a8d60a") @min_value("0") @description("Net price plus tax"),
    `L_RETURNFLAG`                     AS `L_RETURNFLAG`    @id("a8d60b") @accepted_values("'A', 'N', 'R'") @description("Return flag"),
    `L_LINESTATUS`                     AS `L_LINESTATUS`    @id("a8d60c") @accepted_values("'F', 'O'") @description("Line status"),
    `L_SHIPDATE`                       AS `L_SHIPDATE`      @id("a8d60d") @notNull @not_null @relative_time("<=", "L_RECEIPTDATE") @description("Ship date - partitioned by month"),
    `L_COMMITDATE`                     AS `L_COMMITDATE`    @id("a8d60e") @description("Commit date"),
    `L_RECEIPTDATE`                    AS `L_RECEIPTDATE`   @id("a8d60f") @description("Receipt date"),
    `L_SHIPINSTRUCT`                   AS `L_SHIPINSTRUCT`  @id("a8d610") @empty @description("Ship instruction"),
    `L_SHIPMODE`                       AS `L_SHIPMODE`      @id("a8d611") @accepted_values("'AIR', 'FOB', 'MAIL', 'RAIL', 'REG AIR', 'SHIP', 'TRUCK'") @description("Ship mode"),
    `L_COMMENT`                        AS `L_COMMENT`       @id("a8d612") @defaultValue("'NA'") @description("Free-text comment"),
    {{ get_hash('HK_LINEITEM', 'MD5') }} AS `HK_LINEITEM`   @id("a8d613") @not_null @uniqueness @description("Lineitem hash key (MD5 of order key and line number)")
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
