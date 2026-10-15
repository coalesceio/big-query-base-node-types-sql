@id("96bce677-feac-4d13-9000-ec234435d3c5")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA Dimension - changeTracking SCD2 (n_Name, n_RegionKey tracked), all system columns, column-level TIMESTAMP partition + partition expiration")
@mergeStrategy("changeTracking")
@partitionExpirationDays("365")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `n_NationKey` HAVING COUNT(*) > 1")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
@tests("SELECT 1 FROM {{ this }} WHERE (`SYSTEM_CURRENT_FLAG` = 'Y') <> (`SYSTEM_END_DATE` = TIMESTAMP_SECONDS(32503593600))")
SELECT
    CAST('0' AS STRING)                      AS `QA_DIM_CT_SCD2_KEY`  @id("d2a000") @isSurrogateKey @defaultValue("GENERATE_UUID()") @uniqueness,
    `F`.`n_NationKey`                        AS `n_NationKey`         @id("d2a001") @isBusinessKey @not_null,
    `F`.`n_Name`                             AS `n_Name`              @id("d2a002") @isChangeTracking,
    `F`.`n_RegionKey`                        AS `n_RegionKey`         @id("d2a003") @isChangeTracking,
    `F`.`n_Comment`                          AS `n_Comment`           @id("d2a004"),
    1                                        AS `SYSTEM_VERSION`      @id("d2a005") @isSystemVersion @min_value("1"),
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("d2a006") @isSystemCurrentFlag @accepted_values("'Y', 'N'"),
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("d2a007") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d2a008") @isSystemCreateDate @partitionBy,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d2a009") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
