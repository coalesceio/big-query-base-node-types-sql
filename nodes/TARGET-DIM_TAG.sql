@id("60bad7c7-193a-4b8f-9716-ad6134329f8b")
@nodeType("SQLDimension")
@description("Dimension test - repeatable @tag: env = dev and cost_center = finance; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    CAST("0" AS STRING)                  AS `DIM_TAG_KEY`        @id("f50001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("f50002") @isBusinessKey,
    `N_NAME`                             AS `N_NAME`             @id("f50003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("f50004"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("f50005"),
    `last_modified`                      AS `last_modified`      @id("f50006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("f50007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("f50008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
