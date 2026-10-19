@id("0996a393-09ce-41ab-ae22-f7fbdc614f8d")
@nodeType("SQLDimension")
@description("Pipeline - order status dimension: upsert of the distinct statuses with a readable description")
@mergeStrategy("upsert")
@materializationType("table")
SELECT DISTINCT
    CAST("0" AS STRING)                          AS `DIM_ORDER_STATUS_KEY` @id("b30001") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `o`.`ORDER_STATUS`                           AS `ORDER_STATUS`         @id("b30002") @isBusinessKey @not_null @uniqueness,
    CAST(CASE `o`.`ORDER_STATUS`
        WHEN 'F' THEN 'Fulfilled'
        WHEN 'O' THEN 'Open'
        WHEN 'P' THEN 'Partially fulfilled'
        ELSE 'Unknown'
    END AS STRING)                               AS `ORDER_STATUS_DESC`    @id("b30003") @rejected_values("'Unknown'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)         AS `SYSTEM_CREATE_DATE`   @id("b30004") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)         AS `SYSTEM_UPDATE_DATE`   @id("b30005") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_ORDERS') }} `o`
