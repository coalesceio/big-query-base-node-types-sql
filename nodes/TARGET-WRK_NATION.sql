@id("06624348-0a5d-43c8-b41d-d01b7285c081")
@nodeType("SQLWork")
@materializationType("table")
@description("Work 2 - nation staged from SRC: clustering, composite primary key, tags, rounding mode")
@writeMode("truncateInsert")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tests("SELECT 1 FROM {{ this }} GROUP BY `N_NATIONKEY` HAVING COUNT(*) > 1", true)
SELECT
    `N_NATIONKEY`                                 AS `N_NATIONKEY`       @id("066201") @notNull @primaryKey(1) @clusterKey(1) @not_null @uniqueness @min_max("0", "24") @description("Nation key"),
    `N_NAME`                                      AS `N_NAME`            @id("066202") @notNull @clusterKey(2) @not_null @empty @description("Nation name"),
    CAST(COALESCE(`N_REGIONKEY`, -1) AS INT64)    AS `N_REGIONKEY`       @id("066203") @notNull @primaryKey(2) @clusterKey(3) @min_max("-1", "4") @description("Region key, -1 when missing"),
    `N_COMMENT`                                   AS `N_COMMENT`         @id("066204") @defaultValue("'NA'") @description("Free-text comment"),
    CAST(`N_NATIONKEY` / 7 AS NUMERIC)            AS `N_NATIONKEY_RATIO` @id("066205") @description("Rounded with the table default_rounding_mode"),
    CAST(COALESCE(`last_modified`, TIMESTAMP '1900-01-01 00:00:00') AS TIMESTAMP) AS `LAST_MODIFIED` @id("066206") @notNull @not_null @description("Source last modified time, defaulted when NULL")
FROM {{ ref('SRC', 'nation') }} `nation`
