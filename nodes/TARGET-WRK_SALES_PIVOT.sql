@id("345b5013-5c15-4250-a2fe-34eeaf3e73f8")
@nodeType("705")
@description("Pivots quarterly sales amounts per salesperson; source rows are inline sample data in a CTE, no external table dependency. Uses conditional aggregation since this workspace's BigQuery-dialect parser does not accept the native PIVOT operator.")
WITH sample_sales AS (
    SELECT 'Alice' AS salesperson, 'Q1' AS quarter, 1000 AS amount
    UNION ALL SELECT 'Alice', 'Q2', 1500
    UNION ALL SELECT 'Alice', 'Q3', 1200
    UNION ALL SELECT 'Alice', 'Q4', 1800
    UNION ALL SELECT 'Bob', 'Q1', 2000
    UNION ALL SELECT 'Bob', 'Q2', 1800
    UNION ALL SELECT 'Bob', 'Q3', 1600
    UNION ALL SELECT 'Bob', 'Q4', 2200
    UNION ALL SELECT 'Carol', 'Q1', 1750
    UNION ALL SELECT 'Carol', 'Q2', 1650
    UNION ALL SELECT 'Carol', 'Q3', 1900
    UNION ALL SELECT 'Carol', 'Q4', 2100
)
SELECT
    CAST(`salesperson` AS STRING) AS `SALESPERSON` @description("Sales representative name"),
    SUM(CASE WHEN `quarter` = 'Q1' THEN `amount` END) AS `Q1` @description("Total sales amount for Q1"),
    SUM(CASE WHEN `quarter` = 'Q2' THEN `amount` END) AS `Q2` @description("Total sales amount for Q2"),
    SUM(CASE WHEN `quarter` = 'Q3' THEN `amount` END) AS `Q3` @description("Total sales amount for Q3"),
    SUM(CASE WHEN `quarter` = 'Q4' THEN `amount` END) AS `Q4` @description("Total sales amount for Q4")
FROM sample_sales
GROUP BY `salesperson`
