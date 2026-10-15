@id("37e8914c-a5c9-4f58-9d43-03e91804c3bd")
@nodeType("SQLDimension")
@materializationType("view")
@description("Dimension 5 - current nation rows from DIM_NATION joined to DIM_REGION, as a view")
@tag("env", "dev")
SELECT
    `n`.`DIM_NATION_KEY` AS `DIM_NATION_KEY` @id("37e801") @description("Nation surrogate key"),
    `n`.`N_NATIONKEY`    AS `N_NATIONKEY`    @id("37e802") @isBusinessKey @not_null @uniqueness @description("Nation key"),
    `n`.`N_NAME`         AS `N_NAME`         @id("37e803") @description("Nation name"),
    `r`.`DIM_REGION_KEY` AS `DIM_REGION_KEY` @id("37e804") @description("Region surrogate key"),
    `r`.`R_REGIONKEY`    AS `R_REGIONKEY`    @id("37e805") @description("Region key"),
    `r`.`R_NAME`         AS `R_NAME`         @id("37e806") @description("Region name")
FROM {{ ref('TARGET', 'DIM_NATION') }} `n`
LEFT JOIN {{ ref('TARGET', 'DIM_REGION') }} `r` ON `r`.`R_REGIONKEY` = `n`.`N_REGIONKEY`
WHERE `n`.`SYSTEM_CURRENT_FLAG` = 'Y'
