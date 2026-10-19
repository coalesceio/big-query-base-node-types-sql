@id("592fdb32-85ff-4133-b3fe-8abc75db4b9c")
@nodeType("SQLWork")
@description("Pipeline - staging: order lifecycle events (placed, shipped, received) built with UNION ALL in a CTE, monthly partitions")
@writeMode("truncateInsert")
@partitionBy("DATE_TRUNC(EVENT_DATE, MONTH)")
WITH `events` AS (
    SELECT `ORDER_KEY`, 'PLACED' AS `EVENT_TYPE`, `ORDER_DATE` AS `EVENT_DATE`, 1 AS `EVENT_SEQUENCE`
    FROM {{ ref('TARGET', 'WRK_ORDERS') }}
    UNION ALL
    SELECT `ORDER_KEY`, 'SHIPPED', `FIRST_SHIP_DATE`, 2
    FROM {{ ref('TARGET', 'WRK_LINEITEM_AGG') }}
    UNION ALL
    SELECT `ORDER_KEY`, 'RECEIVED', `LAST_RECEIPT_DATE`, 3
    FROM {{ ref('TARGET', 'WRK_LINEITEM_AGG') }}
)
SELECT
    CAST(`e`.`ORDER_KEY` AS INT64)      AS `ORDER_KEY`      @not_null,
    CAST(`e`.`EVENT_TYPE` AS STRING)    AS `EVENT_TYPE`     @accepted_values("'PLACED', 'SHIPPED', 'RECEIVED'"),
    CAST(`e`.`EVENT_DATE` AS DATE)      AS `EVENT_DATE`     @not_null,
    CAST(`e`.`EVENT_SEQUENCE` AS INT64) AS `EVENT_SEQUENCE` @min_max("1", "3")
FROM `events` `e`
