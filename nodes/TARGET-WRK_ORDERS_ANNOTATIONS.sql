@id("fd674048-ee52-4cc0-9810-51b9bb0c7925")
@nodeType("705")
@description("Annotation test - orders with date range, freshness, relative_time and accepted-values column tests")
@tests("SELECT 1 FROM {{ this }} GROUP BY O_ORDERKEY HAVING COUNT(*) > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} WHERE O_TOTALPRICE < 0")
@preSQL("DELETE FROM {{ this }} WHERE O_ORDERDATE < DATE '1900-01-01'")
SELECT
    `O_ORDERKEY`                 AS `O_ORDERKEY`      @id("fd6741") @notNull @not_null @uniqueness @min_value("1"),
    `O_CUSTKEY`                  AS `O_CUSTKEY`       @id("fd6742") @not_null,
    `O_ORDERSTATUS`              AS `O_ORDERSTATUS`   @id("fd6743") @accepted_values("'F'") @accepted_values("'O'") @accepted_values("'P'"),
    `O_TOTALPRICE`               AS `O_TOTALPRICE`    @id("fd6744") @min_value("0") @description("Order total price"),
    `O_ORDERDATE`                AS `O_ORDERDATE`     @id("fd6745") @not_null @min_max("DATE '1992-01-01'", "DATE '1998-12-31'") @relative_time("<=", "LOAD_DATE"),
    `O_ORDERPRIORITY`            AS `O_ORDERPRIORITY` @id("fd6746") @accepted_values("'1-URGENT'") @accepted_values("'2-HIGH'") @accepted_values("'3-MEDIUM'") @accepted_values("'4-NOT SPECIFIED'") @accepted_values("'5-LOW'"),
    `O_CLERK`                    AS `O_CLERK`         @id("fd6747") @empty,
    `O_SHIPPRIORITY`             AS `O_SHIPPRIORITY`  @id("fd6748") @accepted_values("0"),
    `O_COMMENT`                  AS `O_COMMENT`       @id("fd6749") @defaultValue("'NA'"),
    CURRENT_DATE()               AS `LOAD_DATE`       @id("fd674a") @notNull @freshness(1, "DAY") @description("Load date")
FROM {{ ref('SRC', 'orders') }} `orders`
