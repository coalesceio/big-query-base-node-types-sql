@id("b6f730c9-7a0b-408e-ae5f-85b33205de8b")
@nodeType("728")
@description("Nation dimension keyed on N_NATIONKEY")
@mergeStrategy("changeTracking")
SELECT
    0                                         AS `DIM_NATION_PK_KEY`   @id("6f7301") @isSurrogateKey,
    `N_NATIONKEY`                             AS `N_NATIONKEY`         @id("6f7302") @isBusinessKey @primaryKey @not_null @uniqueness,
    `N_NAME`                                  AS `N_NAME`              @id("6f7303"),
    `N_REGIONKEY`                             AS `N_REGIONKEY`         @id("6f7304"),
    `N_COMMENT`                               AS `N_COMMENT`           @id("6f7305"),
    `last_modified`                           AS `last_modified`       @id("6f7306"),
    1                                         AS `SYSTEM_VERSION`      @id("6f7307") @isSystemVersion,
    CAST('Y' AS STRING)                       AS `SYSTEM_CURRENT_FLAG` @id("6f7308") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_CREATE_DATE`  @id("6f7309") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)      AS `SYSTEM_UPDATE_DATE`  @id("6f730a") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP)  AS `SYSTEM_END_DATE`     @id("6f730b") @isSystemEndDate
FROM {{ ref('SRC', 'nation') }} `nation`
