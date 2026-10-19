@id("5caaef82-9ee1-4f32-8ac9-e05a00158708")
@nodeType("SQLFact")
@description("Pipeline - monthly customer revenue fact: aggregated in a CTE and joined to the current customer dimension; allColumnMatch inserts only rows not already loaded")
@mergeStrategy("allColumnMatch")
@partitionBy("ORDER_MONTH")
@tests("SELECT x FROM UNNEST([1]) AS x WHERE x < 1", true, "After")
WITH `monthly` AS (
    SELECT
        `CUSTOMER_KEY`,
        DATE_TRUNC(`ORDER_DATE`, MONTH) AS `ORDER_MONTH`,
        COUNT(*)                        AS `ORDER_COUNT`,
        SUM(`TOTAL_PRICE`)              AS `REVENUE`
    FROM {{ ref('TARGET', 'WRK_ORDERS') }}
    GROUP BY 1, 2
)
SELECT
    CAST(`m`.`CUSTOMER_KEY` AS INT64)                      AS `CUSTOMER_KEY`       @id("c30001") @not_null,
    CAST(COALESCE(`c`.`DIM_CUSTOMER_KEY`, '0') AS STRING)  AS `CUSTOMER_SK`        @id("c30002") @clusterKey(1),
    CAST(`m`.`ORDER_MONTH` AS DATE)                        AS `ORDER_MONTH`        @id("c30003") @not_null,
    CAST(`m`.`ORDER_COUNT` AS INT64)                       AS `ORDER_COUNT`        @id("c30004") @min_value("1"),
    CAST(`m`.`REVENUE` AS NUMERIC)                         AS `REVENUE`            @id("c30005") @min_value("0"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                   AS `SYSTEM_CREATE_DATE` @id("c30006") @isSystemCreateDate
FROM `monthly` `m`
LEFT JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `c`
    ON `m`.`CUSTOMER_KEY` = `c`.`CUSTOMER_KEY`
   AND `c`.`SYSTEM_CURRENT_FLAG` = 'Y'
