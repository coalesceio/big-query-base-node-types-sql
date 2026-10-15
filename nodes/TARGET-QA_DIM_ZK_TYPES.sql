@id("c93f857a-145a-4858-82ff-16bef082b5ad")
@nodeType("SQLDimension")
@materializationType("table")
@description("QA zero key - every scalar type with node-level defaults, plus column-level overrides; truncateInsert so the zero record is re-inserted after each truncate")
@writeMode("truncateInsert")
@zeroKey("-1", "'N/A'", "2000-01-01 00:00:00", "false")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} WHERE `ZK_KEY` = -1 HAVING COUNT(*) <> 1")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK_KEY` = -1 AND NOT (`n_NationKey` = -1 AND `Str_Col` = 'N/A' AND `Int_Col` = 0 AND `Num_Col` = 0 AND `BigNum_Col` = 0 AND `Float_Col` = 0 AND `Bool_Col` = FALSE)")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK_KEY` = -1 AND NOT (`Date_Col` = DATE '2000-01-01' AND `Datetime_Col` = DATETIME '2000-01-01 00:00:00' AND `Time_Col` = TIME '00:00:00' AND `Ts_Col` = TIMESTAMP '2000-01-01 00:00:00 UTC')")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK_KEY` = -1 AND NOT (`Json_Col` IS NOT NULL AND JSON_TYPE(`Json_Col`) = 'null')")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK_KEY` = -1 AND NOT (`Str_Ovr` = 'OVR' AND `Int_Ovr` = -5 AND `Num_Ovr` = -0.5 AND `Bool_Ovr` = TRUE AND `Date_Ovr` = DATE '1999-12-31' AND `Ts_Ovr` = TIMESTAMP '1999-12-31 23:59:59 UTC')")
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> 1 + (SELECT COUNT(*) FROM {{ ref('TARGET', 'QA_WRK_FEED') }})")
SELECT
    CAST(0 AS INT64)                                        AS `ZK_KEY`        @id("z1a000") @isSurrogateKey @defaultValue("0"),
    `F`.`n_NationKey`                                       AS `n_NationKey`   @id("z1a001") @isBusinessKey @zeroKey("-1"),
    CAST(`F`.`n_Name` AS STRING)                            AS `Str_Col`       @id("z1a002"),
    CAST(`F`.`n_RegionKey` AS INT64)                        AS `Int_Col`       @id("z1a003"),
    CAST(`F`.`n_NationKey` * 1.5 AS NUMERIC)                AS `Num_Col`       @id("z1a004"),
    CAST(`F`.`n_NationKey` * 2.5 AS BIGNUMERIC)             AS `BigNum_Col`    @id("z1a005"),
    CAST(`F`.`n_NationKey` / 3 AS FLOAT64)                  AS `Float_Col`     @id("z1a006"),
    CAST(`F`.`n_RegionKey` > 1 AS BOOL)                     AS `Bool_Col`      @id("z1a007"),
    CAST(DATE(`F`.`last_Modified`) AS DATE)                 AS `Date_Col`      @id("z1a008"),
    CAST(DATETIME(`F`.`last_Modified`) AS DATETIME)         AS `Datetime_Col`  @id("z1a009"),
    CAST(TIME(`F`.`last_Modified`) AS TIME)                 AS `Time_Col`      @id("z1a00a"),
    CAST(`F`.`last_Modified` AS TIMESTAMP)                  AS `Ts_Col`        @id("z1a00b"),
    CAST(PARSE_JSON(CONCAT('{"k":', CAST(`F`.`n_NationKey` AS STRING), '}')) AS JSON) AS `Json_Col` @id("z1a00c"),
    CAST(`F`.`n_Comment` AS STRING)                         AS `Str_Ovr`       @id("z1a00d") @zeroKey("'OVR'"),
    CAST(`F`.`n_NationKey` AS INT64)                        AS `Int_Ovr`       @id("z1a00e") @zeroKey("-5"),
    CAST(`F`.`n_NationKey` / 7 AS NUMERIC)                  AS `Num_Ovr`       @id("z1a00f") @zeroKey("NUMERIC '-0.5'"),
    CAST(`F`.`n_RegionKey` = 0 AS BOOL)                     AS `Bool_Ovr`      @id("z1a010") @zeroKey("true"),
    CAST(DATE(`F`.`last_Modified`) AS DATE)                 AS `Date_Ovr`      @id("z1a011") @zeroKey("DATE '1999-12-31'"),
    CAST(`F`.`last_Modified` AS TIMESTAMP)                  AS `Ts_Ovr`        @id("z1a012") @zeroKey("TIMESTAMP '1999-12-31 23:59:59'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                    AS `SYSTEM_CREATE_DATE` @id("z1a01e") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                    AS `SYSTEM_UPDATE_DATE` @id("z1a01f") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_WRK_FEED') }} `F`
