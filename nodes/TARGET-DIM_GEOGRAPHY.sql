@id("62a8bcf8-d952-48ec-a1b2-8abef7e3784e")
@nodeType("SQLDimension")
@description("Pipeline - geography dimension: lastModified SCD Type 1 on the nation's last_modified, zero key record with -1 keys")
@mergeStrategy("lastModified")
@zeroKey("'0'", "'UNKNOWN'", "1900-01-01 00:00:00", true)
@tag("env", "dev")
SELECT
    CAST("0" AS STRING)                  AS `DIM_GEOGRAPHY_KEY`    @id("b10001") @isSurrogateKey @defaultValue("GENERATE_UUID()") @uniqueness,
    `g`.`NATION_KEY`                     AS `NATION_KEY`           @id("b10002") @isBusinessKey @zeroKey("-1") @not_null @uniqueness,
    `g`.`NATION_NAME`                    AS `NATION_NAME`          @id("b10003") @empty,
    `g`.`REGION_KEY`                     AS `REGION_KEY`           @id("b10004") @zeroKey("-1"),
    `g`.`REGION_NAME`                    AS `REGION_NAME`          @id("b10005"),
    `g`.`NATION_LAST_MODIFIED`           AS `NATION_LAST_MODIFIED` @id("b10006") @lastModifiedTracking(1),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE`   @id("b10007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE`   @id("b10008") @isSystemUpdateDate @freshness(1, "DAY")
FROM {{ ref('TARGET', 'WRK_GEOGRAPHY') }} `g`
