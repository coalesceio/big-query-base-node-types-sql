@id("b9730505-2afe-4f81-bc23-a9fb39b0df94")
@nodeType("SQLFact")
@materializationType("table")
@description("QA partition - node-level plain DATE column name: Event_Date; changeTracking SCD1")
@partitionBy("Event_Date")
SELECT
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("e3a001") @isBusinessKey,
    CAST(DATE(`F`.`last_Modified`) AS DATE)  AS `Event_Date`          @id("e3a002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("e3a008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("e3a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
