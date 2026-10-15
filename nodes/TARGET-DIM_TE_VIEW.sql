@id("c2d87c85-a985-4646-8def-cbec7b131996")
@nodeType("SQLDimension")
@description("Table expiration test - view materialization; tableExpiration in days applies to views too")
@materializationType("view")
@tableExpiration("30")
SELECT
    CAST("0" AS STRING)                  AS `DIM_TE_VIEW_KEY`    @id("a40001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("a40002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`             @id("a40003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("a40004"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("a40005"),
    `last_modified`                      AS `last_modified`      @id("a40006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("a40007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("a40008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
