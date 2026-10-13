@id("5db8a7ff-fadc-454c-9971-1e466b8cf771")
@nodeType("729")
@description("Fact annotation test - upsert merge on lineitem with a composite business key; monthly date partition, rounding mode")
@mergeStrategy("upsert")
SELECT
    `L_ORDERKEY`                                            AS `L_ORDERKEY`         @id("5db801") @isBusinessKey  ,
    `L_LINENUMBER`                                          AS `L_LINENUMBER`       @id("5db802") @isBusinessKey ,
    `L_PARTKEY`                                             AS `L_PARTKEY`          @id("5db803"),
    `L_SUPPKEY`                                             AS `L_SUPPKEY`          @id("5db804"),
    CAST(`L_QUANTITY` AS FLOAT64)                           AS `L_QUANTITY`         @id("5db805") ,
    CAST(`L_EXTENDEDPRICE` AS FLOAT64)                      AS `L_EXTENDEDPRICE`    @id("5db806") ,
    CAST(`L_DISCOUNT`AS FLOAT64)                            AS `L_DISCOUNT`         @id("5db807") ,
    CAST(`L_TAX` AS FLOAT64)                                AS `L_TAX`              @id("5db808") ,
    CAST(`L_EXTENDEDPRICE` * (1 - `L_DISCOUNT`) AS NUMERIC) AS `L_NET_PRICE`        @id("5db809") ,
    `L_RETURNFLAG`                                          AS `L_RETURNFLAG`       @id("5db80a") ,
    `L_LINESTATUS`                                          AS `L_LINESTATUS`       @id("5db80b") ,
    `L_SHIPDATE`                                            AS `L_SHIPDATE`         @id("5db80c") ,
    `L_COMMITDATE`                                          AS `L_COMMITDATE`       @id("5db80d"),
    `L_RECEIPTDATE`                                         AS `L_RECEIPTDATE`      @id("5db80e"),
    `L_SHIPMODE`                                            AS `L_SHIPMODE`         @id("5db80f") ,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                    AS `SYSTEM_CREATE_DATE` @id("5db810") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                    AS `SYSTEM_UPDATE_DATE` @id("5db811") @isSystemUpdateDate @freshness(1, "DAY")
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
