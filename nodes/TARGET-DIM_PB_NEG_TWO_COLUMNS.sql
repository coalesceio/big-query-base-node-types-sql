@id("5ebd43d6-e7d1-402f-8c24-4c01b5c67de9")
@nodeType("SQLDimension")
@description("PartitionBy NEGATIVE test - bare @partitionBy on two columns L_SHIPDATE and L_COMMITDATE; create should stop")
@mergeStrategy("upsert")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_NEG_TWO_COLUMNS_KEY` @id("de0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `L_ORDERKEY`                             AS `L_ORDERKEY`           @id("de0002") @isBusinessKey @not_null,
    `L_LINENUMBER`                           AS `L_LINENUMBER`         @id("de0003") @isBusinessKey @not_null,
    `L_QUANTITY`                             AS `L_QUANTITY`           @id("de0004"),
    `L_EXTENDEDPRICE`                        AS `L_EXTENDEDPRICE`      @id("de0005"),
    `L_RETURNFLAG`                           AS `L_RETURNFLAG`         @id("de0006"),
    `L_LINESTATUS`                           AS `L_LINESTATUS`         @id("de0007"),
    `L_SHIPDATE`                             AS `L_SHIPDATE`           @id("de0008") @partitionBy,
    `L_COMMITDATE`                           AS `L_COMMITDATE`         @id("de0009"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("de000a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("de000b") @isSystemUpdateDate
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
