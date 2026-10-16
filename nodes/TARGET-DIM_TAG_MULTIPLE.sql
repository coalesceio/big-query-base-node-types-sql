@id("95b74920-6819-4cd0-b4b6-f00f45ec8eb4")
@nodeType("SQLDimension")
@description("Tag test - two tags (env = dev, cost_center = finance); upsert")
@mergeStrategy("upsert")
@tag("env", "dev")
SELECT
    CAST("0" AS STRING)                  AS `DIM_TAG_MULTIPLE_KEY` @id("a60001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `O_ORDERKEY`                         AS `O_ORDERKEY`           @id("a60002") @isBusinessKey @not_null @uniqueness,
    `O_CUSTKEY`                          AS `O_CUSTKEY`            @id("a60003"),
    `O_ORDERSTATUS`                      AS `O_ORDERSTATUS`        @id("a60004"),
    CAST(`O_TOTALPRICE` AS NUMERIC)      AS `O_TOTALPRICE`         @id("a60005"),
    `O_ORDERDATE`                        AS `O_ORDERDATE`          @id("a60006"),
    `O_ORDERPRIORITY`                    AS `O_ORDERPRIORITY`      @id("a60007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`   @id("a60008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`   @id("a60009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
