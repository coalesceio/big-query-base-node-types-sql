@id("c8498ffe-4dfe-4de7-b1eb-33d1136cf092")
@nodeType("728")
@description("SCD test - upsert on WRK_LINEITEM_ANNOTATIONS with a composite business key; no change detection, system columns written as computed")
@mergeStrategy("upsert")
@tests("SELECT 1 FROM {{ ref('TARGET', 'WRK_LINEITEM_ANNOTATIONS') }} GROUP BY L_ORDERKEY, L_LINENUMBER HAVING COUNT(*) > 1", false, "Before")
@tests("SELECT 1 FROM {{ this }} GROUP BY L_ORDERKEY, L_LINENUMBER HAVING COUNT(*) > 1", false, "After")
SELECT
    `L_ORDERKEY`                              AS `L_ORDERKEY`          @id("c84901") @isBusinessKey @primaryKey @clusterKey(1) @not_null,
    `L_LINENUMBER`                            AS `L_LINENUMBER`        @id("c84902") @isBusinessKey @primaryKey @clusterKey(2) @not_null,
    `L_PARTKEY`                               AS `L_PARTKEY`           @id("c84903"),
    `L_SUPPKEY`                               AS `L_SUPPKEY`           @id("c84904"),
    `L_QUANTITY`                              AS `L_QUANTITY`          @id("c84905") @min_max("1", "50"),
    `L_EXTENDEDPRICE`                         AS `L_EXTENDEDPRICE`     @id("c84906"),
    `L_DISCOUNT`                              AS `L_DISCOUNT`          @id("c84907") @min_max("0", "0.10"),
    CAST(`L_EXTENDEDPRICE` * (1 - `L_DISCOUNT`) AS NUMERIC) AS `L_NET_PRICE` @id("c84908") @min_value("0") @description("Extended price net of discount"),
    `L_RETURNFLAG`                            AS `L_RETURNFLAG`        @id("c84909"),
    `L_LINESTATUS`                            AS `L_LINESTATUS`        @id("c8490a"),
    `L_SHIPDATE`                              AS `L_SHIPDATE`          @id("c8490b") @relative_time("<", "L_RECEIPTDATE"),
    `L_RECEIPTDATE`                           AS `L_RECEIPTDATE`       @id("c8490c"),
    `HK_LINEITEM`                             AS `HK_LINEITEM`         @id("c8490d") @not_null @uniqueness,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE`  @id("c8490e") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE`  @id("c8490f") @isSystemUpdateDate @freshness(1, "DAY")
FROM {{ ref('TARGET', 'WRK_LINEITEM_ANNOTATIONS') }} `WRK_LINEITEM_ANNOTATIONS`
