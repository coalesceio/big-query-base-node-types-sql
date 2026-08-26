@id("11573856-34ab-4472-964e-dedee886ee47")
@nodeType("705")
WITH combined_data AS (
    SELECT
        c.c_name AS nation,
        r.r_name AS region,
        c.c_custkey AS customer_key,
        o.o_orderkey AS order_key,
        l.l_linenumber AS line_number,
        l.l_extendedprice AS extended_price
    FROM {{ ref('SRC', 'customer') }} c
    JOIN {{ ref('SRC', 'nation') }} n
        ON c.c_nationkey = n.n_nationkey
    JOIN {{ ref('SRC', 'region') }} r
        ON n.n_regionkey = r.r_regionkey
    JOIN {{ ref('SRC', 'orders') }} o
        ON c.c_custkey = o.o_custkey
    JOIN {{ ref('SRC', 'lineitem') }} l
        ON o.o_orderkey = l.l_orderkey

    UNION ALL

    SELECT
        n.n_name AS nation,
        r.r_name AS region,
        c.c_custkey AS customer_key,
        o.o_orderkey AS order_key,
        l.l_linenumber AS line_number,
        l.l_extendedprice AS extended_price
    FROM {{ ref('SRC', 'nation') }} n
    JOIN {{ ref('SRC', 'region') }} r
        ON n.n_regionkey = r.r_regionkey
    JOIN {{ ref('SRC', 'customer') }} c
        ON c.c_nationkey = n.n_nationkey
    JOIN {{ ref('SRC', 'orders') }} o
        ON c.c_custkey = o.o_custkey
    JOIN {{ ref('SRC', 'lineitem') }} l
        ON o.o_orderkey = l.l_orderkey
)

SELECT
    nation @notNull,
    region,
    COUNT(DISTINCT customer_key) AS customer_count @defaultValue("0"),
    COUNT(DISTINCT order_key) AS order_count
FROM combined_data
GROUP BY nation, region