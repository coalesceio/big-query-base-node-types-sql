@id("f8237706-17b1-4bac-ae39-a05695099b20")
@nodeType("SQLDimension")
@description("Tag test - one tag (env = dev), qualified with the node location's project; changeTracking SCD Type 2")
@mergeStrategy("changeTracking")
@tag("env", "dev")
SELECT
    CAST("0" AS STRING)                      AS `DIM_TAG_SINGLE_KEY`  @id("a50001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("a50002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`              @id("a50003") @isChangeTracking,
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("a50004"),
    `N_COMMENT`                              AS `N_COMMENT`           @id("a50005"),
    1                                        AS `SYSTEM_VERSION`      @id("a50006") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("a50007") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("a50008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("a50009") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("a5000a") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
