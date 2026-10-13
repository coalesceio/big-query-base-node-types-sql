@id("65bc3924-ab7e-4271-adb2-f654460b8267")
@nodeType("705")
@description("Annotation test - orders view; writeMode, preSQL and postSQL are ignored on views and tests are disabled")
@materializationType("view")
@writeMode("append")
@disableTests
@tests("SELECT 1 FROM {{ this }} GROUP BY O_ORDERKEY HAVING COUNT(*) > 1")
@preSQL("SELECT 1")
@postSQL("SELECT 1")
SELECT
    `O_ORDERKEY`                 AS `O_ORDERKEY`    @id("65bc01") @not_null @uniqueness @description("Order key"),
    `O_CUSTKEY`                  AS `O_CUSTKEY`     @id("65bc02") @notNull,
    UPPER(`O_ORDERSTATUS`)       AS `O_ORDERSTATUS` @id("65bc03") @accepted_values("'F'") @accepted_values("'O'") @accepted_values("'P'"),
    `O_TOTALPRICE`               AS `O_TOTALPRICE`  @id("65bc04") @min_value("0") @defaultValue("0"),
    `O_ORDERDATE`                AS `O_ORDERDATE`   @id("65bc05")
FROM {{ ref('SRC', 'orders') }} `orders`
WHERE `O_ORDERSTATUS` IS NOT NULL
