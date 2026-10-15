@id("bd4d56fc-5be8-467f-8243-cf910649ef3e")
@nodeType("728")
SELECT
    0                                        AS `DIM_nation_KEY`      @id("d08539") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("3f0102"),
    `N_NAME`                                 AS `N_NAME`              @id("865bd7"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("5fc7b2"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("67d71d"),
    `last_modified`                          AS `last_modified`       @id("76c1ba"),
    1                                        AS `SYSTEM_VERSION`      @id("0cf187") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("9913fb") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d4ce82") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("532502") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("4c0848") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`