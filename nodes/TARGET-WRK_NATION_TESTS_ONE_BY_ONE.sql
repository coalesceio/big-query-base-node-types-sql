@id("42692b52-8d76-4fe6-b2a4-06161e559261")
@nodeType("705")
@disableTests

@writeMode("append  ")

-- preSQL/postSQL with backtick-quoted identifiers inside the double-quoted string
@preSQL("DELETE FROM {{ this }} WHERE `N_REGIONKEY` IS NULL")
@postSQL("INSERT INTO {{ ref('AUDIT', 'LOAD_LOG') }} (`TABLE_NAME`, `LOAD_TS`) VALUES ('WRK_NATION_TESTS_ONE_BY_ONE', CURRENT_TIMESTAMP())")

-- Node-level tests, run one by one in the order they appear

-- Test A: table must not be empty after the load
@tests("SELECT 1 FROM (SELECT COUNT(*) AS ROW_COUNT FROM {{ this }}) WHERE ROW_COUNT = 0", true, "After")

-- Test B: no duplicate nation rows for the same (name, region) combination
@tests("SELECT 1 FROM {{ this }} GROUP BY N_NAME HAVING COUNT(*) > 1", true, "After")

-- Test C: no rows loaded with a future-dated last_modified timestamp
@tests("SELECT 1 FROM {{ this }} WHERE TEST_FRESHNESS_DAY > CURRENT_TIMESTAMP()", true, "After")

-- Test D: same as Test B, but with backtick-quoted identifiers inside the double-quoted querySQL string
@tests("SELECT 1 FROM {{ this }} GROUP BY `N_NAME` HAVING COUNT(*) > 1", true, "After")
SELECT
     -- Test 1: @not_null (type-agnostic, one example is sufficient)
     `N_NATIONKEY` AS `TEST_NOT_NULL` @description("Nation key, used for the not_null test") @defaultValue("0") @notNull @not_null,

     -- Test 2: @uniqueness (type-agnostic, one example is sufficient)
     `N_NATIONKEY` AS `TEST_UNIQUENESS` @description("Nation key, used for the uniqueness test") @defaultValue("0") @notNull @uniqueness,

     -- Test 3: @empty (only meaningful on string columns)
     `N_COMMENT` AS `TEST_EMPTY` @description("Nation comment, used for the empty test") @defaultValue("'NA'") @notNull @empty,

     -- Test 4: @accepted_values on a numeric (INT64) column
     `N_REGIONKEY` AS `TEST_ACCEPTED_VALUES_INT` @description("Region key, used for the INT64 accepted_values test") @defaultValue("0") @notNull @accepted_values("0") @accepted_values("1") @accepted_values("2") @accepted_values("3") @accepted_values("4"),

     -- Test 4b: @accepted_values on a FLOAT64 column
     CAST(`N_REGIONKEY` AS FLOAT64) AS `TEST_ACCEPTED_VALUES_FLOAT` @description("Region key cast to FLOAT64, used for the FLOAT64 accepted_values test") @defaultValue("0.0") @notNull @accepted_values("0.0") @accepted_values("1.0") @accepted_values("2.0") @accepted_values("3.0") @accepted_values("4.0"),

     -- Test 4c: @accepted_values on a string column
     `N_NAME` AS `TEST_ACCEPTED_VALUES_STRING` @description("Nation name, used for the STRING accepted_values test") @defaultValue("'UNKNOWN'") @notNull @accepted_values("'ALGERIA'") @accepted_values("'ARGENTINA'") @accepted_values("'BRAZIL'") @accepted_values("'CANADA'"),

     -- Test 5: @rejected_values on a numeric (INT64) column
     `N_REGIONKEY` AS `TEST_REJECTED_VALUES_INT` @description("Region key, used for the INT64 rejected_values test") @defaultValue("0") @notNull @rejected_values("-1"),

     -- Test 5b: @rejected_values on a FLOAT64 column
     CAST(`N_REGIONKEY` AS FLOAT64) AS `TEST_REJECTED_VALUES_FLOAT` @description("Region key cast to FLOAT64, used for the FLOAT64 rejected_values test") @defaultValue("0.0") @notNull @rejected_values("-1.0"),

     -- Test 5c: @rejected_values on a string column
     `N_NAME` AS `TEST_REJECTED_VALUES_STRING` @description("Nation name, used for the STRING rejected_values test") @defaultValue("'UNKNOWN'") @notNull @rejected_values("'NA'"),

     -- Test 6: @min_max on a numeric (INT64) column
     `N_REGIONKEY` AS `TEST_MIN_MAX_INT` @description("Region key, used for the INT64 min_max test") @defaultValue("0") @notNull @min_max("0", "4"),

     -- Test 6b: @min_max on a FLOAT64 column
     CAST(`N_REGIONKEY` AS FLOAT64) AS `TEST_MIN_MAX_FLOAT` @description("Region key cast to FLOAT64, used for the FLOAT64 min_max test") @defaultValue("0.0") @notNull @min_max("0.0", "4.0"),

     -- Test 6c: @min_max on a DATE column
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_MIN_MAX_DATE` @description("Last modified cast to DATE, used for the DATE min_max test") @defaultValue("DATE '1970-01-01'") @notNull @min_max("DATE '2000-01-01'", "DATE '2100-01-01'"),

     -- Test 7: @min_value on a numeric (INT64) column
     `N_REGIONKEY` AS `TEST_MIN_VALUE_INT` @description("Region key, used for the INT64 min_value test") @defaultValue("0") @notNull @min_value("0"),

     -- Test 7b: @min_value on a FLOAT64 column
     CAST(`N_REGIONKEY` AS FLOAT64) AS `TEST_MIN_VALUE_FLOAT` @description("Region key cast to FLOAT64, used for the FLOAT64 min_value test") @defaultValue("0.0") @notNull @min_value("0.0"),

     -- Test 7c: @min_value on a DATE column
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_MIN_VALUE_DATE` @description("Last modified cast to DATE, used for the DATE min_value test") @defaultValue("DATE '1970-01-01'") @notNull @min_value("DATE '2000-01-01'"),

     -- Test 8: @max_value on a numeric (INT64) column
     `N_REGIONKEY` AS `TEST_MAX_VALUE_INT` @description("Region key, used for the INT64 max_value test") @defaultValue("0") @notNull @max_value("4"),

     -- Test 8b: @max_value on a FLOAT64 column
     CAST(`N_REGIONKEY` AS FLOAT64) AS `TEST_MAX_VALUE_FLOAT` @description("Region key cast to FLOAT64, used for the FLOAT64 max_value test") @defaultValue("0.0") @notNull @max_value("4.0"),

     -- Test 8c: @max_value on a DATE column
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_MAX_VALUE_DATE` @description("Last modified cast to DATE, used for the DATE max_value test") @defaultValue("DATE '1970-01-01'") @notNull @max_value("DATE '2100-01-01'"),

     -- Test 9: @freshness on a TIMESTAMP column, one column per supported unit
     `last_modified` AS `TEST_FRESHNESS_SECOND` @description("Last modified timestamp, freshness test with unit SECOND") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @freshness(999999999, "SECOND"),
     `last_modified` AS `TEST_FRESHNESS_MINUTE` @description("Last modified timestamp, freshness test with unit MINUTE") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @freshness(999999, "MINUTE"),
     `last_modified` AS `TEST_FRESHNESS_HOUR` @description("Last modified timestamp, freshness test with unit HOUR") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @freshness(87600, "HOUR"),
     `last_modified` AS `TEST_FRESHNESS_DAY` @description("Last modified timestamp, freshness test with unit DAY") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @freshness(3650, "DAY"),
     `last_modified` AS `TEST_FRESHNESS_WEEK` @description("Last modified timestamp, freshness test with unit WEEK") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @freshness(520, "WEEK"),
     `last_modified` AS `TEST_FRESHNESS_MONTH` @description("Last modified timestamp, freshness test with unit MONTH") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @freshness(120, "MONTH"),
     `last_modified` AS `TEST_FRESHNESS_YEAR` @description("Last modified timestamp, freshness test with unit YEAR") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @freshness(10, "YEAR"),

     -- Test 9b: @freshness on a DATE column, one column per supported unit
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_FRESHNESS_DATE_SECOND` @description("Last modified date, freshness test with unit SECOND") @defaultValue("DATE '1970-01-01'") @notNull @freshness(999999999, "SECOND"),
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_FRESHNESS_DATE_MINUTE` @description("Last modified date, freshness test with unit MINUTE") @defaultValue("DATE '1970-01-01'") @notNull @freshness(999999, "MINUTE"),
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_FRESHNESS_DATE_HOUR` @description("Last modified date, freshness test with unit HOUR") @defaultValue("DATE '1970-01-01'") @notNull @freshness(87600, "HOUR"),
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_FRESHNESS_DATE_DAY` @description("Last modified date, freshness test with unit DAY") @defaultValue("DATE '1970-01-01'") @notNull @freshness(3650, "DAY"),
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_FRESHNESS_DATE_WEEK` @description("Last modified date, freshness test with unit WEEK") @defaultValue("DATE '1970-01-01'") @notNull @freshness(520, "WEEK"),
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_FRESHNESS_DATE_MONTH` @description("Last modified date, freshness test with unit MONTH") @defaultValue("DATE '1970-01-01'") @notNull @freshness(120, "MONTH"),
     CAST(DATE(`last_modified`) AS DATE) AS `TEST_FRESHNESS_DATE_YEAR` @description("Last modified date, freshness test with unit YEAR") @defaultValue("DATE '1970-01-01'") @notNull @freshness(10, "YEAR"),

     -- Test 10: @relative_time, one column per supported operator, all compared against TEST_RELATIVE_TIME_OTHER
     `last_modified` AS `TEST_RELATIVE_TIME_LT` @description("Last modified timestamp, relative_time test with operator <") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @relative_time("<", "TEST_RELATIVE_TIME_OTHER"),
     `last_modified` AS `TEST_RELATIVE_TIME_LE` @description("Last modified timestamp, relative_time test with operator <=") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @relative_time("<=", "TEST_RELATIVE_TIME_OTHER"),
     `last_modified` AS `TEST_RELATIVE_TIME_GT` @description("Last modified timestamp, relative_time test with operator >") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @relative_time(">", "TEST_RELATIVE_TIME_OTHER"),
     `last_modified` AS `TEST_RELATIVE_TIME_GE` @description("Last modified timestamp, relative_time test with operator >=") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @relative_time(">=", "TEST_RELATIVE_TIME_OTHER"),
     `last_modified` AS `TEST_RELATIVE_TIME_EQ` @description("Last modified timestamp, relative_time test with operator =") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @relative_time("=", "TEST_RELATIVE_TIME_OTHER"),
     `last_modified` AS `TEST_RELATIVE_TIME_NE` @description("Last modified timestamp, relative_time test with operator <>") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull @relative_time("<>", "TEST_RELATIVE_TIME_OTHER"),
     `last_modified` AS `TEST_RELATIVE_TIME_OTHER` @description("Comparison timestamp for the relative_time tests") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull,

     `N_NAME` AS `N_NAME` @description("Nation name") @defaultValue("'UNKNOWN'") @notNull,

     -- Additional datatype coverage, derived from the same source columns
     CAST(`N_NATIONKEY` AS FLOAT64) AS `TEST_FLOAT` @description("Nation key cast to FLOAT64, for float type coverage") @defaultValue("0.0") @notNull,

     CAST(DATE(`last_modified`) AS DATE) AS `TEST_DATE` @description("Last modified cast to DATE, for date type coverage") @defaultValue("DATE '1970-01-01'") @notNull,

     CAST(`last_modified` AS DATETIME) AS `TEST_DATETIME` @description("Last modified cast to DATETIME, for datetime type coverage") @defaultValue("DATETIME '1970-01-01 00:00:00'") @notNull,

     CAST(`last_modified` AS TIMESTAMP) AS `TEST_TIMESTAMP` @description("Last modified cast to TIMESTAMP, for timestamp type coverage") @defaultValue("TIMESTAMP '1970-01-01 00:00:00'") @notNull,

     CAST(TIME(`last_modified`) AS TIME) AS `TEST_TIME` @description("Last modified cast to TIME, for time type coverage") @defaultValue("TIME '00:00:00'") @notNull,

     (`N_REGIONKEY` = 0) AS `TEST_BOOL` @description("Whether the region key is 0, for boolean type coverage") @defaultValue("FALSE") @notNull,

     CAST(`N_NATIONKEY` AS NUMERIC) AS `TEST_NUMERIC` @description("Nation key cast to NUMERIC, for numeric type coverage") @defaultValue("0") @notNull,

     CAST(`N_NATIONKEY` AS BIGNUMERIC) AS `TEST_BIGNUMERIC` @description("Nation key cast to BIGNUMERIC, for big-numeric type coverage") @defaultValue("0") @notNull,

     CAST(`N_NAME` AS BYTES) AS `TEST_BYTES` @description("Nation name cast to BYTES, for bytes type coverage") @defaultValue("B''") @notNull
FROM {{ ref('SRC', 'nation') }} `nation`
where N_REGIONKEY is not null
