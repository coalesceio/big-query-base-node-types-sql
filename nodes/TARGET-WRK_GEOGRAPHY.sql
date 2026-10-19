@id("e889f228-a619-4e17-af90-1afc6f5eea4c")
@nodeType("SQLWork")
@description("Pipeline - staging: nation joined to region, latest nation row per key")
@writeMode("truncateInsert")
@tag("env", "dev")
SELECT
    `nation`.`N_NATIONKEY`   AS `NATION_KEY`           @primaryKey(1) @not_null @uniqueness,
    `nation`.`N_NAME`        AS `NATION_NAME`          @not_null @empty,
    `region`.`R_REGIONKEY`   AS `REGION_KEY`           @not_null,
    `region`.`R_NAME`        AS `REGION_NAME`          @not_null @empty,
    `nation`.`last_modified` AS `NATION_LAST_MODIFIED` @not_null
FROM {{ ref('SRC', 'nation') }} `nation`
INNER JOIN {{ ref('SRC', 'region') }} `region`
    ON `nation`.`N_REGIONKEY` = `region`.`R_REGIONKEY`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (PARTITION BY `nation`.`N_NATIONKEY` ORDER BY `nation`.`last_modified` DESC) = 1
