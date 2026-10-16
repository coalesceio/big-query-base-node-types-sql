@id("be845087-cd75-4543-ab2f-3e4c0fbb4fc8")
@nodeType("SQLWork")
@materializationType("table")
@description("Work - orders staged from SRC with table options: daily partition with 50-year partition expiration, clustered on order and customer key, composite primary key, fixed table expiration, rounding mode, tags")
@writeMode("truncateInsert")
@partitionExpirationDays("18250")
@tableExpiration("2030-06-30 18:00:00")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ this }} GROUP BY `O_ORDERKEY`, `O_CUSTKEY` HAVING COUNT(*) > 1", true)
SELECT
    `O_ORDERKEY`                                  AS `O_ORDERKEY`       @id("be8401") @notNull @primaryKey(1) @clusterKey(1) @not_null @description("Order key - primary key part 1///"),
    `O_CUSTKEY`                                   AS `O_CUSTKEY`        @id("be8402") @notNull @primaryKey(2) @clusterKey(2) @not_null @description("Customer key - primary key part 2///"),
    `O_ORDERSTATUS`                               AS `O_ORDERSTATUS`    @id("be8403") @accepted_values("'F', 'O', 'P'") @description("Order status"),
    CAST(`O_TOTALPRICE` AS NUMERIC)               AS `O_TOTALPRICE`     @id("be8404") @min_value("0") @description("Order total price"),
    CAST(`O_TOTALPRICE` / 3 AS NUMERIC)           AS `O_PRICE_THIRD`    @id("be8405") @description("A third of the total price, rounded with the table default_rounding_mode"),
    `O_ORDERDATE`                                 AS `O_ORDERDATE`      @id("be8406") @partitionBy @notNull @not_null @description("Order date - partition column"),
    `O_ORDERPRIORITY`                             AS `O_ORDER_PRIORITY` @id("be8407") @description("Order priority"),
    `O_COMMENT`                                   AS `O_COMMENT`        @id("be8408") @defaultValue("'NA'") @description("Free-text comment")
FROM {{ ref('SRC', 'orders') }} `orders`
