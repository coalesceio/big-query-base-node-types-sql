@id("bde6d290-ad42-49e5-b56e-d4452fe230e9")
@nodeType("729")
@description("Fact annotation test - lastModified merge on nation using the TIMESTAMP last_modified column; mixed-case strategy value, primary key, datetime table expiration, pre/post SQL")
@mergeStrategy("LastModified")
@writeMode("append")
@tableExpiration("2027-12-31 23:59:59")
@preSQL("SELECT COUNT(*) FROM {{ this }}")
@postSQL("UPDATE {{ this }} SET N_COMMENT = TRIM(N_COMMENT) WHERE N_COMMENT <> TRIM(N_COMMENT)")
SELECT
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("bde601") @isBusinessKey @primaryKey(1) @not_null @uniqueness @min_max("0", "24"),
    `N_NAME`                             AS `N_NAME`             @id("bde602") @not_null @empty,
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("bde603") @min_max("0", "4"),
    `N_COMMENT`                          AS `N_COMMENT`          @id("bde604"),
    `last_modified`                      AS `last_modified`      @id("bde605") @lastModifiedTracking @not_null,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("bde606") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("bde607") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
