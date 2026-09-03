@id("8ffea9e7-bde7-4e89-b996-2db4d546c82b")
@nodeType("705")
SELECT *
FROM {{ ref('SRC', 'stock_prices') }} `stock_prices`
MATCH_RECOGNIZE (
  PARTITION BY symbol
  ORDER BY trade_time

  MEASURES
    FIRST(up.price) AS start_price,
    LAST(up.price) AS end_price

  PATTERN (up+)

  DEFINE
    up AS up.price > PREV(up.price)
);