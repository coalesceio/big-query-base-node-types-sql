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
| `@disableTests` | Controls whether configured tests are skipped.<br/>*Specified in the SQL editor → all node- and column-level tests are skipped.*<br/>*Not specified in the SQL editor → tests run normally.*<br/>To turn tests back on, remove the annotation. Useful while developing a node — iterate on the SQL first, then re-enable once the logic is settled. |
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
| `@defaultValue(<value>)` ***(reserved)*** | Adds default value.<br/>Quote to match the column's data type - <br/>number: `defaultValue("\<num>")`<br/>string: `defaultValue("'\<string>'")`<br/>**Note:** Ignored on Views. |
| `@inHash(<hashName>, <hashOrder>)` **¹** | ***(repeatable)*** Marks a column as an input to a generated hash key.<br/>Columns sharing the same `hashName` are grouped together; `hashOrder` sets this column's position within that group.<br/>Call `get_hash("<hashName>")` elsewhere in the SELECT to produce the hash column from the marked columns. |

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
| `@business_rule("<expression>", "<label>")` **²** | ***(repeatable)*** Runs a custom SQL boolean expression against every row.<br/>**expression** - is pasted verbatim into a `WHERE NOT (...)` clause against the target table.<br/>**label** is optional — names the test stage, defaults to `business_rule`. |
| `@business_query("<query>", "<label>")` **²** | ***(repeatable)*** Runs a complete SQL query, pasted into the SQL verbatim.<br/>**query** - SQL query written to select only the rows that fail the check.<br/>**label** is optional — names the test stage, defaults to `business_query`. |
| `@relationship("<location>", "<node>", "<column>")` | ***(repeatable)*** Referential integrity check.<br/>Fails on rows whose non-NULL value has no match in the parent column, e.g. `@relationship("SRC", "CUSTOMER", "C_CUSTKEY")`.<br/>**location** — parent's Storage Location.<br/>**node** — parent table name.<br/>**column** — matching column in the parent node. |

---

### Notes

- Verify that all **column datatypes** are successfully resolved before creating the object. Columns with an `UNKNOWN` datatype may cause stage generation or runtime failures.
- **¹** The hash transformation uses the reusable `get_hash()` macro:

    ```SQL
    {{ get_hash(<hash_name>, <algo>, <delimiter>) }}
    ```

    | Parameter | Description |
    |-----------|-------------|
    | `hash_name` | Hash name used across columns to identify the columns included in the hash. |
    | `algo` | **(optional)** Hashing algorithm to use. Supported values include `SHA1` and `SHA256`. Defaults to `SHA1`. |
    | `delimiter` | **(optional)** Delimiter used to separate column values when generating the hash. Defaults to `\|\|` and can be customized. |

    **Example:**

    ```SQL
    `N_NAME` AS `N_NAME` @inHash("GH_COL", 1),
    CAST({{ get_hash('GH_COL') }} AS STRING) AS "GH_COL"
    ```

- **²** `business_rule` and `business_query` are attached to a column syntactically, but the column they're attached to is only used to label the test stage (e.g. "N_NATIONKEY: business_rule") — the check itself runs whatever expression or query you write, which can reference any column(s) on the target table. Unlike `not_null`/`unique`/`min_max`/etc., these two are effectively freeform node-level checks declared via a column annotation, not true single-column tests.

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
