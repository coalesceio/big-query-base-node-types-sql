@id("1c42740c-9133-4555-810f-9966c7e4abbd")
@nodeType("SQLDimension")
@description("Pipeline - date dimension built from the event dates (GROUP BY); no @mergeStrategy, so changeTracking SCD Type 1; yearly partitions")
@partitionBy("DATE_TRUNC(DATE_KEY, YEAR)")
@preSQL("SELECT 'DIM_DATE pre-load' AS STEP")
@postSQL("SELECT 'DIM_DATE post-load' AS STEP")
SELECT
    CAST("0" AS STRING)                                         AS `DIM_DATE_KEY`        @id("b40001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `e`.`EVENT_DATE`                                            AS `DATE_KEY`            @id("b40002") @isBusinessKey @not_null @uniqueness,
    CAST(EXTRACT(YEAR FROM `e`.`EVENT_DATE`) AS INT64)          AS `CALENDAR_YEAR`       @id("b40003") @min_max("1990", "2100"),
    CAST(EXTRACT(QUARTER FROM `e`.`EVENT_DATE`) AS INT64)       AS `CALENDAR_QUARTER`    @id("b40004") @min_max("1", "4"),
    CAST(EXTRACT(MONTH FROM `e`.`EVENT_DATE`) AS INT64)         AS `CALENDAR_MONTH`      @id("b40005") @max_value("12"),
    CAST(FORMAT_DATE('%B', `e`.`EVENT_DATE`) AS STRING)         AS `MONTH_NAME`          @id("b40006") @empty,
    CAST(FORMAT_DATE('%A', `e`.`EVENT_DATE`) AS STRING)         AS `DAY_NAME`            @id("b40007"),
    CAST(EXTRACT(DAYOFWEEK FROM `e`.`EVENT_DATE`) IN (1, 7) AS BOOL) AS `IS_WEEKEND`     @id("b40008"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                        AS `SYSTEM_CREATE_DATE`  @id("b40009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                        AS `SYSTEM_UPDATE_DATE`  @id("b4000a") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_ORDER_EVENTS') }} `e`
GROUP BY `e`.`EVENT_DATE`
