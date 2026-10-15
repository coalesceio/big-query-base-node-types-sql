@id("d2f045b9-da1b-4799-9df8-943a1c9dd899")
@nodeType("SQLDimension")
SELECT
    CAST("0" AS STRING)                      AS `DIM_region_KEY`      @id("69e4d5") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `R_REGIONKEY`                            AS `R_REGIONKEY`         @id("9d580d") @isBusinessKey,
    `R_NAME`                                 AS `R_NAME`              @id("50f65a"),
    `R_COMMENT`                              AS `R_COMMENT`           @id("4be732"),
    1                                        AS `SYSTEM_VERSION`      @id("bdeb2e") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("7ae6bd") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("ac9f0e") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("92494b") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("0d99f1") @isSystemEndDate
FROM {{ ref('SRC', 'region') }} `region`