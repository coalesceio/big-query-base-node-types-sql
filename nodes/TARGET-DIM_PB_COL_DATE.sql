@id("7a135812-d0ec-4870-bb71-9df8acb0dda5")
@nodeType("SQLDimension")
@description("PartitionBy test - column-level bare @partitionBy on a DATE column L_SHIPDATE (used as-is); composite business key; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_COL_DATE_KEY`  @id("d80001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `L_ORDERKEY`                             AS `L_ORDERKEY`           @id("d80002") @isBusinessKey @not_null,
    `L_LINENUMBER`                           AS `L_LINENUMBER`         @id("d80003") @isBusinessKey @not_null,
    CAST(`L_QUANTITY` AS NUMERIC)                  AS `L_QUANTITY`           @id("d80004"),
    CAST(`L_EXTENDEDPRICE` AS NUMERIC)             AS `L_EXTENDEDPRICE`      @id("d80005"),
    `L_RETURNFLAG`                           AS `L_RETURNFLAG`         @id("d80006"),
    `L_LINESTATUS`                           AS `L_LINESTATUS`         @id("d80007"),
    `L_SHIPDATE`                             AS `L_SHIPDATE`           @id("d80008") @partitionBy,
    `L_COMMITDATE`                           AS `L_COMMITDATE`         @id("d80009"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("d8000a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("d8000b") @isSystemUpdateDate
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
