@id("9fdde60d-d133-4f53-9ebb-0fe092b478c3")
@nodeType("SQLFact")
@materializationType("table")
@description("Fact 5 - daily shipment snapshot from FCT_LINEITEM and DIM_SHIP_MODE: plain insert (no merge strategy, no business key), append with preSQL to keep reruns idempotent")
@writeMode("append")
@partitionBy("SNAPSHOT_DATE")
@preSQL("DELETE FROM {{ this }} WHERE `SNAPSHOT_DATE` = CURRENT_DATE()")
@tests("SELECT 1 FROM {{ this }} WHERE `SNAPSHOT_DATE` = CURRENT_DATE() GROUP BY `L_SHIPDATE`, `SHIP_MODE_GROUP` HAVING COUNT(*) > 1", false)
SELECT
    CURRENT_DATE()                         AS `SNAPSHOT_DATE`      @id("9fdd01") @notNull @not_null @freshness(1, "DAY") @description("Snapshot date - partition column"),
    `f`.`L_SHIPDATE`                       AS `L_SHIPDATE`         @id("9fdd02") @clusterKey(1) @not_null @description("Ship date"),
    CAST(COALESCE(`sm`.`SHIP_MODE_GROUP`, 'OTHER') AS STRING) AS `SHIP_MODE_GROUP` @id("9fdd03") @clusterKey(2) @accepted_values("'AIR', 'GROUND', 'OTHER'") @description("Ship mode grouping"),
    COUNT(*)                               AS `LINE_COUNT`         @id("9fdd04") @min_value("1") @description("Lineitems shipped"),
    CAST(SUM(`f`.`L_QUANTITY`) AS NUMERIC) AS `TOTAL_QUANTITY`     @id("9fdd05") @min_value("0") @description("Quantity shipped"),
    CAST(SUM(`f`.`L_GROSS_PRICE`) AS NUMERIC) AS `TOTAL_GROSS_PRICE` @id("9fdd06") @min_value("0") @description("Gross price shipped"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)   AS `SYSTEM_CREATE_DATE` @id("9fdd07") @isSystemCreateDate @description("Row load time")
FROM {{ ref('TARGET', 'FCT_LINEITEM') }} `f`
LEFT JOIN {{ ref('TARGET', 'DIM_SHIP_MODE') }} `sm` ON `sm`.`SHIP_MODE_ID` = `f`.`SHIP_MODE_ID`
GROUP BY `f`.`L_SHIPDATE`, COALESCE(`sm`.`SHIP_MODE_GROUP`, 'OTHER')
