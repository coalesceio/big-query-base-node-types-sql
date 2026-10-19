@id("e5c10076-f74e-4bd7-bf3b-f3a36a83da1f")
@nodeType("SQLDimension")
@description("Dimension test - @tableExpiration with a fixed datetime; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@tableExpiration("2027-12-31 23:59:59")
SELECT
    CAST("0" AS STRING)                  AS `DIM_TABLE_EXPIRATION_KEY` @id("f30001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`              @id("f30002") @isBusinessKey,
    `N_NAME`                             AS `N_NAME`                   @id("f30003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`              @id("f30004"),
    `N_COMMENT`                          AS `N_COMMENT`                @id("f30005"),
    `last_modified`                      AS `last_modified`            @id("f30006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`       @id("f30007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`       @id("f30008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
