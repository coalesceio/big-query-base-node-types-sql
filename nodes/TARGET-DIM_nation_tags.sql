@id("e534ec9d-a844-40b0-9c03-801064b7e09f")
@nodeType("728")
@tag("cost_center", "finance")
SELECT
    0                                        AS `DIM_nation1_KEY`     @id("fcbdd9") @isSurrogateKey @isBusinessKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("254649"),
    `N_NAME`                                 AS `N_NAME`              @id("8467cf"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("945df4"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("3497bd"),
    `last_modified`                          AS `last_modified`       @id("804e58"),
    1                                        AS `SYSTEM_VERSION`      @id("9d5670") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("8e659b") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("3c7ea7") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("f0ee7e") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("63513f") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`