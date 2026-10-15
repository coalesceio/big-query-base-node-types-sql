@id("47db1fab-ba18-4526-960a-3ad8614b6ec6")
@nodeType("SQLDimension")
@materializationType("table")
@description("Dimension 4 - ship mode / instruction combinations from WRK_LINEITEM: upsert merge with truncateInsert, CTE de-duplication")
@mergeStrategy("upsert")
@writeMode("truncateInsert")
@postSQL("DELETE FROM {{ this }} WHERE `SHIP_MODE` IS NULL")
WITH SHIP_MODES AS (
    SELECT
        `l`.`L_SHIPMODE`,
        `l`.`L_SHIPINSTRUCT`,
        COUNT(*)            AS `LINE_COUNT`,
        MIN(`l`.`L_SHIPDATE`) AS `FIRST_SHIP_DATE`,
        MAX(`l`.`L_SHIPDATE`) AS `LAST_SHIP_DATE`
    FROM {{ ref('TARGET', 'WRK_LINEITEM') }} `l`
    GROUP BY `l`.`L_SHIPMODE`, `l`.`L_SHIPINSTRUCT`
)
SELECT
    CAST(`sm`.`L_SHIPMODE` || '|' || `sm`.`L_SHIPINSTRUCT` AS STRING) AS `SHIP_MODE_ID`     @id("47db01") @isBusinessKey @notNull @primaryKey(1) @not_null @uniqueness @description("Business key: ship mode | ship instruction"),
    `sm`.`L_SHIPMODE`                               AS `SHIP_MODE`          @id("47db02") @clusterKey(1) @not_null @description("Ship mode"),
    `sm`.`L_SHIPINSTRUCT`                           AS `SHIP_INSTRUCT`      @id("47db03") @not_null @description("Ship instruction"),
    CAST(CASE WHEN `sm`.`L_SHIPMODE` IN ('AIR', 'REG AIR') THEN 'AIR'
         WHEN `sm`.`L_SHIPMODE` IN ('RAIL', 'TRUCK') THEN 'GROUND'
         ELSE 'OTHER' END  AS STRING)                         AS `SHIP_MODE_GROUP`    @id("47db04") @accepted_values("'AIR', 'GROUND', 'OTHER'") @description("Ship mode grouping"),
    `sm`.`LINE_COUNT`                               AS `LINE_COUNT`         @id("47db05") @min_value("1") @description("Number of lineitems"),
    `sm`.`FIRST_SHIP_DATE`                          AS `FIRST_SHIP_DATE`    @id("47db06") @relative_time("<=", "LAST_SHIP_DATE") @description("First ship date"),
    `sm`.`LAST_SHIP_DATE`                           AS `LAST_SHIP_DATE`     @id("47db07") @description("Last ship date"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)            AS `SYSTEM_CREATE_DATE` @id("47db08") @isSystemCreateDate @description("Row create time"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)            AS `SYSTEM_UPDATE_DATE` @id("47db09") @isSystemUpdateDate @description("Row update time")
FROM SHIP_MODES `sm`
