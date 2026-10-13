@id("decf3fc2-01f4-474f-8f39-b2ab79813d76")
@nodeType("729")
@description("Fact annotation test - no business key on region, so a plain INSERT; truncateInsert, ingestion-time partition with expiration, tests skipped by @disableTests")
@writeMode("truncateInsert")
@partitionBy("_PARTITIONDATE")
@partitionExpirationDays(7)
@disableTests
@tests("SELECT 1 FROM {{ this }}", false, "After")
SELECT
    `R_REGIONKEY`                        AS `R_REGIONKEY`        @id("decf01") @notNull @not_null @uniqueness @min_max("0", "4"),
    `R_NAME`                             AS `R_NAME`             @id("decf02") @not_null @accepted_values("'AFRICA'") @accepted_values("'AMERICA'") @accepted_values("'ASIA'") @accepted_values("'EUROPE'") @accepted_values("'MIDDLE EAST'"),
    `R_COMMENT`                          AS `R_COMMENT`          @id("decf03") @description("Region comment"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("decf04") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("decf05") @isSystemUpdateDate
FROM {{ ref('SRC', 'region') }} `region`
