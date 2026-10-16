@id("13017a2e-f911-4b63-a8f7-98a5648c875f")
@nodeType("SQLFact")
@materializationType("table")
@description("Fact 2 - lineitem from WRK_LINEITEM, DIM_SHIP_MODE and FCT_ORDERS: upsert on a composite business key, truncateInsert, monthly partition, rounding mode")
@mergeStrategy("upsert")
@writeMode("truncateInsert")
@partitionBy("DATE_TRUNC(L_SHIPDATE, MONTH)")
@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ this }} GROUP BY `L_ORDERKEY`, `L_LINENUMBER` HAVING COUNT(*) > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `L_NET_PRICE` > `L_GROSS_PRICE`")
SELECT
    `l`.`L_ORDERKEY`                     AS `L_ORDERKEY`         @id("130101") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @not_null @description("Order key - business key part 1"),
    `l`.`L_LINENUMBER`                   AS `L_LINENUMBER`       @id("130102") @isBusinessKey @notNull @primaryKey(2) @clusterKey(2) @not_null @description("Line number - business key part 2"),
    `l`.`HK_LINEITEM`                    AS `HK_LINEITEM`        @id("130103") @not_null @uniqueness @description("Lineitem hash key from Work"),
    CAST(COALESCE(`o`.`DIM_CUSTOMER_KEY`, '0') AS STRING) AS `DIM_CUSTOMER_KEY`  @id("130104") @description("Customer surrogate key via FCT_ORDERS"),
    `sm`.`SHIP_MODE_ID`                  AS `SHIP_MODE_ID`       @id("130105") @not_null @description("Ship mode dimension key"),
    `l`.`L_PARTKEY`                      AS `L_PARTKEY`          @id("130106") @description("Part key"),
    `l`.`L_SUPPKEY`                      AS `L_SUPPKEY`          @id("130107") @description("Supplier key"),
    `l`.`L_QUANTITY`                     AS `L_QUANTITY`         @id("130108") @min_value("0") @description("Quantity"),
    `l`.`L_EXTENDEDPRICE`                AS `L_EXTENDEDPRICE`    @id("130109") @min_value("0") @description("Extended price"),
    `l`.`L_NET_PRICE`                    AS `L_NET_PRICE`        @id("13010a") @min_value("0") @description("Extended price net of discount"),
    `l`.`L_GROSS_PRICE`                  AS `L_GROSS_PRICE`      @id("13010b") @min_value("0") @description("Net price plus tax"),
    CAST(`l`.`L_GROSS_PRICE` / NULLIF(`l`.`L_QUANTITY`, 0) AS NUMERIC) AS `L_UNIT_GROSS_PRICE` @id("13010c") @description("Gross price per unit, rounded with the table default_rounding_mode"),
    `l`.`L_RETURNFLAG`                   AS `L_RETURNFLAG`       @id("13010d") @description("Return flag"),
    `l`.`L_LINESTATUS`                   AS `L_LINESTATUS`       @id("13010e") @description("Line status"),
    `l`.`L_SHIPDATE`                     AS `L_SHIPDATE`         @id("13010f") @notNull @not_null @relative_time("<=", "L_RECEIPTDATE") @description("Ship date - partitioned by month"),
    `l`.`L_RECEIPTDATE`                  AS `L_RECEIPTDATE`      @id("130110") @description("Receipt date"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("130111") @isSystemCreateDate @description("Row create time"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("130112") @isSystemUpdateDate @description("Row update time")
FROM {{ ref('TARGET', 'WRK_LINEITEM') }} `l`
LEFT JOIN {{ ref('TARGET', 'FCT_ORDERS') }} `o` ON `o`.`O_ORDERKEY` = `l`.`L_ORDERKEY`
LEFT JOIN {{ ref('TARGET', 'DIM_SHIP_MODE') }} `sm`
    ON `sm`.`SHIP_MODE` = `l`.`L_SHIPMODE`
   AND `sm`.`SHIP_INSTRUCT` = `l`.`L_SHIPINSTRUCT`
