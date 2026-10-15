@id("dd4ac829-30b3-41b3-b334-08df08e39ea3")
@nodeType("SQLFact")
@materializationType("table")
@description("Fact 1 - orders from WRK_ORDERS and DIM_CUSTOMER: changeTracking SCD1 on the order key, column partition, clustering, tags")
@mergeStrategy("changeTracking")
@writeMode("append")
@tag("env", "dev")
@tag("cost_center", "finance")
@tests("SELECT 1 FROM {{ ref('TARGET', 'WRK_ORDERS') }} GROUP BY `O_ORDERKEY` HAVING COUNT(*) > 1 OR `O_ORDERKEY` IS NULL", false, "Before")
@tests("SELECT 1 FROM {{ this }} WHERE `DIM_CUSTOMER_KEY` = '0'", true, "After")
SELECT
    `o`.`O_ORDERKEY`                          AS `O_ORDERKEY`         @id("dd4a01") @isBusinessKey @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @description("Order key - business key"),
    CAST(COALESCE(`dc`.`DIM_CUSTOMER_KEY`, '0') AS STRING)   AS `DIM_CUSTOMER_KEY`   @id("dd4a02") @notNull @clusterKey(2) @not_null @description("Customer surrogate key, '0' (zero key) when unresolved"),
    `o`.`O_CUSTKEY`                           AS `O_CUSTKEY`          @id("dd4a03") @not_null @description("Customer key"),
    `o`.`O_ORDERSTATUS`                       AS `O_ORDERSTATUS`      @id("dd4a04") @accepted_values("'F', 'O', 'P'") @description("Order status"),
    `o`.`O_ORDERPRIORITY`                     AS `O_ORDERPRIORITY`    @id("dd4a05") @description("Order priority"),
    `o`.`O_TOTALPRICE`                        AS `O_TOTALPRICE`       @id("dd4a06") @min_value("0") @description("Order total price"),
    `o`.`O_ORDERDATE`                         AS `O_ORDERDATE`        @id("dd4a07") @partitionBy @notNull @not_null @description("Order date - partition column"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE` @id("dd4a08") @isSystemCreateDate @description("Row create time"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE` @id("dd4a09") @isSystemUpdateDate @relative_time(">=", "SYSTEM_CREATE_DATE") @description("Row update time")
FROM {{ ref('TARGET', 'WRK_ORDERS') }} `o`
LEFT JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `dc`
    ON `dc`.`C_CUSTKEY` = `o`.`O_CUSTKEY`
   AND `dc`.`SYSTEM_CURRENT_FLAG` = 'Y'
