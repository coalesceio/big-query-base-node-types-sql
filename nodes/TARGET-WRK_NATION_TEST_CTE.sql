@id("a13620ea-06ab-4cc1-a51f-f26f400f5403")
@nodeType("705")
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
    n.N_NAME @notNull @defaultValue("'NA'"),
    r.nation_count @description("Region''' Count")
FROM nation_cte n
JOIN region_cte r
    ON n.N_REGIONKEY = r.N_REGIONKEY