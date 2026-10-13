@id("bc5223af-a2b9-41d9-8fdb-0a4d1f7f5c43")
@nodeType("729")
@description("Fact test - changeTracking merge; integer-range partition, clusterKey")
@mergeStrategy("changeTracking")
@partitionBy("RANGE_BUCKET(N_NATIONKEY, GENERATE_ARRAY(0, 100, 5))")
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("d10001") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`             @id("d10002") @clusterKey(2),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("d10003") @clusterKey(1),
    `N_COMMENT`                          AS `N_COMMENT`          @id("d10004"),
    `last_modified`                      AS `last_modified`      @id("d10005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("d10006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("d10007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
