@id("b545d155-6ab1-4110-863c-49fbeb57c8f5")
@nodeType("SQLFact")
@materializationType("table")
@description("Fact 4 - factless coverage of customer x nation x market segment from DIM_CUSTOMER and DIM_NATION_V: allColumnMatch")
@mergeStrategy("allColumnMatch")
@writeMode("append")
SELECT DISTINCT
    `dc`.`C_CUSTKEY`                     AS `C_CUSTKEY`          @id("b54501") @not_null @description("Customer key"),
    `dn`.`DIM_NATION_KEY`                AS `DIM_NATION_KEY`     @id("b54502") @description("Nation surrogate key"),
    `dn`.`R_NAME`                        AS `R_NAME`             @id("b54503") @description("Region name"),
    `dc`.`C_MKTSEGMENT`                  AS `C_MKTSEGMENT`       @id("b54504") @not_null @description("Market segment"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b54505") @isSystemCreateDate @description("When this combination was first seen")
FROM {{ ref('TARGET', 'DIM_CUSTOMER') }} `dc`
INNER JOIN {{ ref('TARGET', 'DIM_NATION_V') }} `dn` ON `dn`.`N_NATIONKEY` = `dc`.`N_NATIONKEY`
WHERE `dc`.`C_CUSTKEY` <> -1
