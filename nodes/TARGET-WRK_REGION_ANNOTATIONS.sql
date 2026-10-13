@id("8981e231-8d04-495b-a07c-4c534d3dfe21")
@nodeType("705")
@description("Annotation test - region with explicit truncateInsert, node-level tests, pre/post SQL and value-list column tests")
@materializationType("table")
@writeMode("truncateInsert")
@tests("SELECT 1 FROM {{ this }} GROUP BY R_REGIONKEY HAVING COUNT(*) > 1")
@tests("SELECT 1 FROM {{ this }} WHERE R_NAME IS NULL", true, "Before")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) <> 5", false, "After")
@preSQL("DELETE FROM {{ this }} WHERE R_REGIONKEY IS NULL")
@postSQL("UPDATE {{ this }} SET R_COMMENT = TRIM(R_COMMENT) WHERE R_COMMENT IS NOT NULL")
@postSQL("UPDATE {{ this }} SET R_NAME = UPPER(R_NAME) WHERE R_NAME IS NOT NULL")
SELECT
    `R_REGIONKEY`                AS `R_REGIONKEY` @id("8981e1") @notNull @not_null @uniqueness @min_max("0", "4") @description("Region key"),
    `R_NAME`                     AS `R_NAME`      @id("8981e2") @not_null @empty @accepted_values("'AFRICA'") @accepted_values("'AMERICA'") @accepted_values("'ASIA'") @accepted_values("'EUROPE'") @accepted_values("'MIDDLE EAST'"),
    `R_COMMENT`                  AS `R_COMMENT`   @id("8981e3") @defaultValue("'NA'") @rejected_values("'NA'") @description("Region comment"),
    CAST(CURRENT_TIMESTAMP() AS TIMESTAMP) AS `LOAD_TS` @id("8981e4") @freshness(1, "DAY")
FROM {{ ref('SRC', 'region') }} `region`
