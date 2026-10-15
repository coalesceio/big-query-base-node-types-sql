@id("9f42ac8e-9121-428f-a586-815099583708")
@nodeType("SQLWork")
@materializationType("table")
@description("Work 4 - orders staged from SRC: column-level DATE partition, clustering, table tags")
@writeMode("truncateInsert")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ this }} GROUP BY `O_ORDERKEY` HAVING COUNT(*) > 1", false)
SELECT
    `O_ORDERKEY`                       AS `O_ORDERKEY`      @id("9f4201") @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @description("Order key"),
    `O_CUSTKEY`                        AS `O_CUSTKEY`       @id("9f4202") @notNull @clusterKey(2) @not_null @min_value("1") @description("Customer key"),
    `O_ORDERSTATUS`                    AS `O_ORDERSTATUS`   @id("9f4203") @accepted_values("'F', 'O', 'P'") @description("Order status"),
    CAST(`O_TOTALPRICE` AS NUMERIC)    AS `O_TOTALPRICE`    @id("9f4204") @min_value("0") @description("Order total price"),
    `O_ORDERDATE`                      AS `O_ORDERDATE`     @id("9f4205") @partitionBy @notNull @not_null @min_max("DATE '1990-01-01'", "CURRENT_DATE()") @description("Order date - partition column"),
    `O_ORDERPRIORITY`                  AS `O_ORDERPRIORITY` @id("9f4206") @accepted_values("'1-URGENT', '2-HIGH', '3-MEDIUM', '4-NOT SPECIFIED', '5-LOW'") @description("Order priority"),
    `O_CLERK`                          AS `O_CLERK`         @id("9f4207") @empty @description("Clerk"),
    `O_SHIPPRIORITY`                   AS `O_SHIPPRIORITY`  @id("9f4208") @defaultValue("0") @description("Ship priority"),
    `O_COMMENT`                        AS `O_COMMENT`       @id("9f4209") @defaultValue("'NA'") @description("Free-text comment")
FROM {{ ref('SRC', 'orders') }} `orders`
