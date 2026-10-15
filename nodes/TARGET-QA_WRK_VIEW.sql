@id("19d5596a-0763-4739-b64e-8f6a601e3e73")
@nodeType("SQLWork")
@materializationType("view")
@description("QA Work view - tag, fixed expiration, column and node tests")
@tableExpiration("2027-06-30")
@tag("env", "dev")
@tests("SELECT 1 FROM {{ this }} HAVING COUNT(*) = 0")
SELECT
    `F`.`N_NATIONKEY`                        AS `N_NATIONKEY`    @uniqueness @description("Nation key"),
    UPPER(`F`.`N_NAME`)                      AS `N_NAME_UPPER`   @not_null @empty,
    `F`.`N_REGIONKEY`                        AS `N_REGIONKEY`,
    CASE WHEN `F`.`N_REGIONKEY` = -1 THEN 'UNKNOWN' ELSE 'KNOWN' END AS `REGION_STATUS` @accepted_values("'KNOWN', 'UNKNOWN'")
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
