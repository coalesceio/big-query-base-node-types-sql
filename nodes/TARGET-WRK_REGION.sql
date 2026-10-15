@id("ef9fff1f-eb86-422b-bc4d-1616937fb535")
@nodeType("SQLWork")
@materializationType("table")
@description("Work 1 - region staged from SRC: truncateInsert, primary key, node-level tests")
@writeMode("truncateInsert")
@tests("SELECT 1 FROM {{ this }} GROUP BY `R_REGIONKEY` HAVING COUNT(*) > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `R_NAME` IS NULL")
SELECT
    `R_REGIONKEY`                          AS `R_REGIONKEY` @id("ef9f01") @notNull @primaryKey(1) @not_null @uniqueness @min_max("0", "4") @description("Region key"),
    CAST(UPPER(TRIM(`R_NAME`)) AS STRING)                  AS `R_NAME`      @id("ef9f02") @not_null @empty @accepted_values("'AFRICA', 'AMERICA', 'ASIA', 'EUROPE', 'MIDDLE EAST'") @description("Region name, trimmed and upper-cased"),
    `R_COMMENT`                            AS `R_COMMENT`   @id("ef9f03") @defaultValue("'NA'") @description("Free-text comment"),
    CAST(CURRENT_TIMESTAMP() AS TIMESTAMP) AS `LOAD_TS`     @id("ef9f04") @freshness(1, "DAY") @description("Load timestamp")
FROM {{ ref('SRC', 'region') }} `region`
