@id("29160b21-4831-4717-9d0b-2c14417aae9c")
@nodeType("SQLDimension")
@tag("table_type", "source")
SELECT
    CAST("0" AS STRING)                      AS `DIM_nation_KEY`      @id("65ee7d") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("08a3ca") @isBusinessKey,
    `N_NAME`                                 AS `N_NAME`              @id("11e149"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("5b1779"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("399a87"),
    `last_modified`                          AS `last_modified`       @id("941f5d"),
    1                                        AS `SYSTEM_VERSION`      @id("6f9808") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("add846") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("89da93") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("4562b4") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("2934b6") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`