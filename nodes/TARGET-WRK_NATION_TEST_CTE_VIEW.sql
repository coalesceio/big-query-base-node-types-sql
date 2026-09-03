@id("37a00602-1bfb-4a4b-8f6b-ba92f9e4c414")
@nodeType("705")
@materializationType("view")
WITH nation_cte AS (
    SELECT
        N_NATIONKEY,
        N_NAME,
        N_REGIONKEY
    FROM {{ ref('SRC', 'nation') }} `nation`
),
region_cte AS (
    SELECT
        N_REGIONKEY,
        COUNT(*) AS nation_count
    FROM {{ ref('SRC', 'nation') }} `nation`
    GROUP BY N_REGIONKEY
)
SELECT
    n.N_NAME,
    r.nation_count @description("Region''' Count")
FROM nation_cte n
JOIN region_cte r
    ON n.N_REGIONKEY = r.N_REGIONKEY