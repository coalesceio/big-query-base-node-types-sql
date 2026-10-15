@id("3287defd-070b-4d78-88a2-e5f75398dd5d")
@nodeType("SQLDimension")
@description("Tag test - view materialization; tags apply to views too")
@materializationType("view")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    CAST("0" AS STRING)                  AS `DIM_TAG_VIEW_KEY`   @id("a80001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("a80002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`             @id("a80003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("a80004"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("a80005"),
    `last_modified`                      AS `last_modified`      @id("a80006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("a80007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("a80008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
