@id("04a671e7-153d-431d-ba5a-6f6a1d4d862c")
@nodeType("705")
SELECT DISTINCT
     N_NATIONKEY AS `N_NATIONKEY`,
     N_NAME AS `N_NAME`,
     N_REGIONKEY AS `N_REGIONKEY`,
     N_COMMENT AS `N_COMMENT`,
     TRUE AS `IS_DELETED`
FROM {{ ref('TARGET', 'WRK_nation') }} `WRK_nation`
LEFT JOIN {{ ref('SRC', 'nation') }} `nation`
     ON `WRK_nation`.`N_NATIONKEY` = `nation`.`N_NATIONKEY`
WHERE `nation`.`N_NATIONKEY` IS NULL