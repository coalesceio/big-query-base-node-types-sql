@id("b230f44b-79a7-44c8-90db-0ab623c5d0f2")
@nodeType("SQLDimension")
@description("Test - changeTracking SCD Type 1; clusterKey on 2 columns, single-column primaryKey")
@mergeStrategy("changeTracking")
SELECT
    0                                    AS `DIM_T_CT_SCD1_CLUSTER_KEY` @id("b10001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`               @id("b10002") @isBusinessKey @not_null @uniqueness @primaryKey(1),
    `N_NAME`                             AS `N_NAME`                    @id("b10003") @clusterKey(2),
    `N_REGIONKEY`                        AS `N_REGIONKEY`               @id("b10004") @clusterKey(1),
    `N_COMMENT`                          AS `N_COMMENT`                 @id("b10005") @clusterKey(3),
    `last_modified`                      AS `last_modified`             @id("b10006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`        @id("b10007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`        @id("b10008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`