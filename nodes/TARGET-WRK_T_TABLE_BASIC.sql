@id("5750a7aa-1272-4da0-a77e-f50a6d311cdf")
@nodeType("705")
@description("Work test - plain table, append writeMode, pre/post SQL, hash and column tests")
@writeMode("append")
@preSQL("SELECT 1")
@postSQL("SELECT 1")
SELECT
    `N_NATIONKEY`                               AS `N_NATIONKEY`   @not_null @inHash("GH_NATION", 1),
    `N_NAME`                                    AS `N_NAME`        @empty @inHash("GH_NATION", 2),
    `N_REGIONKEY`                               AS `N_REGIONKEY`   @min_max("0", "4"),
    `N_COMMENT`                                 AS `N_COMMENT`,
    `last_modified`                             AS `last_modified`,
    CAST({{ get_hash('GH_NATION') }} AS STRING) AS `GH_NATION`
FROM {{ ref('SRC', 'nation') }} `nation`
