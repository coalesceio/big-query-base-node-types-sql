@id("78bb9a08-6358-4b51-9a4b-eba7a5b736a8")
@nodeType("705")
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