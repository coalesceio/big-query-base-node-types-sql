@id("5ea58e45-25f2-4f1a-8687-9af9e210f4a1")
@nodeType("728")
@description("SCD test - lastModified SCD1 on WRK_ORDERS_ANNOTATIONS keyed on LOAD_DATE; minimal SCD1 system columns, monthly partition, clustering and rounding mode")
@mergeStrategy("lastModified")
@writeMode("append")
@partitionBy("timeUnitColumn", "DATE_TRUNC(O_ORDERDATE, MONTH)")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tests("SELECT 1 FROM {{ this }} GROUP BY O_ORDERKEY HAVING COUNT(*) > 1", false, "After")
@tests("SELECT 1 FROM {{ ref('TARGET', 'WRK_ORDERS_ANNOTATIONS') }} GROUP BY O_ORDERKEY HAVING COUNT(*) > 1", false, "Before")
SELECT
    `O_ORDERKEY`                              AS `O_ORDERKEY`          @id("5ea501") @isBusinessKey @primaryKey @clusterKey(1) @not_null,
    `O_CUSTKEY`                               AS `O_CUSTKEY`           @id("5ea502") @clusterKey(2),
    `O_ORDERSTATUS`                           AS `O_ORDERSTATUS`       @id("5ea503") @accepted_values("'F'") @accepted_values("'O'") @accepted_values("'P'"),
    `O_TOTALPRICE`                            AS `O_TOTALPRICE`        @id("5ea504") @min_value("0"),
    `O_ORDERDATE`                             AS `O_ORDERDATE`         @id("5ea505") @not_null,
    `O_ORDERPRIORITY`                         AS `O_ORDERPRIORITY`     @id("5ea506"),
    `O_SHIPPRIORITY`                          AS `O_SHIPPRIORITY`      @id("5ea507"),
    `LOAD_DATE`                               AS `LOAD_DATE`           @id("5ea508") @lastModifiedTracking(1) @freshness(1, "DAY"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE`  @id("5ea509") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE`  @id("5ea50a") @isSystemUpdateDate @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'WRK_ORDERS_ANNOTATIONS') }} `WRK_ORDERS_ANNOTATIONS`
