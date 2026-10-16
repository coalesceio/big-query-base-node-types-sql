@id("9d68d682-5d05-413b-8086-9b4898c45e05")
@nodeType("SQLFact")
@materializationType("view")
@description("Fact 6 - order revenue view joining FCT_ORDERS, FCT_LINEITEM and DIM_CUSTOMER, with a table expiration and tags")
@tableExpiration("2027-03-31 23:59:59")
@tag("env", "dev")
@tests("SELECT 1 FROM {{ this }} GROUP BY `O_ORDERKEY` HAVING COUNT(*) > 1", false)
WITH ORDER_LINES AS (
    SELECT
        `l`.`L_ORDERKEY`,
        COUNT(*)                  AS `LINE_COUNT`,
        SUM(`l`.`L_NET_PRICE`)    AS `NET_REVENUE`,
        SUM(`l`.`L_GROSS_PRICE`)  AS `GROSS_REVENUE`
    FROM {{ ref('TARGET', 'FCT_LINEITEM') }} `l`
    GROUP BY `l`.`L_ORDERKEY`
)
SELECT
    `o`.`O_ORDERKEY`       AS `O_ORDERKEY`       @id("9d6801") @isBusinessKey @not_null @uniqueness @description("Order key"),
    `o`.`O_ORDERDATE`      AS `O_ORDERDATE`      @id("9d6802") @description("Order date"),
    `o`.`O_ORDERSTATUS`    AS `O_ORDERSTATUS`    @id("9d6803") @description("Order status"),
    `dc`.`C_CUSTKEY`       AS `C_CUSTKEY`        @id("9d6804") @description("Customer key"),
    `dc`.`C_NAME`          AS `C_NAME`           @id("9d6805") @description("Customer name"),
    `dc`.`R_NAME`          AS `R_NAME`           @id("9d6806") @description("Customer region"),
    `ol`.`LINE_COUNT`      AS `LINE_COUNT`       @id("9d6807") @min_value("1") @description("Lineitems on the order"),
    CAST(`ol`.`NET_REVENUE` AS NUMERIC)   AS `NET_REVENUE`   @id("9d6808") @min_value("0") @description("Net revenue"),
    CAST(`ol`.`GROSS_REVENUE` AS NUMERIC) AS `GROSS_REVENUE` @id("9d6809") @min_value("0") @description("Gross revenue"),
    `o`.`O_TOTALPRICE`     AS `O_TOTALPRICE`     @id("9d680a") @description("Order total price as recorded")
FROM {{ ref('TARGET', 'FCT_ORDERS') }} `o`
INNER JOIN ORDER_LINES `ol` ON `ol`.`L_ORDERKEY` = `o`.`O_ORDERKEY`
LEFT JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `dc` ON `dc`.`DIM_CUSTOMER_KEY` = `o`.`DIM_CUSTOMER_KEY`
