@id("8291b2ce-e9b5-4bbf-8c87-54b541801ffd")
@nodeType("SQLDimension")
@description("Table expiration test - tableExpiration as a date (expires 2027-12-31 23:59:59); lastModified SCD Type 2")
@mergeStrategy("lastModified")
@tableExpiration("2027-12-31")
SELECT
    CAST("0" AS STRING)                      AS `DIM_TE_DATE_KEY`     @id("a20001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("a20002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`              @id("a20003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("a20004"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("a20005"),
    `last_modified`                          AS `last_modified`       @id("a20006") @lastModifiedTracking(2) @not_null,
    1                                        AS `SYSTEM_VERSION`      @id("a20007") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("a20008") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("a20009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("a2000a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("a2000b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
