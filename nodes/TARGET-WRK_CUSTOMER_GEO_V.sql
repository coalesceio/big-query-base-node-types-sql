@id("84648714-0057-4b46-9cc7-30ca0cc185b0")
@nodeType("SQLWork")
@materializationType("view")
@description("Work 6 - view joining the customer, nation and region Work nodes into one customer geography row")
@tag("env", "dev")
@tests("SELECT 1 FROM {{ this }} GROUP BY `C_CUSTKEY` HAVING COUNT(*) > 1", false)
WITH CUSTOMER_LATEST AS (
    SELECT
        `c`.*,
        ROW_NUMBER() OVER (PARTITION BY `c`.`C_CUSTKEY` ORDER BY `c`.`LOAD_TS` DESC) AS `RN`
    FROM {{ ref('TARGET', 'WRK_CUSTOMER') }} `c`
)
SELECT
    `c`.`C_CUSTKEY`    AS `C_CUSTKEY`    @id("846401") @not_null @uniqueness @description("Customer key"),
    `c`.`C_NAME`       AS `C_NAME`       @id("846402") @description("Customer name"),
    `c`.`C_MKTSEGMENT` AS `C_MKTSEGMENT` @id("846403") @description("Market segment"),
    `c`.`C_ACCTBAL`    AS `C_ACCTBAL`    @id("846404") @description("Account balance"),
    `n`.`N_NATIONKEY`  AS `N_NATIONKEY`  @id("846405") @description("Nation key"),
    `n`.`N_NAME`       AS `N_NAME`       @id("846406") @not_null @description("Nation name"),
    `r`.`R_REGIONKEY`  AS `R_REGIONKEY`  @id("846407") @description("Region key"),
    `r`.`R_NAME`       AS `R_NAME`       @id("846408") @not_null @description("Region name"),
    `c`.`HK_CUSTOMER`  AS `HK_CUSTOMER`  @id("846409") @description("Customer hash key"),
    `c`.`HD_CUSTOMER`  AS `HD_CUSTOMER`  @id("84640a") @description("Customer hash diff")
FROM CUSTOMER_LATEST `c`
INNER JOIN {{ ref('TARGET', 'WRK_NATION') }} `n` ON `n`.`N_NATIONKEY` = `c`.`C_NATIONKEY`
INNER JOIN {{ ref('TARGET', 'WRK_REGION') }} `r` ON `r`.`R_REGIONKEY` = `n`.`N_REGIONKEY`
WHERE `c`.`RN` = 1
