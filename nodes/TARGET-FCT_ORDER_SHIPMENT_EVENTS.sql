@id("44ecfa7e-83bc-425e-aea2-61d0923b2b9e")
@nodeType("SQLFact")
@materializationType("table")
@description("Fact 7 - factless shipment event fact from FCT_LINEITEM and WRK_ORDERS: allColumnMatch inserts each order-line shipment event once, never updates")
@mergeStrategy("allColumnMatch")
@writeMode("append")
@partitionBy("DATE_TRUNC(SHIP_DATE, MONTH)")
@tag("env", "dev")
@tests("SELECT 1 FROM {{ this }} GROUP BY `O_ORDERKEY`, `L_LINENUMBER`, `C_CUSTKEY`, `SHIP_MODE_ID`, `ORDER_DATE`, `SHIP_DATE`, `RECEIPT_DATE` HAVING COUNT(*) > 1", false, "After")
SELECT DISTINCT
    `l`.`L_ORDERKEY`                          AS `O_ORDERKEY`         @id("44ec01") @notNull @clusterKey(1) @not_null @description("Order key"),
    `l`.`L_LINENUMBER`                        AS `L_LINENUMBER`       @id("44ec02") @notNull @clusterKey(2) @not_null @description("Line number within the order"),
    `o`.`O_CUSTKEY`                           AS `C_CUSTKEY`          @id("44ec03") @notNull @clusterKey(3) @not_null @description("Customer key"),
    CAST(COALESCE(`l`.`SHIP_MODE_ID`, 'UNKNOWN')AS STRING)   AS `SHIP_MODE_ID`       @id("44ec04") @notNull @not_null @description("Ship mode dimension key, UNKNOWN when unresolved"),
    `o`.`O_ORDERDATE`                         AS `ORDER_DATE`         @id("44ec05") @notNull @not_null @relative_time("<=", "SHIP_DATE") @description("Order date"),
    `l`.`L_SHIPDATE`                          AS `SHIP_DATE`          @id("44ec06") @notNull @not_null @relative_time("<=", "RECEIPT_DATE") @description("Ship date - partitioned by month"),
    CAST(COALESCE(`l`.`L_RECEIPTDATE`, DATE '2999-12-31')AS DATE) AS `RECEIPT_DATE` @id("44ec07") @notNull @not_null @description("Receipt date, 2999-12-31 when not yet received"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE` @id("44ec08") @isSystemCreateDate @description("When this event was first loaded - not part of the match")
FROM {{ ref('TARGET', 'FCT_LINEITEM') }} `l`
INNER JOIN {{ ref('TARGET', 'WRK_ORDERS1') }} `o` ON `o`.`O_ORDERKEY` = `l`.`L_ORDERKEY`
