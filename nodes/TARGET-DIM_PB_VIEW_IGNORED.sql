@id("2ee09cc9-e6d7-4621-a3a3-3988346c3224")
@nodeType("SQLDimension")
@description("PartitionBy test - view materialization; @partitionBy and @partitionExpirationDays are ignored on views")
@materializationType("view")
@partitionBy("DATE(last_modified)")
@partitionExpirationDays(30)
SELECT
    CAST("0" AS STRING)                      AS `DIM_PB_VIEW_IGNORED_KEY` @id("dc0001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`          @id("dc0002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                                 AS `N_NAME`               @id("dc0003"),
    `N_REGIONKEY`                            AS `N_REGIONKEY`          @id("dc0004"),
    `N_COMMENT`                              AS `N_COMMENT`            @id("dc0005"),
    `last_modified`                          AS `last_modified`        @id("dc0006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("dc0007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("dc0008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
