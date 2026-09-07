@id("9f5f04b7-4ad2-46d2-9a3b-ac593a3091f5")
@nodeType("705")
@writeMode("truncateInsert")
SELECT
     `R_REGIONKEY` AS `R_REGIONKEY` @not_null @uniqueness,
     `R_NAME` AS `R_NAME` @empty,
     `R_COMMENT` AS `R_COMMENT`
FROM {{ ref('TARGET', 'vw_region_v1_rename') }} `vw_region_v1_rename`