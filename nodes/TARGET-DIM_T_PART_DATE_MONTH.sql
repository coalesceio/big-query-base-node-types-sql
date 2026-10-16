@id("edfb25a5-2f0b-4181-95a6-c3c88caa0b50")
@nodeType("SQLDimension")
@description("Test - partitionBy DATE_TRUNC on a DATE column, monthly partitions; lastModified SCD Type 2")
@mergeStrategy("lastModified")
@partitionBy("DATE_TRUNC(LOAD_DATE, MONTH)")
@tableExpiration("2999-12-31")
SELECT
    0                                        AS `DIM_T_PART_DATE_MONTH_KEY` @id("c30001") @isSurrogateKey,
    `N_NATIONKEY`                            AS `N_NATIONKEY`               @id("c30002") @isBusinessKey @not_null @uniqueness,
    `N_REGIONKEY`                            AS `N_REGIONKEY`               @id("c30004"),
    `N_COMMENT`                              AS `N_COMMENT`                 @id("c30005"),
    `last_modified`                          AS `last_modified`             @id("c30006") @lastModifiedTracking(2) @not_null,
    CAST(DATE(`last_modified`) AS DATE)      AS `LOAD_DATE`                 @id("c30007"),
    1                                        AS `SYSTEM_VERSION`            @id("c30008") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG`       @id("c30009") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`        @id("c3000a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`        @id("c3000b") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`           @id("c3000c") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
