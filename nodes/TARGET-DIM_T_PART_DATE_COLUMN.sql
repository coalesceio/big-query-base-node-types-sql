@id("ca560836-6394-44f5-9754-4cece6b22502")
@nodeType("SQLDimension")
@description("Test - partitionBy a plain DATE column; changeTracking SCD Type 1")
@mergeStrategy("changeTracking")
@partitionBy("LOAD_DATE")
SELECT
    0                                    AS `DIM_T_PART_DATE_COLUMN_KEY` @id("c20001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`                @id("c20002") @isBusinessKey @not_null @uniqueness,
    `N_NAME`                             AS `N_NAME`                     @id("c20003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`                @id("c20004"),
    `N_COMMENT`                          AS `N_COMMENT`                  @id("c20005"),
    `last_modified`                      AS `last_modified`              @id("c20006"),
    CAST(DATE(`last_modified`) AS DATE)  AS `LOAD_DATE`                  @id("c20007"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`         @id("c20008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`         @id("c20009") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`