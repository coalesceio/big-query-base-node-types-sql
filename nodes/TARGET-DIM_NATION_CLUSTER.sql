@id("b3ba7fa4-ccde-41db-86df-f0ffd09970b0")
@nodeType("728")
@description("Cluster key test - changeTracking SCD Type 1, clustered by N_REGIONKEY, N_NAME")
@mergeStrategy("changeTracking")
SELECT
    0                                    AS `DIM_NATION_CLUSTER_KEY` @id("c10001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`            @id("c10002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`                 @id("c10003") @clusterKey('N_REGIONKEY'),
    `N_REGIONKEY`                        AS `N_REGIONKEY`            @id("c10004") @clusterKey(1),
    `N_COMMENT`                          AS `N_COMMENT`              @id("c10005"),
    `last_modified`                      AS `last_modified`          @id("c10006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`     @id("c10007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`     @id("c10008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
