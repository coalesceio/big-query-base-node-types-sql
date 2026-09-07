@id("8ecedf41-beb4-4cae-9e56-6cf4f2f8bd26")
@nodeType("705")
@writeMode("append")
@disableTests
SELECT
     `O_ORDERKEY` AS `O_ORDERKEY`@not_null,
     `O_CUSTKEY` AS `O_CUSTKEY` @description("'NA'") @inHash("GH_COL1", 1),
     `O_ORDERSTATUS` AS `O_ORDERSTATUS` @inHash("GH_COL1", 2),
     `O_TOTALPRICE` AS `O_TOTALPRICE` @inHash("GH_COL1", 3),
     `O_ORDERDATE` AS `O_ORDERDATE`,
     `O_ORDERPRIORITY` AS `O_ORDERPRIORITY`,
     CAST({{ get_hash('GH_COL1') }} AS STRING) AS `GH_COL1` @description("Hash Column")
FROM {{ ref('SRC', 'orders') }} `orders`