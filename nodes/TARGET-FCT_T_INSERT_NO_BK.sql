@id("e41b75e7-7910-4326-aed8-1a04c0280015")
@nodeType("729")
@description("Fact test - no business key, so a plain INSERT; ingestion-time partition with expiration")
@partitionBy("_PARTITIONDATE")
@partitionExpirationDays(7)
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("d40001") @not_null,
    `N_NAME`                             AS `N_NAME`             @id("d40002"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("d40003"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("d40004"),
    `last_modified`                      AS `last_modified`      @id("d40005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("d40006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("d40007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
