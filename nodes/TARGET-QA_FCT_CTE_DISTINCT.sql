@id("81ea2347-8f52-4864-9c4a-50bf7df406de")
@nodeType("SQLFact")
@materializationType("table")
@description("QA Fact - upsert on a composite business key; window function in a CTE, de-duplicated with SELECT DISTINCT")
@mergeStrategy("upsert")
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_RegionKey`, `Name_Initial` HAVING COUNT(*) > 1")
@tests("SELECT `n_RegionKey`, UPPER(SUBSTR(`n_Name`, 1, 1)) FROM {{ ref('TARGET', 'QA_WRK_FEED') }} EXCEPT DISTINCT SELECT `n_RegionKey`, `Name_Initial` FROM {{ this }}")
WITH `BASE` AS (
    SELECT
        `F`.`n_RegionKey`                    AS `n_RegionKey`,
        UPPER(SUBSTR(`F`.`n_Name`, 1, 1))    AS `NAME_INITIAL`,
        `F`.`n_NationKey`                    AS `n_NationKey`
    FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
),
`WITH_COUNTS` AS (
    SELECT
        `B`.`n_RegionKey`                    AS `n_RegionKey`,
        `B`.`NAME_INITIAL`                   AS `NAME_INITIAL`,
        COUNT(*) OVER (PARTITION BY `B`.`n_RegionKey`, `B`.`NAME_INITIAL`) AS `NATIONS_WITH_INITIAL`
    FROM `BASE` `B`
)
SELECT DISTINCT
    CAST(`W`.`n_RegionKey` AS INT64)         AS `n_RegionKey`          @id("f7a001") @isBusinessKey,
    CAST(`W`.`NAME_INITIAL` AS STRING)       AS `Name_Initial`         @id("f7a002") @isBusinessKey,
    CAST(`W`.`NATIONS_WITH_INITIAL` AS INT64) AS `Nations_With_Initial` @id("f7a003") @min_value("1"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`   @id("f7a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`   @id("f7a009") @isSystemUpdateDate
FROM `WITH_COUNTS` `W`
