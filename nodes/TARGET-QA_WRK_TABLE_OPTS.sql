@id("8282ea7e-c0f9-4d62-ad3d-0b07282d47e3")
@nodeType("SQLWork")
@materializationType("table")
@description("QA Work table - node partition expression, partition/table expiration, rounding, tags, cluster, composite PK, NOT NULL, default, pre/post SQL, node tests")
@partitionBy("DATE_TRUNC(LOAD_DATE, MONTH)")
@partitionExpirationDays("365")
@tableExpiration("30")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
@preSQL("CREATE TABLE IF NOT EXISTS `cls-dev-bigquery.DE_QA_TAN.QA_AUDIT_LOG` (`NODE_NAME` STRING, `STEP` STRING, `LOGGED_AT` TIMESTAMP)")
@preSQL("INSERT INTO `cls-dev-bigquery.DE_QA_TAN.QA_AUDIT_LOG` VALUES ('QA_WRK_TABLE_OPTS', 'preSQL', CURRENT_TIMESTAMP())")
@postSQL("UPDATE {{ this }} SET `n_Comment` = 'SET BY POSTSQL' WHERE `n_NationKey` = 1")
@postSQL("INSERT INTO `cls-dev-bigquery.DE_QA_TAN.QA_AUDIT_LOG` VALUES ('QA_WRK_TABLE_OPTS', 'postSQL', CURRENT_TIMESTAMP())")
@tests("SELECT COUNT(*) AS `N` FROM {{ ref('TARGET', 'QA_WRK_FEED') }} HAVING COUNT(*) = 0", false, "Before")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `n_NationKey` = 1 AND `n_Comment` <> 'SET BY POSTSQL'", true, "After")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`    @notNull @primaryKey(1) @clusterKey(1) @description("Nation key"),
    `F`.`n_Name`                             AS `n_Name`         @notNull @clusterKey(2) @description("Nation name"),
    `F`.`n_RegionKey`                        AS `n_RegionKey`    @notNull @primaryKey(2) @clusterKey(3) @tag("env", "dev") @description("Region key - the column tag must only warn"),
    `F`.`n_Comment`                          AS `n_Comment`      @defaultValue("'NA'") @description("Comment, defaults to NA"),
    CAST(`F`.`n_NationKey` / 7 AS NUMERIC)   AS `N_RATIO`        @description("Rounded with the table default_rounding_mode"),
    CAST(DATE(`F`.`last_Modified`) AS DATE)  AS `LOAD_DATE`      @notNull @description("Source of the monthly partition")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
