@id("18cbd200-0418-4ddf-bd52-0db1b0dbf8ce")
@nodeType("728")
@description("Test - view materialization; table-only annotations below must be ignored")
@materializationType("view")
@partitionBy("DATE(last_modified)")
@tableExpiration("30")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
SELECT
    0                                    AS `DIM_T_VIEW_KEY`     @id("b80001") @isSurrogateKey,
    `N_NATIONKEY`                        AS `N_NATIONKEY`        @id("b80002") @isBusinessKey @not_null @uniqueness @primaryKey(1),
    `N_NAME`                             AS `N_NAME`             @id("b80003"),
    `N_REGIONKEY`                        AS `N_REGIONKEY`        @id("b80004") @clusterKey(1),
    `N_COMMENT`                          AS `N_COMMENT`          @id("b80005"),
    `last_modified`                      AS `last_modified`      @id("b80006"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b80007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("b80008") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} `nation`
