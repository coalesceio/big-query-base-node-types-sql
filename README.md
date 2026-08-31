## SQL Work

The SQL Work node is a transformation tool within Coalesce that lets developers write custom, hand-coded SQL instead of using the standard graphical column-mapping interface. It is ideal for complex transformations, advanced window functions, or multi-step logic that is difficult to represent with the standard UI, and ships with a built-in library of column- and node-level data quality tests. While it provides maximum flexibility, it shifts the responsibility of column definition and logic maintenance to the SQL author.

### SQL Work Node Configuration

The SQL Work Node type has three configuration groups:

* [General](#sql-work-general-options)
* [Node Annotations](#sql-work-node-annotations)
* [Column Annotations](#sql-work-column-annotations)

#### SQL Work General Options

| **Property** | **Description** |
|----------|-------------|
| **Storage Location** | Storage Location where the SQL Work table or view will be created |

### SQL Work Node Annotations

| **Property** | **Description** |
|---------|-------------|
| `@id(id)` ***(reserved)*** | Unique identifier for the node.<br/>Static and auto-generated when the node is created — not meant to be edited. |
| `@nodeType(type)` ***(reserved)*** | Identifies the node's type.<br/>Set automatically based on the node type chosen when the node is created. |
| `@description(text)` ***(reserved)*** | Node-level description.<br/>Can be edited via this annotation or in the node description field below the node name in the UI. |
| `@materializationType(type)` ***(reserved)*** | Table/View.<br/>*Not specified in the SQL editor → defaults to **Table**.* |
| `@writeMode("truncateInsert \| append")` | Controls how data is written to the target table.<br/>**truncateInsert** — clears the table before loading, replacing its contents entirely.<br/>**append** — inserts the new rows alongside whatever is already there.<br/>*Not specified in the SQL editor → defaults to **truncateInsert**.*<br/>**Note:** Ignored on Views. |
| `@disableTests`**²** | Controls whether configured tests are skipped.<br/>*Specified in the SQL editor → all node- and column-level tests are skipped.*<br/>*Not specified in the SQL editor → tests run normally.*<br/>To turn tests back on, remove the annotation. Useful while developing a node — iterate on the SQL first, then re-enable once the logic is settled. |
| `@tests(querySQL, continueOnFailure?, runOrder?)` | ***(repeatable)*** Node-level data quality test.<br/>Runs `querySQL` against the target; fails if it returns any records.<br/>Skipped entirely when **@disableTests** is set. |
| `@columnRunOrder("Before \| After")` | Determines when column-level tests run (unique, not_null, empty, accepted_values, etc.).<br/>**Before** — checks existing/source data before it lands in the target.<br/>**After** — validates the freshly written rows.<br/>*Not specified in the SQL editor → defaults to **After**.*<br/>Applies node-wide to every column test on this node. |
| `@columnContinueOnFailure(isEnabled)` | Determines whether the run continues after a column test fails.<br/>**true** — remaining stages still run.<br/> **false** — the run halts right there.<br/>*Not specified in the SQL editor → defaults to **true**.*<br/>Applies node-wide to every column test on this node.<br/>**Note:** Use `@columnContinueOnFailure(false)` to stop the flow on the first failing test. |
| `@preSQL(querySQL)` | ***(repeatable)*** SQL statement to execute `before` the data load operation.<br/>Repeat the annotation to run multiple statements, in the order they appear.<br/>**Note:** Ignored on Views. |
| `@postSQL(querySQL)` | ***(repeatable)*** SQL statement to execute `after` the data load operation.<br/>Repeat the annotation to run multiple statements, in the order they appear.<br/>**Note:** Ignored on Views. |

### SQL Work Column Annotations

| **Property** | **Description** |
|---------|-------------|
| `@notNull` ***(reserved)*** | Marks column as NOT NULL.<br/>**Note:** Ignored on Views. |
| `@description(<descText>)` ***(reserved)*** | Adds column description. |
| `@defaultValue(<value>)` ***(reserved)*** | Adds default value.<br/>Quote to match the column's data type - <br/>number: `defaultValue("<num>")`<br/>string: `defaultValue("'<string>'")`<br/>**Note:** Ignored on Views. |
| `@inHash(<hashName>, <hashOrder>)`**³** | ***(repeatable)*** Marks a column as an input to a generated hash key.<br/>**hashName** — columns sharing the same value are grouped together into the same hash.<br/>**hashOrder** — this column's position within that group.<br/>Call `get_hash("<hashName>")` elsewhere in the SELECT to produce the hash column from the marked columns. |

🚦**Column-level data quality tests** — applicable only when `@disableTests` is not set. Each runs Before or After the load per `@columnRunOrder`, and either halts or continues the run on failure per `@columnContinueOnFailure`. *Not specified in the SQL editor → test is off.*

| **Property** | **Description** |
|---------|-------------|
| `@not_null` | Fails on rows where the column is NULL.|
| `@unique` | Fails when a value appears on more than one row. |
| `@empty` | Fails on rows where the column trims to the empty string.<br/>NULL values pass this test — they're caught by `@not_null` instead. |
| `@accepted_values("<value>")` | ***(repeatable)*** Fails on rows whose value is outside the allow list.<br/>Repeat once per permitted value.<br/>Quote to match the column's data type — <br/>number: `accepted_values("<num>")`<br/>string: `accepted_values("'<string>'")`. |
| `@rejected_values("<value>")` | ***(repeatable)*** Fails on rows whose value is in the deny list.<br/>Repeat once per forbidden value.<br/>Same quoting rules as `accepted_values`. |
| `@min_max("<min>", "<max>")` | Fails on rows outside the inclusive range.<br/>Bounds are pasted into the SQL verbatim — number: `"0"`, date: `"DATE '2026-01-01'"`. |
| `@min_value("<min>")` | Fails on rows below the bound.<br/>Value formatting — see `min_max`. |
| `@max_value("<max>")` | Fails on rows above the bound.<br/>Value formatting — see `min_max`. |
| `@freshness(<interval>, "<unit>")` | Fails when the newest value in the column is older than the given interval, or the table is empty.<br/>**interval** — how far back from now the newest value is allowed to be, expressed in the unit given by **unit**.<br/>**unit** — SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, or YEAR (defaults to DAY).<br/>**Note:** on a DATE column the value is truncated to midnight. |
| `@relative_time("<operator>", "<other_column>")` | Compares this column against another date/time column on the same node.<br/>e.g. `@relative_time("<=", "END_DATE")` fails rows where this column's value is not `<=` END_DATE.<br/>Either side NULL → row is skipped (passes). |
| `@business_rule("<expression>", "<label>")` **¹** | ***(repeatable)*** Runs a custom SQL boolean expression against every row.<br/>**expression** - is pasted verbatim into a `WHERE NOT (...)` clause against the target table.<br/>**label** is optional — names the test stage, defaults to `business_rule`. |
| `@business_query("<query>", "<label>")` **¹** | ***(repeatable)*** Runs a complete SQL query, pasted into the SQL verbatim.<br/>**query** - SQL query written to select only the rows that fail the check.<br/>**label** is optional — names the test stage, defaults to `business_query`. |
| `@relationship("<location>", "<node>", "<column>")` | ***(repeatable)*** Referential integrity check.<br/>Fails on rows whose non-NULL value has no match in the parent column, e.g. `@relationship("SRC", "CUSTOMER", "C_CUSTKEY")`.<br/>**location** — parent's Storage Location.<br/>**node** — parent table name.<br/>**column** — matching column in the parent node. |

---

### Notes

- Verify that all **column datatypes** are successfully resolved before creating the object. Columns with an `UNKNOWN` datatype may cause stage generation or runtime failures.

- It is recommended to use **DISTINCT**, **UNION** and **UNION ALL** within a CTE rather than directly in the final **SELECT** query.

- **¹** `business_rule` and `business_query` are attached to a column syntactically, but the column they're attached to is only used to label the test stage (e.g. "N_NATIONKEY: business_rule") — the check itself runs whatever expression or query you write, which can reference any column(s) on the target table. Unlike `not_null`/`unique`/`min_max`/etc., these two are effectively freeform node-level checks declared via a column annotation, not true single-column tests.

- **²** Node level tests are performed only when `disableTests` is OFF
    ```text
    @tests("<querySQL>", "<runOrder>", <continueOnFailure>)
    ```
    | Parameter | Description |
    |-----------|-------------|
    | querySQL | SQL statement to execute as a validation test. The test fails if the query returns any records. |
    | runOrder |**(optional)** `Before` or `After`. Determines whether the test is executed before or after the load operation. |
    | continueOnFailure |**(optional)** `true` or `false`. Determines whether execution continues when the test fails. |
    
    **Examples**
    
    ```text
    @tests("SELECT 1 FROM {{ this }} GROUP BY N_COMMENT HAVING COUNT(*) > 1", "Before", true)
    
    @tests("SELECT 1 FROM {{ this }} GROUP BY N_COMMENT HAVING COUNT(*) > 1", "After", true)
    ```

- **³** The hash transformation uses the reusable `get_hash()` macro:

    ```SQL
    {{ get_hash(<hash_name>, <algo>, <delimiter>) }}
    ```

    | Parameter | Description |
    |-----------|-------------|
    | `hash_name` | Hash name used across columns to identify the columns included in the hash. |
    | `algo` | **(optional)** Hashing algorithm to use. Supported values include `SHA1` and `SHA256`. Defaults to `SHA1`. |
    | `delimiter` | **(optional)** Delimiter used to separate column values when generating the hash. Defaults to `\|\|` and can be customized. |

    #### Examples:
    
    Using hash macro(default-SHA1)
    ```sql
    <col_name> AS <col_name> @inHash("GH_COL",1),
    {{ get_hash('GH_COL') }}::STRING AS "GH_COL"
    ```
    Using hash macro(MD5)
    ```sql
    <col_name> AS <col_name> @inHash("GH_COL",1),
    {{ get_hash('GH_COL', 'MD5') }}::STRING AS "GH_COL"<SHA256
    ```
    Using hash macro(SHA256)
    ```sql
    <col_name> AS <col_name> @inHash("GH_COL",1),
    {{ get_hash('GH_COL', 'SHA256') }}::STRING AS "GH_COL"
    ```
    Using hash macro(algo=SHA256, delimeter='~' )
    ```sql
    <col_name> AS <col_name> @inHash("GH_COL",1),
    {{ get_hash('GH_COL', algo='SHA256', delimiter='~') }}::STRING AS "GH_COL"
    ```
    Using multiple keys hash macro
    ```sql
    <col_name1> AS <col_name1> @inHash("GH_COL", 1),
    <col_name2> AS <col_name2> @inHash("GH_COL", 2),
    {{ get_hash('GH_COL') }}::STRING AS "GH_COL_COMBINED"
    ```
    Using multiple hash macros
    ```sql
    <col_name1> AS <col_name1> @inHash("GH_COL1",1 , "GH_COL2",2),
    <col_name2> AS <col_name2> @inHash("GH_COL1",2),
    <col_name3> AS <col_name3> @inHash("GH_COL2",1),
    {{ get_hash('GH_COL1') }}::STRING AS "GH_COL_COMBINED1",
    {{ get_hash('GH_COL2', delimiter='~') }}::STRING AS "GH_COL_COMBINED2"
    ```
    Using explicit expression:
    ```sql
    CAST(
      SHA1(
        NVL(CAST(<col_name> AS VARCHAR), 'null')
      ) AS STRING
    )::STRING AS "GH_Key"
    ```
---

### Known Limitations

Users should be aware of the following technical constraints when using SQL:

* **Parsable SQL Only**:
 The node only supports SQL that can be fully parsed by the platform’s engine. Non-standard SQL or vendor-specific "semantic views" that bypass standard parsing will not work.

* **SELECT Statements Only**:  
This node only supports data retrieval and transformation logic. DML or DDL commands such as `CREATE`, `MERGE`, `DELETE`, `UPDATE`, or `TRUNCATE` are not supported and will cause execution failures.

* **Support for `DISTINCT`, `UNION`, and `UNION ALL`**:  
`DISTINCT`, `UNION`, and `UNION ALL` are fully supported when used within **Common Table Expressions (CTEs)**. While these keywords can also be used in standard `SELECT` statements without generating an error, they may not parsed correctly by the platform. As a result, subsequent clauses (such as `JOIN`s) may be interpreted as part of a standard join structure, causing the generated SQL to differ from the intended query and potentially leading to inconsistent data loads. To ensure the SQL is parsed and executed as expected, always implement these operations inside a CTE.

* **Other Keywords**:  
GROUP BY, ORDER BY and HAVING clauses can be included as part of the join query and will be parsed and processed accordingly.

---

### Usage Examples 

The following patterns represent common ways to use the SQL Node.<br/>

**Sample node with Annotations**
```sql
SELECT
     "N_NATIONKEY" AS "N_NATIONKEY" @notNull  @inHash("GH_COL",1),
     "N_NAME" AS "N_NAME" @defaultValue("NA"),
     "N_REGIONKEY" AS "N_REGIONKEY" @description("region key"),
     "N_COMMENT" AS "N_COMMENT" @inHash("GH_COL",2),
     "N_LOAD_TIMESTAMP" AS "N_LOAD_TIMESTAMP" @tests("null", "unique"),
     {{ get_hash('GH_COL') }}::STRING AS "GH_COL"
FROM {{ ref('SOURCE_DATA', 'NATION') }} "NATION"
```
**Basic Transformation & Cleaning** - Standard pattern for renaming columns and handling nulls.

```sql
SELECT
     "O_ORDERKEY" AS "O_ORDERKEY",
     "O_CUSTKEY" AS "O_CUSTKEY",
     UPPER("O_ORDERSTATUS") AS "O_ORDERSTATUS",
     COALESCE("O_TOTALPRICE", 0) AS "O_TOTALPRICE",
     "O_ORDERDATE" AS "O_ORDERDATE"
FROM {{ ref('SRC', 'ORDERS') }} "ORDERS"
WHERE "O_ORDERSTATUS" != 'F'
```
**Using CTEs (Common Table Expressions)** - For more complex, multi-step logic

```sql
WITH PRIORITY_COUNTS AS (
    SELECT 
        "O_ORDERPRIORITY" AS "O_ORDERPRIORITY",
        COUNT(*) AS ORDER_COUNT
    FROM {{ ref('SRC', 'ORDERS') }}
    GROUP BY 1
)
SELECT * FROM PRIORITY_COUNTS
```
**Multi-CTE Transformation With Window Functions** <br/>
Complex transformations that would otherwise require multiple nodes can be written as a single SQL statement. Coalesce tracks lineage through each CTE and down to the source tables
```sql
WITH ORDERED_ORDERS AS (
-- CTE 1: Rank every order for each customer by date
SELECT
O_CUSTKEY,
O_ORDERKEY,
O_ORDERDATE,
O_TOTALPRICE,
O_ORDERSTATUS,
ROW_NUMBER() OVER (
PARTITION BY O_CUSTKEY
ORDER BY O_ORDERDATE ASC, O_ORDERKEY ASC
) AS ORDER_RANK
FROM {{ ref('SRC', 'ORDERS') }}
),
FIRST_ORDERS AS (
-- CTE 2: Filter to keep only the first order (rank 1) for each customer
SELECT
O_CUSTKEY,
O_ORDERKEY AS FIRST_ORDER_ID,
O_ORDERDATE AS FIRST_PURCHASE_DATE,
O_TOTALPRICE AS FIRST_ORDER_VALUE,
O_ORDERSTATUS
FROM ORDERED_ORDERS
WHERE ORDER_RANK = 1
)
-- Final Select: Add metadata and return the results
SELECT
F.O_CUSTKEY,
F.FIRST_ORDER_ID,
F.FIRST_PURCHASE_DATE,
F.FIRST_ORDER_VALUE,
F.O_ORDERSTATUS @notNull,
CURRENT_TIMESTAMP() AS REFRESHED_AT,
'Initial Customer Purchase' AS RECORD_TYPE
FROM FIRST_ORDERS F
```
**Using Recursive CTE - Date Series**
```sql
WITH RECURSIVE RCTE_FNL AS (
    SELECT TO_DATE('2025-01-01') AS "date_s"
    UNION ALL
    SELECT DATEADD(day, 1, "date_s") AS "date_s"
    FROM RCTE_FNL
    where "date_s" < TO_DATE('2025-01-10')
  )
SELECT "date_s"
FROM RCTE_FNL
```
**Using Recursive CTE - Classic Employee**
```sql
WITH RECURSIVE RCTE_FINAL AS (

    -- Anchor clause: top-level employees (no manager)
    SELECT
        "EMPLOYEES_RECUR"."EMPLOYEE_ID"  AS "EMPLOYEE_ID",
        1                                AS "LEVEL",
        "EMPLOYEES_RECUR"."TITLE"        AS "TITLE",
        "EMPLOYEES_RECUR"."MANAGER_ID"   AS "MANAGER_ID"
    FROM {{ ref('SRC', 'EMPLOYEES_RECUR') }} AS "EMPLOYEES_RECUR"
    WHERE "EMPLOYEES_RECUR"."MANAGER_ID" IS NULL

    UNION ALL

    -- Recursive clause: employees reporting to someone in the CTE
    SELECT
        "EMPLOYEES_RECUR"."EMPLOYEE_ID"  AS "EMPLOYEE_ID",
        "RCTE_FINAL"."LEVEL" + 1         AS "LEVEL",
        "EMPLOYEES_RECUR"."TITLE"        AS "TITLE",
        "EMPLOYEES_RECUR"."MANAGER_ID"   AS "MANAGER_ID"
    FROM {{ ref('SRC', 'EMPLOYEES_RECUR') }} AS "EMPLOYEES_RECUR"
    JOIN RCTE_FINAL
        ON "EMPLOYEES_RECUR"."MANAGER_ID" = "RCTE_FINAL"."EMPLOYEE_ID"
)

SELECT
    "LEVEL"          AS "LEVEL",
    "TITLE"::VARCHAR AS "TITLE"
FROM RCTE_FINAL
```
**Using CTE for multisource combine**
```sql
WITH ALL_NATIONS AS (
    SELECT *
    FROM {{ ref('SOURCE_DATA', 'NATION_COPY1') }}
    UNION
    SELECT *
    FROM {{ ref('SOURCE_DATA', 'NATION_COPY2') }}
)
SELECT * FROM ALL_NATIONS
```

### Supported SQL Functionality

- **Multi-Source Joins & Enrichment:** The ability to reference and join multiple upstream nodes (e.g., Joining ORDERS and CUSTOMER) within a single stage to flatten data or create enriched wide tables while maintaining full lineage for every source.

- **Conditional Logic via CASE Statements:** Support for complex business rules and data categorization using standard CASE WHEN syntax to create derived columns based on multiple logical conditions.

 - **Flexible Projection (SELECT * with Expressions):** Enhanced projection capabilities that allow for selecting all columns from a source (`SELECT *`) while simultaneously appending new calculated expressions, timestamps, or metadata in the same statement.

- **Nested Subqueries:** Support for correlated and non-correlated subqueries within SELECT, FROM, or WHERE clauses, enabling granular filtering and complex lookups that don't require separate nodes.

- **Common Table Expressions (CTEs)**: Support for standard `WITH` clauses to break down complex, multi-step transformation logic into readable, modular blocks. Coalesce tracks lineage through each CTE and back to the source tables.

- **Recursive CTEs**: Full support for `WITH` RECURSIVE logic, enabling the transformation of hierarchical data and the programmatic generation of data sequences within a single node.
  
- If a CTE is referenced in templates that may include joins, always use a **table alias** and qualify all column references with that alias. This prevents ambiguous column errors and ensures the template remains extensible as additional joins are introduced.

---

### SQL Work Deployment

#### SQL Work Initial Deployment

When deployed for the first time into an Environment the SQL Work Node of materialization type table will execute the below stage:

| **Stage** | **Description** |
|-----------|----------------|
| **Create SQL Work Table** | This will execute a CREATE OR REPLACE statement and create a table in the target Environment |
| **Create SQL Work View** | This will execute a CREATE OR REPLACE statement and create a view in the target Environment |

#### SQL Work Redeployment

After the SQL Work Node with materialization type table has been deployed for the first time into a target Environment, subsequent deployments may result in either altering the SQL Work Table or recreating the SQL Work table.

#### Altering the SQL Work Tables

A few types of column or table changes will result in an ALTER statement to modify the SQL Work Table in the target Environment, whether these changes are made individually or all together:

* Changing table names
* Dropping existing columns
* Altering column data types
* Adding new columns

The following stages are executed:

| **Stage** | **Description** |
|-----------|----------------|
| **Clone Table** | Creates an internal table |
| **Rename Table\| Alter Column \| Delete Column \| Add Column \| Edit table description** | Alter table statement is executed to perform the alter operation |
| **Swap Cloned Table** | Upon successful completion of all updates, the clone replaces the main table ensuring that no data is lost |
| **Delete Table** | Drops the internal table |

> **Note:** Renaming a column results in the existing column being dropped and a new column being created. This operation may lead to data loss and should be performed with caution.

#### Recreating the SQL Work Tables

If the materialization type is changed from Table to View, then the following stages are executed:

| **Stage** | **Description** |
|-----------|----------------|
| **Delete Table** | Drops the existing table |
| **Create View** | Recreates the node as a view |

#### Recreating the SQL Work Views

The subsequent deployment of the SQL Work Node of materialization type view with changes in view definition, adding table description or renaming view results in deleting the existing view and recreating the view.

The following stages are executed:

| **Stage** | **Description** |
|-----------|----------------|
| **Delete View** | Removes existing view |
| **Create View** | Creates new view with updated definition |

### Removing a SQL Work Node

If a SQL Work Node of materialization type table is deleted from a SQL Workspace, that SQL Workspace is committed to Git and that commit deployed to a higher-level Environment, then the SQL Work Table in the target Environment will be dropped.

This is executed in two stages:

| **Stage** | **Description** |
|-----------|----------------|
| **Delete Table** | Coalesce Internal table is dropped |
| **Delete Table** | Target table in BigQuery is dropped |

If a SQL Work Node of materialization type view is deleted from a Workspace, that Workspace is committed to Git and that commit deployed to a higher-level Environment, then the WorkView in the target Environment will be dropped.

The stage executed:

| **Stage** | **Description** |
|-----------|----------------|
| **Delete View** | Drops the existing SQL Work view from the target Environment |

---
