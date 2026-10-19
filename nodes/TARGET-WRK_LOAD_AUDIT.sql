@id("8fc62be0-3544-450d-be20-7f7e34f0dfdc")
@nodeType("SQLWork")
@description("Pipeline - audit: row counts of the staging nodes (UNION ALL in a CTE), appended each run into an ingestion-time partition kept for 30 days")
@writeMode("append")
@partitionBy("_PARTITIONDATE")
@partitionExpirationDays(30)
WITH `counts` AS (
    SELECT 'WRK_GEOGRAPHY' AS `SOURCE_NODE`, COUNT(*) AS `ROW_COUNT` FROM {{ ref('TARGET', 'WRK_GEOGRAPHY') }}
    UNION ALL
    SELECT 'WRK_CUSTOMER', COUNT(*) FROM {{ ref('TARGET', 'WRK_CUSTOMER') }}
    UNION ALL
    SELECT 'WRK_ORDERS', COUNT(*) FROM {{ ref('TARGET', 'WRK_ORDERS') }}
    UNION ALL
    SELECT 'WRK_LINEITEM_AGG', COUNT(*) FROM {{ ref('TARGET', 'WRK_LINEITEM_AGG') }}
    UNION ALL
    SELECT 'WRK_ORDER_EVENTS', COUNT(*) FROM {{ ref('TARGET', 'WRK_ORDER_EVENTS') }}
)
SELECT
    CAST(`counts`.`SOURCE_NODE` AS STRING)    AS `SOURCE_NODE` @not_null,
    CAST(`counts`.`ROW_COUNT` AS INT64)       AS `ROW_COUNT`   @min_value("0"),
    CAST(CURRENT_TIMESTAMP() AS TIMESTAMP)    AS `LOADED_AT`   @freshness(1, "DAY")
FROM `counts` `counts`
