@id("5db8a7ff-fadc-454c-9971-1e466b8cf771")
@nodeType("729")
@description("Fact annotation test - upsert merge on lineitem with a composite business key; monthly date partition, rounding mode")
@mergeStrategy("upsert")
@tests("SELECT 1 FROM {{ ref('SRC', 'lineitem') }} GROUP BY L_ORDERKEY, L_LINENUMBER HAVING COUNT(*) > 1", false, "Before")
@tests("SELECT 1 FROM {{ this }} GROUP BY L_ORDERKEY, L_LINENUMBER HAVING COUNT(*) > 1", false, "After")
SELECT
    `L_ORDERKEY`                                            AS `L_ORDERKEY`         @id("5db801") @isBusinessKey @primaryKey(1) @clusterKey(1) @not_null,
    `L_LINENUMBER`                                          AS `L_LINENUMBER`       @id("5db802") @isBusinessKey @primaryKey(2) @clusterKey(2) @not_null @min_max("1", "7"),
    `L_PARTKEY`                                             AS `L_PARTKEY`          @id("5db803"),
    `L_SUPPKEY`                                             AS `L_SUPPKEY`          @id("5db804"),
    `L_QUANTITY`                                            AS `L_QUANTITY`         @id("5db805") @min_max("1", "50"),
    `L_EXTENDEDPRICE`                                       AS `L_EXTENDEDPRICE`    @id("5db806") @min_value("0"),
    `L_DISCOUNT`                                            AS `L_DISCOUNT`         @id("5db807") @min_max("0", "0.10"),
    `L_TAX`                                                 AS `L_TAX`              @id("5db808") @max_value("0.08"),
    CAST(`L_EXTENDEDPRICE` * (1 - `L_DISCOUNT`) AS NUMERIC) AS `L_NET_PRICE`        @id("5db809") @min_value("0") @description("Extended price net of discount"),
    `L_RETURNFLAG`                                          AS `L_RETURNFLAG`       @id("5db80a") @accepted_values("'A'") @accepted_values("'N'") @accepted_values("'R'"),
    `L_LINESTATUS`                                          AS `L_LINESTATUS`       @id("5db80b") @accepted_values("'F'") @accepted_values("'O'"),
    `L_SHIPDATE`                                            AS `L_SHIPDATE`         @id("5db80c") @not_null @relative_time("<", "L_RECEIPTDATE"),
    `L_COMMITDATE`                                          AS `L_COMMITDATE`       @id("5db80d"),
    `L_RECEIPTDATE`                                         AS `L_RECEIPTDATE`      @id("5db80e"),
    `L_SHIPMODE`                                            AS `L_SHIPMODE`         @id("5db80f") @rejected_values("''"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                    AS `SYSTEM_CREATE_DATE` @id("5db810") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                    AS `SYSTEM_UPDATE_DATE` @id("5db811") @isSystemUpdateDate @freshness(1, "DAY")
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
