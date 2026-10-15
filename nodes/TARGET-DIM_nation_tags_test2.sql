@id("32c8fa3a-a7a5-49d2-a68a-46ffaa349e6f")
@nodeType("SQLDimension")
SELECT
    CAST("0" AS STRING)                      AS `DIM_nation_KEY`      @id("15900f") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("d2aed8") @isBusinessKey,
    `N_NAME`                                 AS `N_NAME`              @id("a96068"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("552b0c"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("fecf03"),
    `last_modified`                          AS `last_modified`       @id("3ae16f"),
    1                                        AS `SYSTEM_VERSION`      @id("35ff5b") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("6496c4") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("fa0550") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("f02259") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("dcd084") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`