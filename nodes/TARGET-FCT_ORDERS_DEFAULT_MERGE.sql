@id("2c334972-3249-4356-9230-b23fee17d37e")
@nodeType("729")
@description("Fact annotation test - business key with no @mergeStrategy on orders (defaults to changeTracking); numeric table expiration, clustering, value-list tests")
@tableExpiration("90")
@tests("SELECT 1 FROM {{ this }} WHERE O_TOTALPRICE < 0", true, "After")
SELECT
    `O_ORDERKEY`                         AS `O_ORDERKEY`         @id("2c3301") @isBusinessKey @primaryKey(1) @clusterKey(1) @not_null @uniqueness,
    `O_CUSTKEY`                          AS `O_CUSTKEY`          @id("2c3302") @clusterKey(2) @not_null,
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`      @id("2c3303") @accepted_values("'F'") @accepted_values("'O'") @accepted_values("'P'"),
    `O_TOTALPRICE`                       AS `O_TOTALPRICE`       @id("2c3304") @min_value("0"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`        @id("2c3305") @not_null @min_max("DATE '1992-01-01'", "DATE '1998-12-31'"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`    @id("2c3306") @rejected_values("''"),
    `O_CLERK`                            AS `O_CLERK`            @id("2c3307") @empty,
    `O_SHIPPRIORITY`                     AS `O_SHIPPRIORITY`     @id("2c3308"),
    `O_COMMENT`                          AS `O_COMMENT`          @id("2c3309") @description("Order comment"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("2c330a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("2c330b") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
