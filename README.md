# SQL-First NodeTypes

The [SQL-first nodes](https://docs.coalesce.io/docs/build-your-pipeline/v2-node-types) is a transformation tool within Coalesce that lets developers write custom, hand-coded SQL instead of using the standard graphical column-mapping interface. It is ideal for complex transformations, advanced window functions, or multi-step logic that is difficult to represent with the standard UI, and ships with a built-in library of column- and node-level data quality tests. While it provides maximum flexibility, it shifts the responsibility of column definition and logic maintenance to the SQL author.

# BigQuery Base Node Types - SQL Package

The BigQuery Base Node Types - SQL Package includes:

* [Work](#work)
* [Dimension](#dimension)
* [Fact](#fact)

Concepts shared across every node type — BigQuery prerequisites, partitioning, clustering, table options, tags, hash columns, data quality tests, known limitations and usage examples — are documented once in [Common Reference](#common-reference) and linked to from each node type below.

## Prerequisites

The package checks most of these at deploy time and stops the deployment with a clear message, but they are easier to get right up front:

* **Datasets exist.** Every storage location must map to an existing BigQuery project and dataset. The node types do not create datasets.
* **Same location.** A node and the datasets it reads from must be in the same BigQuery location (region); BigQuery does not query across locations.
* **Tags exist in GCP.** `@tag` uses Resource Manager tags: the tag key and value must already exist, and the deploying account needs permission to bind them (`roles/resourcemanager.tagUser`). See [`@tag`](#tag).
* **One partition, at most four cluster columns.** A BigQuery table has a single partition column or expression and clusters on at most four plain columns — see [Partitioning](#partitionby) and [Clustering](#clusterkey).
* **Every Dimension and Fact column needs its own `@id`.** See [`@id`](#id-column).
* **Dimension surrogate key needs a default.** The load never writes the surrogate key, so the column must carry `@defaultValue("GENERATE_UUID()")` — see [`@isSurrogateKey`](#issurrogatekey-dimension).
* **Column datatypes resolve.** A column whose datatype shows as `UNKNOWN` (for example a bare `GENERATE_UUID()` or `COALESCE(...)`) fails at create — wrap it in `CAST(... AS <type>)`.

## Node Type Comparison

A side-by-side view of which annotations each node type supports, so it's easy to see what a given node type is missing compared to the others.

### Node Annotations Matrix

| Annotation | Work | Dimension | Fact |
|---|---|---|---|
| `@materializationType` | table / view | table / view | table / view |
| `@writeMode` | ✅ | ✅ | ✅ |
| `@mergeStrategy` | ➖ | ✅<br/>* changeTracking<br/>* lastModified<br/>* upsert | ✅<br/>* changeTracking<br/>* lastModified<br/>* upsert<br/>* allColumnMatch |
| `@zeroKey` (node-level) | ➖ | ✅ | ➖ |
| `@partitionBy` (node-level) | ✅ | ✅ | ✅ |
| `@partitionExpirationDays` | ✅ | ✅ | ✅ |
| `@tableExpiration` | ✅ | ✅ | ✅ |
| `@defaultRoundingMode` | ✅ | ✅ | ✅ |
| `@tag` | ✅ | ✅ | ✅ |
| `@disableTests` | ✅ | ✅ | ✅ |
| `@tests` | ✅ | ✅ | ✅ |
| `@preSQL` | ✅ | ✅ | ✅ |
| `@postSQL` | ✅ | ✅ | ✅ |
| Target Load | (TRUNCATE) INSERT | (TRUNCATE) MERGE | (TRUNCATE) MERGE/INSERT |

### Column Annotations Matrix

| Annotation | Work | Dimension | Fact |
|---|---|---|---|
| `@id` ***(required)*** | ➖ | ✅ | ✅ |
| `@isBusinessKey` | ➖ | ✅<br/>***(required)*** | ✅<br/>***(conditional)*** ³ |
| `@isChangeTracking` | ➖ | ✅ | ➖ |
| `@lastModifiedTracking` | ➖ | ✅ | ✅ |
| `@zeroKey` (column-level) | ➖ | ✅ | ➖ |
| `@isSurrogateKey` | ➖ | ✅ | ➖ |
| `@isSystemVersion` | ➖ | ✅ | ➖ |
| `@isSystemCurrentFlag` | ➖ | ✅ | ➖ |
| `@isSystemCreateDate` | ➖ | ✅ | ✅ |
| `@isSystemUpdateDate` | ➖ | ✅ | ✅ |
| `@isSystemEndDate` | ➖ | ✅ | ➖ |
| `@partitionBy` (column-level) | ✅ | ✅ | ✅ |
| `@clusterKey` | ✅ | ✅ | ✅ |
| `@primaryKey` | ✅ | ✅ | ✅ |
| `@inHash` | ✅ | ✅ | ✅ |
| all column tests | ✅ | ✅ | ✅ |

> See [Column-Level Data Quality Tests](#column-level-data-quality-tests) for the shared quality-test annotations in the last row. BigQuery has no column-level tags — a `@tag` on a column is not applied and only raises a warning.
>
> ³ Fact: required for an explicit `@mergeStrategy` of `changeTracking`, `lastModified` or `upsert`; optional otherwise — with neither `@mergeStrategy` nor `@isBusinessKey` the node is a plain insert, and `allColumnMatch` ignores it. See [Fact Load Behaviour](#fact-load-behaviour).

---

## Work

The Work node is a general-purpose transformation node within Coalesce, used to materialize intermediate or staging-layer tables and views as part of a larger transformation pipeline. It sits between raw source data and downstream modeled objects, giving developers a flexible landing point to shape, clean, and validate data — complete with a built-in library of column- and node-level data quality tests — before it flows further into the pipeline.

### Work Node Configuration

The Work Node type has three configuration groups:

* [General](#work-general-options)
* [Node Annotations](#work-node-annotations)
* [Column Annotations](#work-column-annotations)

#### Work General Options

| **Property** | **Description** |
|----------|-------------|
| **Storage Location** | Storage Location (BigQuery project and dataset) where the Work table or view will be created |
| **Node Type** | Read-only: the node type's name and ID — **Work** (`SQLWork`). Set from `@nodeType` when the node is created. |

### Work Node Annotations

| **Annotation** | **Summary** |
|---|---|
| `@id(id)` ***(reserved)*** | Unique identifier for the node.<br/>Static and auto-generated when the node is created — not meant to be edited. |
| `@nodeType(type)` ***(reserved)*** | Identifies the node's type.<br/>Set automatically based on the node type chosen when the node is created. |
| `@description(text)` ***(reserved)*** | Node-level description.<br/>Can be edited via this annotation or in the node description field below the node name in the UI.<br/>Example: `@description("Table description")` |
| [`@materializationType(type)`](#materializationtype) ***(reserved)*** | `table` or `view` |
| `@deployDisabled` ***(reserved)*** | Excludes this node from deployment. |
| [`@partitionBy(expression)`](#partitionby) | Partitions the table by a column or expression. |
| [`@partitionExpirationDays(days)`](#partitionexpirationdays) | Days each partition is kept before BigQuery deletes it. |
| [`@tableExpiration(value)`](#tableexpiration) | When BigQuery deletes the table or view. |
| [`@defaultRoundingMode(mode)`](#defaultroundingmode) | Rounding mode for NUMERIC/BIGNUMERIC values written to the table. |
| [`@tag(tagName, tagValue)`](#tag) ***(repeatable)*** | Applies a Resource Manager tag to this table or view. |
| [`@writeMode("truncateInsert \| append")`](#writemode) | How each run writes to the target: truncateInsert or append<br/>*Not specified in the SQL editor → defaults to **truncateInsert**.* |
| [`@disableTests`](#disabletests) **²** | Controls whether configured tests are skipped. |
| [`@tests(querySQL, continueOnFailure?, runOrder?)`](#tests) **²** ***(repeatable)*** | Node-level data quality test. |
| [`@preSQL(querySQL)`](#presql) ***(repeatable)*** | SQL statement to execute `before` the data load operation. |
| [`@postSQL(querySQL)`](#postsql) ***(repeatable)*** | SQL statement to execute `after` the data load operation. |

### Work Column Annotations

| **Annotation** | **Summary** |
|---|---|
| `@notNull` ***(reserved)*** | Marks column as NOT NULL.<br/>**Note:** Ignored on Views.<br/>Example: `@notNull` |
| `@description(<text>)` ***(reserved)*** | Adds column description.<br/>Example: `@description("timestamp column")` |
| [`@defaultValue(<value>)`](#defaultvalue) ***(reserved)*** | Adds default value. |
| [`@partitionBy`](#partitionby) | Partitions the table by this column (a bare flag, no parameters). |
| [`@clusterKey(position)`](#clusterkey) | Marks a column as part of the table's CLUSTER BY key, in the order given by **position** (lowest first). |
| [`@primaryKey(position)`](#primarykey) | Marks a column as part of the table's (unenforced) primary key. |
| [`@inHash("<hashName>", <hashOrder>)`](#inhash) **¹** ***(repeatable)*** | Marks a column as an input to a generated hash key. |

> Details for each annotation are in the [Annotation Reference](#annotation-reference).

>**Note:** Quoting matters when writing `@tests`, `@preSQL`, and `@postSQL` — see [Quoting Inside Annotations](#quoting-inside-annotations).

🚦 The full set of column-level data quality tests (`@not_null`, `@uniqueness`, `@empty`, `@accepted_values`, `@rejected_values`, `@min_max`, `@min_value`, `@max_value`, `@freshness`, `@relative_time`) applies to Work columns exactly as described in [Column-Level Data Quality Tests](#column-level-data-quality-tests).

---

### Work Deployment

Every deployment of a Work node first runs these checks before any change in BigQuery. A failing check stops the deployment; a warning does not:

| **Stage** | **Description** |
|-----------|----------------|
| **Unsupported Materialization Type: \<node\>** | `@materializationType` is not `table` or `view` (BigQuery has no transient table) |
| **Warning: Duplicate Tags Found: \<node\>** | Non-failing — the same tag key applied more than once on the node; a BigQuery table or view holds one value per tag key, so the last `@tag` for that key is applied |
| **Warning: Column Tags Ignored: \<node\>** | Non-failing — a `@tag` on a column is not applied, because BigQuery has no column-level tags |
| **Invalid configuration: tableExpiration** | `@tableExpiration` is a number of days, which is not supported — stops the deployment. Use a date / datetime (or an expression) |
| **Warning: tableExpiration Expression** | Non-failing — `@tableExpiration` is a SQL expression, not a fixed date / datetime: it is evaluated on every create or alter, so an expression on `CURRENT_TIMESTAMP()` moves the expiry forward each time |
| **Invalid configuration: partitionBy \| partitionExpirationDays \| clusterKey** | Table only — more than one partition, an invalid column-level `@partitionBy`, partition expiration without any partition, more than 4 cluster columns or a cluster expression. See [Partitioning](#partitionby) and [Clustering](#clusterkey). |
| **Warning: partitionExpirationDays Ignored** | Non-failing, table only — `@partitionExpirationDays` on an integer-range (`RANGE_BUCKET`) partition is not applied |

#### Work Initial Deployment

When deployed for the first time into an Environment, the Work Node executes one of these stages, depending on its materialization type:

| **Stage** | **Description** |
|-----------|----------------|
| **Create Work Table** | Executes a CREATE OR REPLACE TABLE statement, with column descriptions, NOT NULL, defaults, primary key, PARTITION BY, CLUSTER BY and OPTIONS (description, expirations, rounding mode, tags) |
| **Create Work View** | Executes a CREATE OR REPLACE VIEW statement, with column descriptions and OPTIONS (description, expiration, tags) |

#### Work Load

| **Stage** | **Description** |
|-----------|----------------|
| **Pre Load Test `<n>`** | Node-level `@tests(..., "Before")` tests, in the order they appear. |
| **Pre-SQL `<n>`** | Each `@preSQL` statement, in the order they appear. |
| **Truncate table** | Executed unless `@writeMode("append")` is set — clears the target before the load. |
| **Load table using Insert** | Inserts every source row with `INSERT INTO … SELECT`. |
| **Post-SQL `<n>`** | Each `@postSQL` statement, in the order they appear. |
| **`<column>: <test>` \| Post Load Test `<n>`** | Column-level data quality tests and node-level `@tests(..., "After")` tests, run after the load. |
| **Load Skipped for View** | For a view there is no load — only the tests run. |

#### Work Redeployment

After the Work Node has been deployed for the first time into a target Environment, subsequent deployments either alter the existing object, recreate it, or only record a metadata update when nothing in the object changed (for example tests, `@writeMode`, `@preSQL`/`@postSQL`, or a transform or join on a table):

| **Stage** | **Description** |
|-----------|----------------|
| **Metadata Update-Default** | The node changed, but nothing in BigQuery needs to change |

#### Altering the Work Tables

Changes to columns, the primary key or the table name alter the Work Table, whether made individually or all together. BigQuery cannot swap tables, so the changes are made on an internal clone, which is then copied back over the live table (the pattern the BigQuery YAML node types use) — a failure leaves the live table untouched.

The following stages are executed, in this order (each one only when needed):

| **Stage** | **Description** |
|-----------|----------------|
| **Warning: NOT NULL Not Applied** | Non-failing message when a column becomes NOT NULL or a NOT NULL column is added — BigQuery cannot set NOT NULL on an existing table; the column stays NULLABLE until the table is recreated |
| **Clone Table** | Creates an internal working copy of the table (`<table>_COALESCE_INTERNAL_TABLE`) with `CREATE OR REPLACE TABLE … COPY`. Despite the stage name this is a full table copy, not a BigQuery table clone. |
| **Drop Primary Key** | Drops the primary key on the clone when it changed |
| **Alter Column Data Type** | Changes data types (BigQuery runs SET DATA TYPE on its own) |
| **Alter Column** | Drops NOT NULL, sets or drops defaults and changes column descriptions, in one statement |
| **Add Column** | Adds new columns, with their descriptions |
| **Set Default: \<column\>** | BigQuery cannot add a column with a DEFAULT: the default is set after the add. Existing rows are not backfilled — they keep NULL |
| **Rename Column** | Renames a column whose `@id` is unchanged |
| **Delete Column** | Drops removed columns |
| **Add Primary Key** | Adds the new primary key on the clone |
| **Replace Table** | Copies the altered clone back over the live table (`CREATE OR REPLACE TABLE … COPY`) — or to the new name when the table is renamed |
| **Delete Table** | Drops the old table after a rename |
| **Delete Clone** | Drops the internal clone |
| **Edit Table Options** | One `SET OPTIONS(...)` when the description, expirations, rounding mode or tags changed — and always after **Replace Table**, because the copied table loses its tags and table expiration, so they are re-attached here. Every option is listed; a removed one is reset (NULL, tags to `[]`). |

> **Note:** Work columns have no `@id`, so a column's name is its id: renaming a column drops it and adds a new one, which loses its data.

> ⚠️ **Case-only renames fail.** BigQuery column names are case-insensitive — see [Column Name Case](#known-limitations). Changing only the case of a column (e.g. `N_NAME` → `n_Name`) currently fails the alter with *"Column already exists"* (the table is left untouched).

> **Note:** BigQuery only allows certain data type changes (for example widening `INT64` → `NUMERIC`, or `NUMERIC` → `BIGNUMERIC`). Other changes fail on the clone with BigQuery's error, leaving the live table untouched.

#### Recreating the Work Tables

BigQuery cannot alter a table's partitioning or clustering, or move it to another dataset, so these changes drop the table and create it again — **the existing data is lost**:

| **Stage** | **Description** |
|-----------|----------------|
| **Drop Current table - \<name\>** | Drops the existing table (or view, when the materialization type changed) |
| **Create Work Table \| Create Work View** | Creates the node again with the new definition |

This happens when:
* the materialization type changes (table ↔ view),
* the partition (`@partitionBy`) or the cluster key (`@clusterKey`) changes,
* the node moves to another project or dataset.

> **Note:** The partition and cluster key are compared as text, so changing only the case of a partition or cluster column (e.g. `CLUSTER BY N_NATIONKEY` → `n_NationKey`) also drops and recreates the table, although BigQuery treats it as the same column — see [Column Name Case](#known-limitations).

#### Altering and Recreating the Work Views

| **Stage** | **Description** |
|-----------|----------------|
| **Create Work View** | The view definition changed (columns, transforms, joins, column descriptions): CREATE OR REPLACE VIEW with the new definition |
| **Edit View Options** | Only the view's OPTIONS changed (description, `@tableExpiration`, `@tag`): one `ALTER VIEW … SET OPTIONS(...)` with only the changed options; the others keep their values |
| **Drop Current view - \<name\>** + **Create Work View** | The view is renamed or moved: the old view is dropped and the new one created |
| **Metadata Update-Default** | Only tests or run settings changed (`@tests`, column tests, `@disableTests`, `@writeMode`, …) — the view is not recreated or altered |

### Removing a Work Node

If a Work Node is deleted from a SQL Workspace, that SQL Workspace is committed to Git and that commit deployed to a higher-level Environment, then the Work table or view in the target Environment will be dropped:

| **Stage** | **Description** |
|-----------|----------------|
| **Delete Clone** | Table only — drops the internal clone, if one was left behind by a failed deployment |
| **Drop Current table \| view - \<name\>** | Drops the target table or view in BigQuery |

---

## Dimension

The Dimension node is a specialized transformation node within Coalesce, used to materialize dimension tables that track descriptive attributes over time. It merges incoming source data into the target using a configurable change-detection strategy — plain upsert, column-based change tracking, or a last-modified timestamp — and, depending on that strategy and the columns marked on the node, produces either an SCD Type 1 (overwrite-in-place) or SCD Type 2 (versioned history) dimension, complete with a built-in library of column- and node-level data quality tests.

### Dimension Node Configuration

The Dimension Node type has three configuration groups:

* [General](#dimension-general-options)
* [Node Annotations](#dimension-node-annotations)
* [Column Annotations](#dimension-column-annotations)

#### Dimension General Options

| **Property** | **Description** |
|----------|-------------|
| **Storage Location** | Storage Location (BigQuery project and dataset) where the Dimension table or view will be created |
| **Node Type** | Read-only: the node type's name and ID — **Dimension** (`SQLDimension`). Set from `@nodeType` when the node is created. |

### Dimension Node Annotations

| **Annotation** | **Summary** |
|---|---|
| `@id(id)` ***(reserved)*** | Unique identifier for the node.<br/>Static and auto-generated when the node is created — not meant to be edited. |
| `@nodeType(type)` ***(reserved)*** | Identifies the node's type.<br/>Set automatically based on the node type chosen when the node is created. |
| `@description(text)` ***(reserved)*** | Node-level description.<br/>Can be edited via this annotation or in the node description field below the node name in the UI.<br/>Example: `@description("Table description")` |
| [`@materializationType(type)`](#materializationtype) ***(reserved)*** | `table` or `view` |
| `@deployDisabled` ***(reserved)*** | Excludes this node from deployment. |
| [`@partitionBy(expression)`](#partitionby) | Partitions the table by a column or expression. |
| [`@partitionExpirationDays(days)`](#partitionexpirationdays) | Days each partition is kept before BigQuery deletes it. |
| [`@tableExpiration(value)`](#tableexpiration) | When BigQuery deletes the table or view. |
| [`@defaultRoundingMode(mode)`](#defaultroundingmode) | Rounding mode for NUMERIC/BIGNUMERIC values written to the table. |
| [`@tag(tagName, tagValue)`](#tag) ***(repeatable)*** | Applies a Resource Manager tag to this table or view. |
| [`@writeMode("truncateInsert \| append")`](#writemode) | How each run writes to the target: truncateInsert or append<br/>*Not specified in the SQL editor → defaults to **append**.* |
| [`@mergeStrategy("upsert \| changeTracking \| lastModified")`](#mergestrategy-dimension) | Chooses how this dimension decides a row has changed, and therefore which column annotations it requires. |
| [`@zeroKey(surrogateKeyValue, stringValue?, timestampValue?, booleanValue?)`](#zerokey-dimension-node) | Inserts a default "zero key" record into the target — a placeholder row used to catch unresolved foreign key lookups. |
| [`@disableTests`](#disabletests) **²** | Controls whether configured tests are skipped. |
| [`@tests(querySQL, continueOnFailure?, runOrder?)`](#tests) **²** ***(repeatable)*** | Node-level data quality test. |
| [`@preSQL(querySQL)`](#presql) ***(repeatable)*** | SQL statement to execute `before` the data load operation. |
| [`@postSQL(querySQL)`](#postsql) ***(repeatable)*** | SQL statement to execute `after` the data load operation. |

### Dimension Column Annotations

**Column annotations shared with Work and Fact**

| **Annotation** | **Summary** |
|---|---|
| [`@id("<value>")`](#id-column) | Stable column ID for lineage tracking. |
| `@notNull` ***(reserved)*** | Marks column as NOT NULL.<br/>**Note:** Ignored on Views.<br/>Example: `@notNull` |
| `@description(<text>)` ***(reserved)*** | Adds column description.<br/>Example: `@description("timestamp column")` |
| [`@defaultValue(<value>)`](#defaultvalue) ***(reserved)*** | Adds default value. |
| [`@partitionBy`](#partitionby) | Partitions the table by this column (a bare flag, no parameters). |
| [`@clusterKey(position)`](#clusterkey) | Marks a column as part of the table's CLUSTER BY key, in the order given by **position** (lowest first). |
| [`@primaryKey(position)`](#primarykey) | Marks a column as part of the table's (unenforced) primary key. |
| [`@inHash("<hashName>", <hashOrder>)`](#inhash) **¹** ***(repeatable)*** | Marks a column as an input to a generated hash key. |

**Dimension-specific column annotations**

| **Annotation** | **Summary** |
|---|---|
| `@isBusinessKey` ***(required)*** | Marks a column as part of the business key used to match existing rows during the merge.<br/>**Note:** Ignored on Views.<br/>Example: `@isBusinessKey` |
| [`@lastModifiedTracking(scdType?)`](#lastmodifiedtracking) | Marks the column used to detect newer source rows for an incremental load. |
| [`@isChangeTracking`](#ischangetracking-dimension) | Marks a column to be watched for changes that decide SCD type. |
| [`@zeroKey(value)`](#zerokey-dimension-column) | Adds a custom zero key value (ghost record) to this column, overriding the node-level `@zeroKey` defaults for it. |
| [`@isSurrogateKey`](#issurrogatekey-dimension) | Marks this column as the node's surrogate key. |
| [`@isSystemVersion`](#issystemversion-dimension) | Marks this column as the SCD version number, incremented each time a business key gets a new version. |
| [`@isSystemCurrentFlag`](#issystemcurrentflag-dimension) | Marks this column as the SCD "is current" flag — `'Y'` on the active version of a row, overwritten to `'N'` when it's expired. |
| [`@isSystemCreateDate`](#issystemcreatedate) | Marks this column as the timestamp a row (or, under SCD Type 2, a specific row version) was first created. |
| [`@isSystemUpdateDate`](#issystemupdatedate) | Marks this column as the timestamp a row was last updated. |
| [`@isSystemEndDate`](#issystemenddate-dimension) | Marks this column as the SCD Type 2 expiration timestamp — a far-future sentinel while the row is current, set to the actual expiry time once superseded. |

> Shared annotations link to the [Annotation Reference](#annotation-reference); the Dimension-specific ones are described in [Dimension Annotation Details](#dimension-annotation-details).

>**Note:** Quoting matters when writing `@tests`, `@preSQL`, and `@postSQL` — see [Quoting Inside Annotations](#quoting-inside-annotations).

🚦 The full set of column-level data quality tests (`@not_null`, `@uniqueness`, `@empty`, `@accepted_values`, `@rejected_values`, `@min_max`, `@min_value`, `@max_value`, `@freshness`, `@relative_time`) applies to Dimension columns exactly as described in [Column-Level Data Quality Tests](#column-level-data-quality-tests).

### Dimension Annotation Details

##### `@mergeStrategy` (Dimension)

`@mergeStrategy("upsert | changeTracking | lastModified")`

Chooses how this dimension decides a row has changed, and therefore which column annotations it requires.

| **Value** | **Description** |
|---|---|
| `upsert` | No change detection at all; a matched row is always updated, an unmatched row is inserted. Doesn't assert any SCD type of its own — if the upstream SELECT/CTE already implements SCD1/SCD2 logic, this strategy just merges that result through as-is. The SELECT/CTE should return one row per business key (de-duplicate upstream). System columns are optional; any that are present are written exactly as the SELECT/CTE computes them. `@lastModifiedTracking`/`@isChangeTracking` columns aren't used — if present, a warning is raised and they're ignored. |
| `changeTracking` | Compares columns marked `@isChangeTracking` (or, if none are marked, every plain attribute column) to detect a change. SCD Type 2 if any column is marked `@isChangeTracking`, otherwise SCD Type 1. Doesn't use `@lastModifiedTracking` — if present, a warning is raised and it's ignored. |
| `lastModified` | Compares a single `@lastModifiedTracking` timestamp column against the target's stored value. Requires exactly one column marked `@lastModifiedTracking` — a validation check flags it if none (or more than one) is present. SCD Type 1 or 2 comes from that column's own `scdType` parameter. Doesn't use `@isChangeTracking` — if present, a warning is raised and it's ignored. |

* *Not specified in the SQL editor → defaults to **changeTracking** - SCD Type 1.*
* The value is not case-sensitive; any other value is flagged by a validation check.
* Every strategy merges on the business key, so the SELECT/CTE must return exactly one row per business key, with no NULL business key — see [Duplicate or NULL Business Keys](#known-limitations) for a `Before` test that checks this.
* Under **changeTracking** / **lastModified** the load writes fixed system column values — see [System column values](#system-column-values).
* **Note:** Ignored on Views.

**Example:**

```sql
@mergeStrategy("lastModified")
```

##### `@zeroKey` (Dimension node)

`@zeroKey(surrogateKeyValue, stringValue?, timestampValue?, booleanValue?)`

Inserts a default "zero key" record into the target — a placeholder row used to catch unresolved foreign key lookups.

| **Parameter** | **Description** |
|---|---|
| **surrogateKeyValue** | **(required)** Value used for the zero record's surrogate key column only, pasted into the SQL verbatim — write it as a value of the key's type: a quoted string for a STRING (UUID) key, e.g. `"'-1'"`, or a number for an INT64 key, e.g. `"-1"`. |
| **stringValue** | **(optional)** Default value for STRING columns, pasted into the SQL verbatim — include your own quotes. Default `"'UNKNOWN'"`. |
| **timestampValue** | **(optional)** Default value for DATE/DATETIME/TIME/TIMESTAMP columns. Default `"1900-01-01 00:00:00"`. |
| **booleanValue** | **(optional)** Default value for BOOL columns. Default `true`. |

* Requires an `@isSurrogateKey` column — the zero record is matched against the target by its surrogate key value. With the recommended `@defaultValue("GENERATE_UUID()")` key, quote the value (`@zeroKey("'-1'")`): real rows get a UUID and the zero record keeps `'-1'`.
* Numeric columns always get `0`; override any column with a column-level `@zeroKey(value)`.
* A value longer than its `STRING(n)` / `BYTES(n)` column raises a non-failing **Warning: Zero Key Value Too Long** test stage that lists each such column; BigQuery then rejects the value and the **Zero Key Record** stage fails. Set a shorter value on the column with `@zeroKey("'<value>'")`, or widen the column. Plain `STRING` has no length limit.
* Quote every parameter (`@zeroKey("0")`) — an unquoted value is dropped by the loader.
* *Not specified in the SQL editor → the zero record is not inserted.*
* **Note:** Ignored on Views.

**Example:**

```sql
@zeroKey("'-1'", "'UNKNOWN'", "1900-01-01 00:00:00", "true")   -- STRING (UUID) surrogate key
@zeroKey("-1", "'UNKNOWN'", "1900-01-01 00:00:00", "true")     -- INT64 surrogate key
```

##### `@isChangeTracking` (Dimension)

`@isChangeTracking`

Marks a column to be watched for changes that decide SCD type.

* Marked on any column → SCD Type 2 — a change expires the existing row and inserts a new version.
* Not marked on any column → SCD Type 1 — a change updates the row in place.
* Under SCD Type 2, a change in a column **not** marked `@isChangeTracking` updates the current row in place — no new version is created.
* **Note:** Ignored on Views.

**Example:**

```sql
@isChangeTracking
```

##### `@zeroKey` (Dimension column)

`@zeroKey(value)`

Adds a custom zero key value (ghost record) to this column, overriding the node-level `@zeroKey` defaults for it.

| **Parameter** | **Description** |
|---|---|
| **value** | Zero key value for this column, pasted into the SQL verbatim. |

* The value is pasted into the SQL verbatim, so quote it to match the column's data type.
* A value longer than the column's declared `STRING(n)` / `BYTES(n)` length raises the non-failing **Warning: Zero Key Value Too Long** stage (see [`@zeroKey` (Dimension node)](#zerokey-dimension-node)).
* **Note:** Ignored unless `@zeroKey` is enabled at the node level, and ignored on Views.

**Example:**

```sql
@zeroKey("'N/A'")                                          -- string: quotes inside the annotation
@zeroKey("-1")                                             -- number
@zeroKey("0.00")                                           -- decimal
@zeroKey("DATE '1900-01-01'")                              -- date
@zeroKey("TIMESTAMP '1900-01-01 00:00:00'")                -- timestamp
@zeroKey("false")                                          -- boolean
@zeroKey("JSON 'null'")                                    -- json
```

##### `@isSurrogateKey` (Dimension)

`@isSurrogateKey`

Marks this column as the node's surrogate key.

* Optional for SCD Type 1 — the merge logic joins and detects changes entirely off the business key.
* Recommended for SCD Type 2 — a stable surrogate key per version is the standard way to identify a versioned row, though it isn't enforced by the merge itself.
* Required only when the node-level `@zeroKey` is set, since the zero/ghost record is matched against the target by surrogate key value.
* BigQuery has no identity columns or sequences, and the load never writes the surrogate key (it is left out of every MERGE/INSERT column list), so BigQuery fills it from the **column DEFAULT**:
  * no `@defaultValue` → **Invalid configuration: Surrogate Key**; the deployment stops (every new row would get a NULL key);
  * a default other than `GENERATE_UUID()` → non-failing **Warning: Surrogate Key Default**: a BigQuery default can't reference other columns (a hash of the business key fails at create), and a constant gives every row the same key.
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: ``CAST("0" AS STRING) AS `<NODE_NAME>_KEY` @id("<6 hex digits>") @isSurrogateKey @defaultValue("GENERATE_UUID()")`` — type the node name yourself, e.g. `DIM_CUSTOMER_KEY`. The SELECT expression only sets the column's datatype; use a `CAST` (a bare `GENERATE_UUID()` resolves to `UNKNOWN`).

##### `@isSystemVersion` (Dimension)

`@isSystemVersion`

Marks this column as the SCD version number, incremented each time a business key gets a new version.

* Required for SCD Type 2 — shows which version of a row this is; each time a business key's row changes, the expired row is kept and a new row is inserted with this value incremented by 1.
* Optional for SCD Type 1 — new-vs-existing is detected off the business key alone, so this column can be dropped entirely; if kept, it is always written as 1 and never incremented.
* Optional for `upsert` — if kept, it is written exactly as the SELECT/CTE computes it.
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: ``1 AS `SYSTEM_VERSION` @isSystemVersion``

##### `@isSystemCurrentFlag` (Dimension)

`@isSystemCurrentFlag`

Marks this column as the SCD "is current" flag — `'Y'` on the active version of a row, overwritten to `'N'` when it's expired.

* Required for SCD Type 2 — used to filter the target down to each business key's one current row before comparing it against the incoming source row.
* Optional for SCD Type 1 — safe to omit; if kept, it is always written as `'Y'`.
* Optional for `upsert` — if kept, it is written exactly as the SELECT/CTE computes it (e.g. `'N'` for a row the CTE is expiring).
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: ``CAST('Y' AS STRING) AS `SYSTEM_CURRENT_FLAG` @isSystemCurrentFlag``

##### `@isSystemEndDate` (Dimension)

`@isSystemEndDate`

Marks this column as the SCD Type 2 expiration timestamp — a far-future sentinel while the row is current, set to the actual expiry time once superseded.

* Required for SCD Type 2 — this is what makes a version's active window queryable; omitting it leaves expired versions with no expiry marker.
* Optional for SCD Type 1 (no versioning, so nothing ever expires) — safe to omit entirely.
* Optional for `upsert` — if kept, it is written exactly as the SELECT/CTE computes it.
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: ``CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE` @isSystemEndDate``

---

### Dimension SCD Type & System Column Requirements

`@mergeStrategy` picks the change-detection strategy; which SCD type it resolves to (and therefore which system columns are required) depends on that strategy and, for `changeTracking`/`lastModified`, on which columns are marked:

| `@mergeStrategy` | Resolves to | Driven by |
|---|---|---|
| `upsert` | Whatever SCD shape the upstream SELECT/CTE already implements — Coalesce doesn't detect or enforce SCD1/SCD2 here, it just merges the result through as-is. Out of the box (plain SELECT, one row per business key) this behaves as an SCD1 overwrite; SCD2 needs the CTE to do the versioning — see note ² | User's own SQL logic, not any column annotation |
| `lastModified` | SCD1 or SCD2, from that column's own `scdType` parameter | `@lastModifiedTracking(scdType)` |
| `changeTracking` (default) | SCD2 if any column is marked, otherwise SCD1 | `@isChangeTracking` |

Requirement level of each column annotation, by resolved strategy/SCD type:

| Annotation | Category | SCD1 (`changeTracking` / `lastModified`) | SCD2 (`changeTracking` / `lastModified`) | `upsert` |
|---|---|:---:|:---:|:---:|
| `@isBusinessKey` | Key | 🔴 | 🔴 | 🔴 |
| `@isSurrogateKey` | Key | ⚪ | 🟡 | ⚪ |
| `@isSystemCreateDate` | System column | 🔴 | 🔴 | ⚪ |
| `@isSystemUpdateDate` | System column | 🔴 | 🔴 | ⚪ |
| `@isSystemVersion` | System column | ⚪ | 🔴 | ⚪ |
| `@isSystemCurrentFlag` | System column | ⚪ | 🔴 | ⚪ |
| `@isSystemEndDate` | System column | ⚪ | 🔴 | ⚪ |

**Legend:** 🔴 Required · 🟡 Recommended · ⚪ Optional¹

* ¹ `upsert` never reads the target back to compare, so no system column is needed for change detection. Any system column that is present is written exactly as the SELECT/CTE computes it — on insert and on every update — except `@isSystemCreateDate`, which keeps its first-inserted value.<br/>
* ² SCD2 with `upsert`: the merge matches on the `@isBusinessKey` column(s) only, so to keep history mark a key that is unique **per version** as `@isBusinessKey` (e.g. a hash of the natural key and effective date), and have the CTE return both rows: the existing version re-emitted with its expiry values (`SYSTEM_CURRENT_FLAG` → `'N'`, `SYSTEM_END_DATE` → now), which updates the old row, and the new version with a new key, which is inserted.<br/>
* `@lastModifiedTracking`/`@isChangeTracking` on an `upsert` node are never read — a warning is raised and they're ignored.<br/>
* `@isSurrogateKey`, whenever present, needs a `@defaultValue` — see [`@isSurrogateKey`](#issurrogatekey-dimension).<br/>

#### System column values

Under `changeTracking` and `lastModified` the load writes fixed values into the system columns. The expression the SELECT gives a system column is only used to derive the column's datatype — its value is ignored:

| Column | Value written |
|---|---|
| `@isSystemVersion` | `1` on a new key; previous version + 1 on a new SCD2 version |
| `@isSystemCurrentFlag` | `'Y'` on the current row; `'N'` on an expired SCD2 row |
| `@isSystemCreateDate` | `CURRENT_TIMESTAMP` on first insert and on each new SCD2 version, then kept |
| `@isSystemUpdateDate` | `CURRENT_TIMESTAMP` whenever the row is inserted, changed, or expired as an old SCD2 version |
| `@isSystemEndDate` | `'2999-12-31 00:00:00'` on the current row; the expiry time on an expired SCD2 row |

To use different values (e.g. `'Yes'`/`'No'` flags or another end-date sentinel), use `upsert` and compute them in the SELECT/CTE.

---

### Dimension Deployment

Every deployment of a Dimension Node first runs these checks before any change in BigQuery:

| **Stage** | **Description** |
|-----------|----------------|
| **Unsupported Materialization Type: \<node\>** | `@materializationType` is not `table` or `view` — stops the deployment and the run |
| **Warning: Duplicate Tags Found: \<node\>** | Non-failing — the same tag key applied more than once on the node; the last `@tag` for that key is applied |
| **Warning: Column Tags Ignored: \<node\>** | Non-failing — a `@tag` on a column is not applied, because BigQuery has no column-level tags |
| **Invalid configuration: tableExpiration** | `@tableExpiration` is a number of days, which is not supported — stops the deployment. Use a date / datetime (or an expression) |
| **Warning: tableExpiration Expression** | Non-failing — `@tableExpiration` is a SQL expression, not a fixed date / datetime: it is evaluated on every create or alter, so an expression on `CURRENT_TIMESTAMP()` moves the expiry forward each time |
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Missing Business Key \| Invalid configuration: … \| Missing Required System Columns \| Surrogate Key Not Set/Using Custom Surrogate Key Logic \| Invalid configuration: Surrogate Key \| Warning: Surrogate Key Default \| Warning: Zero Key Value Too Long \| Warning: Invalid configuration: mergeStrategy** | Dimension validation checks (table only), rendered only when the annotations have a problem — see [Dimension Load](#dimension-load). A required problem stops the deployment; a recommendation or a stage starting with **Warning:** does not. **Warning: Invalid configuration: mergeStrategy** flags an annotation the chosen strategy never reads (e.g. `@isChangeTracking` / `@lastModifiedTracking` under `upsert`) — it is ignored and the load continues. |
| **Invalid configuration: partitionBy \| partitionExpirationDays \| clusterKey** | Table only — see [Partitioning](#partitionby) and [Clustering](#clusterkey). |
| **Warning: partitionExpirationDays Ignored** | Non-failing, table only — `@partitionExpirationDays` on an integer-range (`RANGE_BUCKET`) partition is not applied |

#### Dimension Initial Deployment

When deployed for the first time into an Environment, the Dimension Node executes one of these stages, depending on its materialization type:

| **Stage** | **Description** |
|-----------|----------------|
| **Create Dimension Table** | Executes a CREATE OR REPLACE TABLE statement, with the surrogate key's `DEFAULT GENERATE_UUID()`, column descriptions, NOT NULL, defaults, primary key, PARTITION BY, CLUSTER BY and OPTIONS |
| **Create Dimension View** | Executes a CREATE OR REPLACE VIEW statement, with column descriptions and OPTIONS (description, expiration, tags) — see [Dimension View](#dimension-view) |

#### Dimension View

A Dimension Node of materialization type view is a plain `CREATE OR REPLACE VIEW` over the node's SELECT:

* None of the Dimension validation checks run — `@isBusinessKey`, system columns, `@id` and `@mergeStrategy` aren't required or checked.
* There is no merge; the run shows **Load Skipped for View**. `@mergeStrategy`, `@writeMode`, `@zeroKey`, `@preSQL`, `@postSQL` and the tracking annotations are ignored.
* Any system column (surrogate key, version, current flag, create/update/end date) is selected as a typed `NULL`, keeping the column's datatype.
* `@tag`, `@tableExpiration` and the description apply to the view; `@partitionBy`, `@partitionExpirationDays`, `@clusterKey`, `@primaryKey` and `@defaultRoundingMode` are ignored.
* Column-level data quality tests and node-level `@tests` still run.

#### Dimension Load

Every deployment of a Dimension Node of materialization type table runs its configured data quality tests, then merges data into the target using the stages below, depending on the resolved `@mergeStrategy` and SCD type:

| **Stage** | **Description** |
|-----------|----------------|
| **Pre Load Test `<n>`** | Node-level `@tests(..., "Before")` tests, in the order they appear. |
| **Validation checks** | The checks listed under [Dimension Deployment](#dimension-deployment), rendered only when the node's annotations have a problem. |
| **Check NULL values for `<column>` column** | Pre-load check for `@mergeStrategy("lastModified")` — flags a NULL `@lastModifiedTracking` value in the source. |
| **Pre-SQL `<n>`** | Each `@preSQL` statement, in the order they appear. |
| **Truncate table** | Executed only when `@writeMode("truncateInsert")` is set — clears the target before the merge. |
| **Load table Using Merge - Zero Key Record** | Executed only when node-level `@zeroKey` is set and a surrogate key column exists — merges the placeholder "zero key" row into the target. |
| **Load table Using Merge - Upsert** | Executed for `@mergeStrategy("upsert")` — every matched row is updated from the SELECT/CTE (system columns included, `@isSystemCreateDate` excepted) and every unmatched row is inserted. |
| **Load table Using Merge - Last Modified Comparison - SCD1 \| SCD2** | Executed for `@mergeStrategy("lastModified")` — compares the `@lastModifiedTracking` column against the target, then updates in place (SCD1) or versions the row (SCD2) per that column's `scdType`. |
| **Load table Using Merge - Change Tracking - SCD1 \| SCD2** | Executed for `@mergeStrategy("changeTracking")` (the default) — compares `@isChangeTracking` columns (or, absent any, every plain attribute column) against the target, then updates in place (SCD1) or versions the row (SCD2). |
| **Post-SQL `<n>`** | Each `@postSQL` statement, in the order they appear. |
| **`<column>: <test>` \| Post Load Test `<n>`** | Column-level data quality tests and node-level `@tests(..., "After")` tests, run after the load. |

#### Dimension Redeployment

Redeployment works exactly like the Work node — see [Altering the Work Tables](#altering-the-work-tables), [Recreating the Work Tables](#recreating-the-work-tables) and [Altering and Recreating the Work Views](#altering-and-recreating-the-work-views); the create stages read **Create Dimension Table** / **Create Dimension View**. A metadata update is recorded when only tests, `@writeMode`, `@mergeStrategy`, `@zeroKey`, `@preSQL`/`@postSQL` or a transform or join on a table changed.

> **Note:** Every Dimension column carries a required `@id`, so renaming a column (same `@id`) is a true RENAME COLUMN that keeps its data — except a case-only rename (e.g. `N_NAME` → `n_Name`), which currently fails with *"Column already exists"*; see [Column Name Case](#known-limitations).

### Removing a Dimension Node

If a Dimension Node is deleted from a SQL Workspace, that SQL Workspace is committed to Git and that commit deployed to a higher-level Environment, then the Dimension table or view in the target Environment will be dropped — the same stages as [Removing a Work Node](#removing-a-work-node).

---

## Fact

The Fact node is a specialized transformation node within Coalesce, used to materialize fact tables that hold measurable business events. It loads incoming source data into the target in one of three ways: a plain insert when neither `@mergeStrategy` nor a business key is set, an SCD Type 1 merge on the business key (`changeTracking` or `lastModified`), or a merge with no change detection (`upsert`, or `allColumnMatch`, which inserts only rows that don't already exist). Facts never keep versioned (SCD Type 2) history and have no surrogate key or zero key record. Like the other node types, it comes with a built-in library of column- and node-level data quality tests.

### Fact Node Configuration

The Fact Node type has three configuration groups:

* [General](#fact-general-options)
* [Node Annotations](#fact-node-annotations)
* [Column Annotations](#fact-column-annotations)

#### Fact General Options

| **Property** | **Description** |
|----------|-------------|
| **Storage Location** | Storage Location (BigQuery project and dataset) where the Fact table or view will be created |
| **Node Type** | Read-only: the node type's name and ID — **Fact** (`SQLFact`). Set from `@nodeType` when the node is created. |

### Fact Node Annotations

| **Annotation** | **Summary** |
|---|---|
| `@id(id)` ***(reserved)*** | Unique identifier for the node.<br/>Static and auto-generated when the node is created — not meant to be edited. |
| `@nodeType(type)` ***(reserved)*** | Identifies the node's type.<br/>Set automatically based on the node type chosen when the node is created. |
| `@description(text)` ***(reserved)*** | Node-level description.<br/>Can be edited via this annotation or in the node description field below the node name in the UI.<br/>Example: `@description("Table description")` |
| [`@materializationType(type)`](#materializationtype) ***(reserved)*** | `table` or `view` |
| `@deployDisabled` ***(reserved)*** | Excludes this node from deployment. |
| [`@partitionBy(expression)`](#partitionby) | Partitions the table by a column or expression. |
| [`@partitionExpirationDays(days)`](#partitionexpirationdays) | Days each partition is kept before BigQuery deletes it. |
| [`@tableExpiration(value)`](#tableexpiration) | When BigQuery deletes the table or view. |
| [`@defaultRoundingMode(mode)`](#defaultroundingmode) | Rounding mode for NUMERIC/BIGNUMERIC values written to the table. |
| [`@tag(tagName, tagValue)`](#tag) ***(repeatable)*** | Applies a Resource Manager tag to this table or view. |
| [`@writeMode("truncateInsert \| append")`](#writemode) | How each run writes to the target: truncateInsert or append<br/>*Not specified in the SQL editor → defaults to **append**.* |
| [`@mergeStrategy("changeTracking \| lastModified \| upsert \| allColumnMatch")`](#mergestrategy-fact) | Chooses how rows are matched against the target, and therefore which column annotations are required. |
| [`@disableTests`](#disabletests) **²** | Controls whether configured tests are skipped. |
| [`@tests(querySQL, continueOnFailure?, runOrder?)`](#tests) **²** ***(repeatable)*** | Node-level data quality test. |
| [`@preSQL(querySQL)`](#presql) ***(repeatable)*** | SQL statement to execute `before` the data load operation. |
| [`@postSQL(querySQL)`](#postsql) ***(repeatable)*** | SQL statement to execute `after` the data load operation. |

### Fact Column Annotations

| **Annotation** | **Summary** |
|---|---|
| [`@id("<value>")`](#id-column) | Stable column ID for lineage tracking. |
| `@notNull` ***(reserved)*** | Marks column as NOT NULL.<br/>**Note:** Ignored on Views.<br/>Example: `@notNull` |
| `@description(<text>)` ***(reserved)*** | Adds column description.<br/>Example: `@description("timestamp column")` |
| [`@defaultValue(<value>)`](#defaultvalue) ***(reserved)*** | Adds default value. |
| [`@partitionBy`](#partitionby) | Partitions the table by this column (a bare flag, no parameters). |
| [`@clusterKey(position)`](#clusterkey) | Marks a column as part of the table's CLUSTER BY key, in the order given by **position** (lowest first). |
| [`@primaryKey(position)`](#primarykey) | Marks a column as part of the table's (unenforced) primary key. |
| [`@inHash("<hashName>", <hashOrder>)`](#inhash) **¹** ***(repeatable)*** | Marks a column as an input to a generated hash key. |
| [`@isBusinessKey`](#isbusinesskey-fact) | Marks a column as part of the business key used to match existing rows during the merge. |
| [`@lastModifiedTracking`](#lastmodifiedtracking) | Marks the column used to detect newer source rows for an incremental load (SCD Type 1). |
| [`@isSystemCreateDate`](#issystemcreatedate) | Marks this column as the timestamp a row was first created. |
| [`@isSystemUpdateDate`](#issystemupdatedate) | Marks this column as the timestamp a row was last updated. |

> Shared annotations link to the [Annotation Reference](#annotation-reference); the Fact-specific ones are described in [Fact Annotation Details](#fact-annotation-details).

>**Note:** Quoting matters when writing `@tests`, `@preSQL`, and `@postSQL` — see [Quoting Inside Annotations](#quoting-inside-annotations).

🚦 The full set of column-level data quality tests (`@not_null`, `@uniqueness`, `@empty`, `@accepted_values`, `@rejected_values`, `@min_max`, `@min_value`, `@max_value`, `@freshness`, `@relative_time`) applies to Fact columns exactly as described in [Column-Level Data Quality Tests](#column-level-data-quality-tests).

### Fact Annotation Details

##### `@mergeStrategy` (Fact)

`@mergeStrategy("changeTracking | lastModified | upsert | allColumnMatch")`

Chooses how rows are matched against the target, and therefore which column annotations are required.

| **Value** | **Description** |
|---|---|
| `changeTracking` | SCD Type 1. Compares every plain attribute column against the target; a changed row is overwritten in place, a new key is inserted. Doesn't use `@lastModifiedTracking` — if present, a warning is raised and it's ignored. |
| `lastModified` | SCD Type 1. Compares a single `@lastModifiedTracking` column against the target's stored value; a newer value overwrites the row in place. Requires exactly one column marked `@lastModifiedTracking` — a validation check flags it if none (or more than one) is present. |
| `upsert` | No change detection at all; a matched row is always updated, an unmatched row is inserted. The SELECT/CTE should return one row per business key (de-duplicate upstream). System columns are optional; any that are present are written exactly as the SELECT/CTE computes them. `@lastModifiedTracking` isn't used — if present, a warning is raised and it's ignored. |
| `allColumnMatch` | Treats every non-system column as the business key: a source row is inserted only if no target row matches it on all of those columns, and an existing matching row is never updated. `@isBusinessKey` isn't needed — if present, a warning is raised, it's ignored and all columns are used for the comparison. `@lastModifiedTracking` isn't used either — a warning is raised and it's ignored. System columns are optional, are left out of the comparison, and are written exactly as the SELECT/CTE computes them. |

* *Not specified in the SQL editor → defaults to **changeTracking** - SCD Type 1 when a column is marked `@isBusinessKey`, otherwise the node is loaded as a [plain insert](#fact-load-behaviour).*
* The value is not case-sensitive; any other value is flagged by a validation check.
* When set, `@mergeStrategy` always takes priority: `changeTracking`, `lastModified` and `upsert` merge on the business key, so without an `@isBusinessKey` column a validation check fails and the load stops. `allColumnMatch` needs no `@isBusinessKey`.
* **Note:** Ignored on Views.

**Example:**

```sql
@mergeStrategy("allColumnMatch")
```

##### `@isBusinessKey` (Fact)

`@isBusinessKey`

Marks a column as part of the business key used to match existing rows during the merge.

* Optional when `@mergeStrategy` isn't set — if no column is marked, there is no merge and every source row is simply inserted.
* Required for an explicit `changeTracking`, `lastModified` or `upsert` — without it the load stops with a validation error.
* Ignored under `@mergeStrategy("allColumnMatch")`, which uses every non-system column as the key (a warning is raised).
* **Note:** Ignored on Views.

**Example:**

```sql
@isBusinessKey
```

---

### Fact Load Behaviour

How a Fact table is loaded depends on `@mergeStrategy` and on whether any column is marked `@isBusinessKey`:

| `@isBusinessKey` | `@mergeStrategy` | Load |
|---|---|---|
| none | not set | Plain insert (default without a business key) |
| none | `changeTracking` / `lastModified` / `upsert` | ❌ Validation error — the load stops |
| marked | not set, or `changeTracking` | SCD1 merge on the business key (default with a business key) |
| marked | `lastModified` | SCD1 merge on the business key |
| marked | `upsert` | Merge on the business key |
| any (ignored, warning if marked) | `allColumnMatch` | Merge on every non-system column |

Requirement level of each column annotation, by load:

| Annotation | `changeTracking` / `lastModified` | `upsert` | `allColumnMatch` | Plain insert |
|---|:---:|:---:|:---:|:---:|
| `@isBusinessKey` | 🔴 | 🔴 | ⚪¹ | — |
| `@lastModifiedTracking` | 🔴<br/>for `lastModified` only | — | — | — |
| `@isSystemCreateDate` | 🔴 | ⚪ | 🟡 | 🟡 |
| `@isSystemUpdateDate` | 🔴 | ⚪ | ⚪ | ⚪ |

**Legend:** 🔴 Required · 🟡 Recommended · ⚪ Optional · — Not used

* ¹ Ignored if present — every non-system column is used as the business key and a warning is raised.
* `allColumnMatch` is meant for **factless fact tables** (no measures — the row itself is the fact), used for event tracking and coverage/relationship tracking. See [Fact All Column Match](#fact-all-column-match).
* Under `changeTracking` / `lastModified` the load writes fixed values into the system columns: `@isSystemCreateDate` gets `CURRENT_TIMESTAMP` on first insert and is then kept; `@isSystemUpdateDate` gets `CURRENT_TIMESTAMP` whenever the row is inserted or changed. The expression the SELECT gives them is only used to derive the column's datatype.
* Under `upsert`, `allColumnMatch` and plain insert, system columns are written exactly as the SELECT/CTE computes them. `@isSystemCreateDate` keeps its first-inserted value on an `upsert` update.
* Business key matching (including every column under `allColumnMatch`) uses plain equality, so a NULL never matches — see [Duplicate or NULL Business Keys](#known-limitations).

---

### Fact Deployment

Every deployment of a Fact Node first runs these checks before any change in BigQuery:

| **Stage** | **Description** |
|-----------|----------------|
| **Unsupported Materialization Type: \<node\>** | `@materializationType` is not `table` or `view` — stops the deployment and the run |
| **Warning: Duplicate Tags Found: \<node\>** | Non-failing — the same tag key applied more than once on the node; the last `@tag` for that key is applied |
| **Warning: Column Tags Ignored: \<node\>** | Non-failing — a `@tag` on a column is not applied, because BigQuery has no column-level tags |
| **Invalid configuration: tableExpiration** | `@tableExpiration` is a number of days, which is not supported — stops the deployment. Use a date / datetime (or an expression) |
| **Warning: tableExpiration Expression** | Non-failing — `@tableExpiration` is a SQL expression, not a fixed date / datetime: it is evaluated on every create or alter, so an expression on `CURRENT_TIMESTAMP()` moves the expiry forward each time |
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Invalid configuration: No Business Key \| Invalid configuration: … \| Missing Required System Columns \| Warning: Invalid configuration: mergeStrategy \| Warning: Invalid configuration: No Business Key** | Fact validation checks (table only), rendered only when the annotations have a problem. A required problem stops the deployment; a stage starting with **Warning:** does not. **Warning: Invalid configuration: mergeStrategy** flags an annotation the chosen strategy never reads (`@isBusinessKey` under `allColumnMatch`, `@lastModifiedTracking` under `changeTracking` / `upsert` / `allColumnMatch`); **Warning: Invalid configuration: No Business Key** flags `@lastModifiedTracking` on a plain-insert node. Both are ignored and the load continues. |
| **Invalid configuration: partitionBy \| partitionExpirationDays \| clusterKey** | Table only — see [Partitioning](#partitionby) and [Clustering](#clusterkey). |
| **Warning: partitionExpirationDays Ignored** | Non-failing, table only — `@partitionExpirationDays` on an integer-range (`RANGE_BUCKET`) partition is not applied |

#### Fact Initial Deployment

| **Stage** | **Description** |
|-----------|----------------|
| **Create Fact Table** | Executes a CREATE OR REPLACE TABLE statement, with column descriptions, NOT NULL, defaults, primary key, PARTITION BY, CLUSTER BY and OPTIONS |
| **Create Fact View** | Executes a CREATE OR REPLACE VIEW statement, with column descriptions and OPTIONS (description, expiration, tags) — see [Fact View](#fact-view) |

#### Fact View

A Fact Node of materialization type view is a plain `CREATE OR REPLACE VIEW` over the node's SELECT:

* None of the Fact validation checks run — `@isBusinessKey`, system columns, `@id` and `@mergeStrategy` aren't required or checked.
* There is no load; the run shows **Load Skipped for View**. `@mergeStrategy`, `@writeMode`, `@preSQL`, `@postSQL` and `@lastModifiedTracking` are ignored.
* `@isSystemCreateDate` / `@isSystemUpdateDate` columns are selected as a typed `NULL`, keeping the column's datatype.
* `@tag`, `@tableExpiration` and the description apply to the view; `@partitionBy`, `@partitionExpirationDays`, `@clusterKey`, `@primaryKey` and `@defaultRoundingMode` are ignored.
* Column-level data quality tests and node-level `@tests` still run.

#### Fact Load

| **Stage** | **Description** |
|-----------|----------------|
| **Pre Load Test `<n>`** | Node-level `@tests(..., "Before")` tests, in the order they appear. |
| **Validation checks** | The checks listed under [Fact Deployment](#fact-deployment), rendered only when the node's annotations have a problem. |
| **Check NULL values for `<column>` column** | Pre-load check for `@mergeStrategy("lastModified")` — flags a NULL `@lastModifiedTracking` value in the source. |
| **Pre-SQL `<n>`** | Each `@preSQL` statement, in the order they appear. |
| **Truncate table** | Executed only when `@writeMode("truncateInsert")` is set — clears the target before the load. |
| **Load table using Insert** | Executed when no `@mergeStrategy` is set and no column is marked `@isBusinessKey` — inserts every source row with `INSERT INTO … SELECT`. |
| **Load table Using Merge - Change Tracking - SCD1** | Executed for `@mergeStrategy("changeTracking")`, and by default when no `@mergeStrategy` is set and a column is marked `@isBusinessKey`. |
| **Load table Using Merge - Last Modified Comparison - SCD1** | Executed for `@mergeStrategy("lastModified")`. |
| **Load table Using Merge - Upsert** | Executed for `@mergeStrategy("upsert")`. |
| **Load table Using Merge - All Column Match** | Executed for `@mergeStrategy("allColumnMatch")` — matches on every non-system column and inserts only rows that don't already exist; nothing is updated. |
| **Post-SQL `<n>`** | Each `@postSQL` statement, in the order they appear. |
| **`<column>: <test>` \| Post Load Test `<n>`** | Column-level data quality tests and node-level `@tests(..., "After")` tests, run after the load. |

#### Fact Redeployment

Redeployment works exactly like the Work node — see [Altering the Work Tables](#altering-the-work-tables), [Recreating the Work Tables](#recreating-the-work-tables) and [Altering and Recreating the Work Views](#altering-and-recreating-the-work-views); the create stages read **Create Fact Table** / **Create Fact View**.

> **Note:** Every Fact column carries a required `@id`, so renaming a column (same `@id`) is a true RENAME COLUMN that keeps its data — except a case-only rename (e.g. `N_NAME` → `n_Name`), which currently fails with *"Column already exists"*; see [Column Name Case](#known-limitations).

### Removing a Fact Node

If a Fact Node is deleted from a SQL Workspace, that SQL Workspace is committed to Git and that commit deployed to a higher-level Environment, then the Fact table or view in the target Environment will be dropped — the same stages as [Removing a Work Node](#removing-a-work-node).

---

## Common Reference

Concepts and reusable building blocks that apply across every node type in this package.

### Annotation Reference

Annotations shared by Work, Dimension and Fact, described once. Where a node type behaves differently, its variant is shown under its own label.

#### Node Annotations

##### `@materializationType`

`@materializationType(type)` ***(reserved)***

| **Value** | **Description** |
|---|---|
| `table` | Table (default). |
| `view` | View. |

* BigQuery has no transient table — any value other than `table` or `view` stops the deploy and the run with an **Unsupported Materialization Type** check.
* *Not specified in the SQL editor → defaults to **table**.*

**Example:**

```sql
@materializationType("view")
```

##### `@partitionBy`

A BigQuery table has **one** partition. Set it **once**, either on the node or on one column — not both:

| **Level** | **Syntax** | **Use** |
|---|---|---|
| Node | `@partitionBy("<column or expression>")` | A column name or any partition expression, written into `PARTITION BY` as-is. |
| Column | `@partitionBy` | A bare flag on the column the table is partitioned by — no parameters, no expression. |

**Node-level** — a column name or an expression:

| **Partition kind** | **Example** |
|---|---|
| Ingestion time | `@partitionBy("_PARTITIONDATE")` (daily), `@partitionBy("TIMESTAMP_TRUNC(_PARTITIONTIME, MONTH)")` (also `HOUR` / `DAY` / `YEAR`) |
| DATE column | `@partitionBy("ORDER_DATE")`, `@partitionBy("DATE_TRUNC(ORDER_DATE, MONTH)")` (also `YEAR`) |
| TIMESTAMP column | `@partitionBy("DATE(LOADED_AT)")`, `@partitionBy("TIMESTAMP_TRUNC(LOADED_AT, HOUR)")` (also `DAY` / `MONTH` / `YEAR`) |
| DATETIME column | `@partitionBy("DATE(LOADED_DT)")`, `@partitionBy("DATETIME_TRUNC(LOADED_DT, MONTH)")` (also `HOUR` / `DAY` / `YEAR`) |
| INT64 column (integer range) | `@partitionBy("RANGE_BUCKET(N_NATIONKEY, GENERATE_ARRAY(0, 100, 5))")` |

BigQuery accepts only these forms, and the deployment does not check the expression itself — any other form fails at create with BigQuery's *"PARTITION BY expression must be …"* error. Forms that look valid but are **rejected**:

| ❌ Rejected | ✅ Use instead |
|---|---|
| `DATE_TRUNC(DATE(LOADED_AT), MONTH)` — a function wrapped around another | `TIMESTAMP_TRUNC(LOADED_AT, MONTH)` |
| `DATE_TRUNC(_PARTITIONDATE, MONTH)` | `TIMESTAMP_TRUNC(_PARTITIONTIME, MONTH)` |
| `_PARTITIONTIME` | `_PARTITIONDATE` or `DATE(_PARTITIONTIME)` |
| A bare TIMESTAMP or DATETIME column, e.g. `LOADED_AT` | `DATE(LOADED_AT)` — or the column-level `@partitionBy`, which adds the `DATE(...)` |

* `DATE_TRUNC(_PARTITIONTIME, MONTH)` is also accepted; BigQuery stores it as `TIMESTAMP_TRUNC(_PARTITIONTIME, MONTH)`.
* `TIMESTAMP_TRUNC(<column>, DAY)` is stored by BigQuery as `DATE(<column>)`.

**Column-level** — a bare `@partitionBy` on the column:

* A `DATE` column is used as-is (`` PARTITION BY `ORDER_DATE` ``); a `TIMESTAMP` or `DATETIME` column is partitioned by day (`` PARTITION BY DATE(`LOADED_AT`) ``).
* It takes **no parameters** — for an expression (`DATE_TRUNC`, `TIMESTAMP_TRUNC`, `RANGE_BUCKET`, ingestion time), use the node-level annotation.

**Validation** — **Invalid configuration: partitionBy** stops the deployment when:

* `@partitionBy` is set on both the node and a column, or on more than one column, or one expression lists several columns (`"A, B"`).
* A column-level `@partitionBy` has parameters.
* A column-level `@partitionBy` is on a column that is not `DATE`, `TIMESTAMP` or `DATETIME`. BigQuery cannot partition by STRING, NUMERIC, FLOAT64, BOOL or BYTES; an INT64 column needs the node-level `RANGE_BUCKET(...)`.

* ⚠️ On redeployment, a partition change **drops and recreates the table** — see [Recreating the Work Tables](#recreating-the-work-tables).
* **Note:** Ignored on Views.

**Example:**

```sql
-- node level: a column name or an expression
@partitionBy("DATE_TRUNC(ORDER_DATE, MONTH)")
-- column level: a bare flag on the column
CAST(`LOADED_AT` AS DATE) AS `LOAD_DATE` @partitionBy
```

##### `@partitionExpirationDays`

`@partitionExpirationDays("<days>")`

Number of days to keep each partition before BigQuery deletes it.

* Requires a partition (`@partitionBy` on the node or on a column) — without one the deployment stops with **Invalid configuration: partitionExpirationDays**.
* Applies only to time partitions. On an integer-range (`RANGE_BUCKET`) partition it is not applied and the non-failing **Warning: partitionExpirationDays Ignored** is raised; the deployment continues.
* ⚠️ **Avoid it on a Dimension.** BigQuery deletes a whole partition once its partition date is older than the given days, whatever the rows in it. A Dimension row that is still current but hasn't changed for that long sits in an old partition and is deleted with it — under SCD Type 2 this can delete the active version of a key, leaving the key with no current row. It is safe only when every row is reloaded or rewritten within the window. See [Partition Expiration on a Dimension](#known-limitations).
* **Note:** Ignored on Views.

**Example:**

```sql
@partitionExpirationDays("365")
```

##### `@tableExpiration`

`@tableExpiration("<value>")`

Sets when BigQuery deletes the target table or view.

| **Value** | **Result** |
|-----------|------------|
| **A date** — `"2999-12-31"` | Expires at 23:59:59 that day → `TIMESTAMP "2999-12-31 23:59:59"` |
| **A datetime** — `"2999-12-31 00:00:00"` | Expires at that fixed point → `TIMESTAMP "2999-12-31 00:00:00"` |
| **A SQL expression** — `"TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)"` | Used as-is, with the non-failing **Warning: tableExpiration Expression** (see below) |
| **A number of days** — `"30"` | ❌ Not supported — stops the deploy with **Invalid configuration: tableExpiration**. Write the expression above instead |

* A date / datetime is a **fixed** expiry: it does not move on redeploy.
* An expression is **evaluated each time the table is created or replaced** — on the first create, on a recreate (partition / cluster change), and on every alter, which rebuilds the table through a copy and re-applies the expiration. An expression on `CURRENT_TIMESTAMP()` therefore **moves the expiry forward on every such redeploy**; a redeploy that changes nothing on the table leaves it as it is.
* Applies to tables and views.

**Example:**

```sql
@tableExpiration("2999-12-31")
@tableExpiration("2999-12-31 00:00:00")
@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")   -- warns: moves forward on every create / alter
```

##### `@defaultRoundingMode`

`@defaultRoundingMode("ROUND_HALF_AWAY_FROM_ZERO | ROUND_HALF_EVEN")`

Sets the table's `default_rounding_mode`, used when values are written to NUMERIC / BIGNUMERIC columns.

* **Note:** Table only — ignored on Views.

**Example:**

```sql
@defaultRoundingMode("ROUND_HALF_EVEN")
```

##### `@tag`

`@tag("<tagName>", "<tagValue>")`

***(repeatable)*** Applies a Resource Manager tag to this table or view through its `OPTIONS(tags = [...])`.

| **Parameter** | **Description** |
|---|---|
| **tagName** | Short name of the tag key. Qualified with the project of this node's own location (`<project-id>/<tagName>`); a name that already contains `/` (a key from another project, or an org-level key such as `123456789/env`) is used as-is. |
| **tagValue** | Short name of an existing value of that tag key. |

* **Prerequisite:** the tag key and value must already exist in GCP, and the deploying account needs permission to bind them.
* A table or view holds **one value per tag key**. When the same key is applied more than once — even with different values, or written once as `env` and once as `<project>/env` — the **last** `@tag` for that key is applied, the earlier ones are ignored, and the non-failing **Warning: Duplicate Tags Found** lists each repeated key with the value applied. The deployment continues.
* BigQuery has **no column-level tags** — a `@tag` on a column is not applied and raises the non-failing **Warning: Column Tags Ignored**; the deployment continues. Move the tag to the node to tag the whole table (column-level access control in BigQuery uses Data Catalog policy tags instead).
* On a table, tag changes are applied with **Edit Table Options**; on a view, with **Edit View Options** (only the changed options are sent).

**Example:**

```sql
@tag("env", "dev")
@tag("cost_center", "finance")
```

##### `@writeMode`

`@writeMode("truncateInsert | append")`

* **Note:** Ignored on Views.

**Work:**

| **Value** | **Description** |
|---|---|
| `truncateInsert` | Clears the table (**Truncate table** stage) and then inserts the new rows (`INSERT INTO … SELECT`), replacing its contents entirely. |
| `append` | Inserts the new rows via `INSERT INTO`, alongside whatever is already there. |

* *Not specified in the SQL editor → defaults to **truncateInsert**.*

**Example:**

```sql
@writeMode("append")
```

**Dimension / Fact:**

| **Value** | **Description** |
|---|---|
| `truncateInsert` | Clears the table before loading, replacing its contents entirely. |
| `append` | **Dimension:** Inserts the new rows via merge, alongside whatever is already there.<br/>**Fact:** Loads the new rows alongside whatever is already there. |

* *Not specified in the SQL editor → defaults to **append**.*

**Example:**

```sql
@writeMode("truncateInsert")
```

##### `@disableTests`

`@disableTests`**²**

Controls whether configured tests are skipped.

* *Specified in the SQL editor → all node- and column-level tests are skipped.*
* *Not specified in the SQL editor → tests run normally.*
* To turn tests back on, remove the annotation. Useful while developing a node — iterate on the SQL first, then re-enable once the logic is settled.

**Example:**

```sql
@disableTests
```

##### `@tests`

`@tests(querySQL, continueOnFailure?, runOrder?)`**²**

***(repeatable)*** Node-level data quality test.

**²** Node level tests are performed only when `disableTests` is OFF.

```text
@tests("<querySQL>", <continueOnFailure>, "<runOrder>")
```

| Parameter | Description |
|-----------|-------------|
| querySQL | SQL statement to execute as a validation test. The test fails if the query returns any records. |
| continueOnFailure | **(optional)** `true` (default) or `false`. Marks whether the run is meant to continue when the test fails. |
| runOrder | **(optional)** `Before` or `After` (default). Determines whether the test is executed before or after the load operation. |

**Example:**

```sql
@tests("SELECT 1 FROM {{ this }} GROUP BY N_NATIONKEY HAVING COUNT(*) > 1", false, "After")  -- runs After the load, continueOnFailure=false
```

**More examples:**

```text
@tests("SELECT 1 FROM {{ this }} GROUP BY N_COMMENT HAVING COUNT(*) > 1", true, "Before")  -- runs Before the load, continueOnFailure=true
@tests("SELECT 1 FROM {{ this }} GROUP BY N_COMMENT HAVING COUNT(*) > 1", false)  -- runs After the load (default), continueOnFailure=false
@tests("SELECT 1 FROM {{ this }} GROUP BY N_COMMENT HAVING COUNT(*) > 1")  -- runs After the load (default), continueOnFailure=true (default)
```

##### `@preSQL`

`@preSQL(querySQL)`

***(repeatable)*** SQL statement to execute `before` the data load operation.

* Repeat the annotation to run multiple statements, in the order they appear.
* **Note:** Ignored on Views.

**Example:**

```sql
@preSQL("DELETE FROM {{ this }} WHERE N_LOAD_DATE < DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)")
```

##### `@postSQL`

`@postSQL(querySQL)`

***(repeatable)*** SQL statement to execute `after` the data load operation.

* Repeat the annotation to run multiple statements, in the order they appear.
* **Note:** Ignored on Views.

**Example:**

```sql
@postSQL("INSERT INTO {{ ref('AUDIT', 'LOAD_LOG') }} (TABLE_NAME, LOAD_TS) VALUES ('WRK_NATION', CURRENT_TIMESTAMP())")
```

#### Column Annotations

##### `@id` (column)

`@id("<value>")`

Stable column ID for lineage tracking.

| **Parameter** | **Description** |
|---|---|
| **value** | Six hexadecimal digits, unique within the node, e.g. `110e75`. |

* Required on every Dimension and Fact column — the SQL editor generates a fresh `@id("<value>")` for each column it creates, and a validation check flags any column that is missing one.
* Not for manual editing — value is a stable identifier generated once at creation time.
* **Column added later:** give it its own new, unique 6-hex-digit `@id`. A repeated value fails the **Duplicate Column IDs** check.
* **Duplicate column names:** if the SELECT returns the same column name twice, Coalesce renames the extra copy (`SYSTEM_CREATE_DATE` → `SYSTEM_CREATE_DATE1`) and drops its `@id`; this is reported by the **Duplicate Column Names** check rather than as a missing ID.

**Example:**

```sql
@id("110e75")
```

##### `@defaultValue`

`@defaultValue(<value>)` ***(reserved)***

Adds a column DEFAULT.

* Quote to match the column's data type — number: `@defaultValue("<num>")`, string: `@defaultValue("'<string>'")`, function: `@defaultValue("GENERATE_UUID()")`.
* A BigQuery default **cannot reference other columns** — the create fails with "Default value expressions cannot reference columns".
* A column added on redeploy gets its default afterwards (**Set Default**). **Existing rows are not backfilled** — they keep NULL in the new column; the default applies to rows inserted from then on. Fill them yourself if needed (e.g. a one-off `@postSQL` UPDATE, or a reload with `@writeMode("truncateInsert")`).
* **Note:** Ignored on Views.

**Example:**

```sql
@defaultValue("20")
@defaultValue("'NA'")
```

##### `@clusterKey`

`@clusterKey(position)`

Marks a column as part of the table's `CLUSTER BY` key, in the order given by **position** (lowest first).

* BigQuery clusters on **at most 4 columns** — more stops the deploy with **Invalid configuration: clusterKey**.
* **Plain columns only** — an expression passed as a second parameter (e.g. `@clusterKey(1, "UPPER(NAME)")`) stops the deploy. Compute the expression as its own column in the SELECT and cluster on that.
* Clustering columns must be top-level, non-repeated columns of type STRING, INT64, NUMERIC, BIGNUMERIC, DATE, DATETIME, TIMESTAMP, BOOL, GEOGRAPHY or RANGE. The deployment does not check the type — BigQuery rejects any other type (for example FLOAT64, BYTES, JSON, ARRAY or STRUCT) when the table is created.
* ⚠️ On redeployment, a cluster key change **drops and recreates the table**.
* **Note:** Ignored on Views.

**Example:**

```sql
@clusterKey(1)
@clusterKey(2)
```

##### `@primaryKey`

`@primaryKey(position)`

Marks a column as part of the table's primary key, at the given position (lowest first). Mark every key column to build a composite key.

* BigQuery primary keys are **never enforced** — `NOT ENFORCED` is always added. Pair the key with `@uniqueness` / `@not_null` tests to check it.
* A key change is applied on the clone (**Drop Primary Key** / **Add Primary Key**).
* **Note:** Ignored on Views.

**Example:**

```sql
@primaryKey(1)
@primaryKey(2)
```

##### `@inHash`

`@inHash("<hashName>", <hashOrder>)`**¹**

***(repeatable)*** Marks a column as an input to a generated hash key.

| **Parameter** | **Description** |
|---|---|
| **hashName** | Columns sharing the same value are grouped together into the same hash. |
| **hashOrder** | This column's position within that group. |

* Call `get_hash("<hashName>")` elsewhere in the SELECT to produce the hash column from the marked columns.

**Example:**

```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
CAST({{ get_hash('GH_COL') }} AS STRING) AS `GH_COL`
```


**`get_hash()` macro**

**¹** The hash transformation uses the reusable `get_hash()` macro:

```SQL
{{ get_hash("<hash_name>", "<algo>", "<delimiter>") }}
```

| Parameter | Description |
|-----------|-------------|
| `hash_name` | Hash name used across columns to identify the columns included in the hash. |
| `algo` | **(optional)** Hashing algorithm to use. Supported values are `SHA1`, `SHA256`, `SHA512` and `MD5`. Defaults to `SHA1`. |
| `delimiter` | **(optional)** Delimiter used to separate column values when generating the hash. Defaults to `||` and can be customized. |

* The columns are cast to STRING, a NULL becomes `'null'`, they are joined in `hashOrder` with the delimiter, hashed, and returned as a hex STRING (`TO_HEX(...)`).
* **Wrap the call in `CAST(... AS STRING)`.** The SQL parser can't infer a datatype through the macro, so a bare `{{ get_hash(...) }}` column resolves to `UNKNOWN` and fails at create.
* `algo` is not case-sensitive (`'md5'` = `'MD5'`); only `SHA1`, `SHA256`, `SHA512` and `MD5` are valid. `delimiter=''` joins the values with no delimiter.
* When no column is marked with the hash name, `get_hash()` returns `NULL`.

**`get_hash()` examples:**

Using hash macro(default-SHA1)
```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
CAST({{ get_hash('GH_COL') }} AS STRING) AS `GH_COL`
```
Using hash macro(MD5)
```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
CAST({{ get_hash('GH_COL', 'MD5') }} AS STRING) AS `GH_COL`
```
Using hash macro(SHA256)
```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
CAST({{ get_hash('GH_COL', 'SHA256') }} AS STRING) AS `GH_COL`
```
Using hash macro(algo=SHA256, delimiter='~' )
```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
CAST({{ get_hash('GH_COL', algo='SHA256', delimiter='~') }} AS STRING) AS `GH_COL`
```
Using hash macro(SHA512, no delimiter)
```sql
<col_name1> AS <col_name1> @inHash("GH_COL", 1),
<col_name2> AS <col_name2> @inHash("GH_COL", 2),
CAST({{ get_hash('GH_COL', 'SHA512', '') }} AS STRING) AS `GH_COL`
```
Using multiple keys hash macro
```sql
<col_name1> AS <col_name1> @inHash("GH_COL", 1),
<col_name2> AS <col_name2> @inHash("GH_COL", 2),
CAST({{ get_hash('GH_COL') }} AS STRING) AS `GH_COL_COMBINED`
```
Using multiple hash macros
```sql
<col_name1> AS <col_name1> @inHash("GH_COL1", 1) @inHash("GH_COL2", 2),
<col_name2> AS <col_name2> @inHash("GH_COL1", 2),
<col_name3> AS <col_name3> @inHash("GH_COL2", 1),
CAST({{ get_hash('GH_COL1') }} AS STRING) AS `GH_COL_COMBINED1`,
CAST({{ get_hash('GH_COL2', delimiter='~') }} AS STRING) AS `GH_COL_COMBINED2`
```
Using explicit expression:
```sql
TO_HEX(
  SHA1(
    IFNULL(CAST(<col_name> AS STRING), 'null')
  )
) AS `GH_Key`
```

##### `@lastModifiedTracking`

Dimension: `@lastModifiedTracking(scdType?)` · Fact: `@lastModifiedTracking`

Marks the column used to detect newer source rows for an incremental load.

* Datatype — DATE/DATETIME/TIMESTAMP or any incrementing numeric type.
* Can only be applied to one column.
* Must not be NULL in the source — a pre-load check flags it, since a NULL value can never compare as newer.
* **Note:** Ignored on Views.

**Dimension:**

* Only this column decides a change — other columns that change without a newer tracking value are never applied, even under SCD Type 1.

| **Parameter** | **Description** |
|---|---|
| **scdType** | **(optional)** `1` overwrites the row in place, `2` expires the row and inserts a new version. *Not specified → defaults to 1.* |

**Fact:**

* Only this column decides a change. Used only by `@mergeStrategy("lastModified")` (SCD Type 1).

**Example:**

```sql
-- Dimension
@lastModifiedTracking(2)
-- Fact
@lastModifiedTracking
```

##### `@isSystemCreateDate`

`@isSystemCreateDate`

Marks this column as the timestamp a row was first created.

* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: ``CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @isSystemCreateDate``

**Dimension:** required unless `@mergeStrategy` is `upsert` — under `changeTracking`/`lastModified` it's read back from the target and preserved unchanged on every row after its initial insert.

**Fact:**

* Required for `changeTracking`/`lastModified` — read back from the target and preserved unchanged on every row after its initial insert.
* Recommended for `allColumnMatch` and plain insert — rows are only ever inserted, so it's the record of when each row was loaded; it is written exactly as the SELECT/CTE computes it.
* Optional for `upsert` — if kept, it is written from the SELECT/CTE on insert and never overwritten on update.

##### `@isSystemUpdateDate`

`@isSystemUpdateDate`

Marks this column as the timestamp a row was last updated.

* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: ``CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @isSystemUpdateDate``

**Dimension:** required for SCD Type 1 and Type 2 — recomputed to the current timestamp on every inserted, changed or expired row. Optional for `upsert`.

**Fact:** required for `changeTracking`/`lastModified`; optional for `upsert`, `allColumnMatch` and plain insert.

### Quoting Inside Annotations

Raw SQL pasted into `@tests`, `@preSQL` and `@postSQL` is wrapped in the annotation's `"..."` double quotes. BigQuery quotes identifiers with backticks, not double quotes, so the two never clash:

* Use backticks for identifiers (`` `N_NAME` ``) and single quotes for string literals (`'F'`), exactly as in BigQuery SQL.
* BigQuery column names are case-insensitive, so the column's case does not have to match.
* Quote every annotation argument — an unquoted value (e.g. `@partitionExpirationDays(30)`) is dropped by the loader.

```text
@tests("SELECT 1 FROM {{ this }} WHERE `N_NAME` = 'UNKNOWN'", false, "After")
@preSQL("DELETE FROM {{ this }} WHERE `O_ORDERSTATUS` = 'F'")
```

### Column-Level Data Quality Tests

🚦 Applicable only when `@disableTests` is not set. Each runs **After** the load and continues the run on failure. *Not specified in the SQL editor → test is off.*

| **Property** | **Description** |
|---------|-------------|
| `@not_null` | Fails on rows where the column is NULL.<br/>Example: `@not_null` |
| `@uniqueness` | Fails when a value appears on more than one row.<br/>Example: `@uniqueness` |
| `@empty` | Fails on rows where the column trims to the empty string.<br/>NULL values pass this test — they're caught by `@not_null` instead.<br/>Example: `@empty` |
| `@accepted_values("<value>", ...)` | Fails on rows whose value is outside the allow list. NULL values pass.<br/>Repeatable — every occurrence on the column is merged into one list. Each call takes one value or a comma-separated list —<br/>`accepted_values("1, 3, 5")`<br/>`accepted_values("1") accepted_values("3, 5")`<br/>Each value is pasted into the SQL verbatim, so write it as a valid SQL value for the column's data type —<br/>numeric: with or without double quotes<br/>string: single quotes inside double quotes, `"'<string>'"`<br/>boolean: `true`/`false`, with or without double quotes<br/>date/time: a date/time literal or expression in double quotes, with any literal inside it in single quotes, e.g. `"DATE '2026-01-01'"`<br/>Example: `@accepted_values("'ALGERIA', 'ARGENTINA'")` |
| `@rejected_values("<value>", ...)` | Fails on rows whose value is in the deny list. NULL values pass.<br/>Same syntax and quoting rules as `accepted_values`.<br/>Example: `@rejected_values("'NA'")` |
| `@min_max("<min>", "<max>")` | Fails on rows outside the inclusive range. NULL values pass.<br/>Applies to numeric and date/time columns only.<br/>Each bound is pasted into the SQL verbatim, so write it as a valid SQL value for the column's data type —<br/>positive numeric (integer, decimal or float): with or without double quotes<br/>negative numeric (integer, decimal or float): double quotes required<br/>date/time: a date/time expression in double quotes, with any literal inside it in single quotes, e.g. `"DATE '2026-01-01'"` or `"CURRENT_TIMESTAMP()"`<br/>Example: `@min_max("0", "4")` |
| `@min_value("<min>")` | Fails on rows below the bound. NULL values pass.<br/>Value formatting — see `min_max`.<br/>Example: `@min_value("0")` |
| `@max_value("<max>")` | Fails on rows above the bound. NULL values pass.<br/>Value formatting — see `min_max`.<br/>Example: `@max_value("100")` |
| `@freshness(<interval>, "<unit>")` | Fails when the newest value in the column is older than the given interval, or the table is empty.<br/>**interval** — how far back from now the newest value is allowed to be, expressed in the unit given by **unit**.<br/>**unit** — SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, or YEAR (defaults to DAY).<br/>**Note:** on a DATE column the value is truncated to midnight.<br/>Example: `@freshness(7, "DAY")` |
| `@relative_time("<operator>", "<other_column>")` | Compares this column against another date/time column on the same node.<br/>e.g. `@relative_time("<=", "END_DATE")` fails rows where this column's value is not `<=` END_DATE.<br/>Either side NULL → row is skipped (passes).<br/>Both columns must have the same datatype — BigQuery does not compare a `TIMESTAMP` with a `DATETIME` or `DATE` and the test fails with a type error.<br/>Example: `@relative_time("<", "L_M_2")` |

---

### Notes & Supported SQL Functionality

- Verify that all **column datatypes** are successfully resolved before creating the object. Columns with an `UNKNOWN` datatype may cause stage generation or runtime failures. The create dry-run still reports `passed` with `UNKNOWN` in the DDL, so check the rendered column list rather than the status.
- **Datatype Compatibility:** If the defaulted datatype is not compatible with Google BigQuery, use `CAST()` to explicitly convert the value to a BigQuery-compatible datatype.
- Any keyword that is valid immediately after **SELECT** is accepted in the final **SELECT** clause (right after any CTEs) — for example **DISTINCT** or **ALL**. This does not extend to keywords like `DEFAULT` that, while valid SQL keywords elsewhere, don't fit in a `SELECT` clause.

    ```sql
    SELECT DISTINCT
         `N_REGIONKEY` AS `N_REGIONKEY`,
         `N_NAME` AS `N_NAME`
    FROM {{ ref('SRC', 'NATION') }} `NATION`
    ```

- `SELECT *` is **not currently supported** in the outer/main SELECT statement — specify the column names explicitly. Inside a CTE, `SELECT *` can be used.
- **Multi-Source Joins & Enrichment:** The ability to reference and join multiple upstream nodes (e.g., Joining ORDERS and CUSTOMER) within a single stage to flatten data or create enriched wide tables while maintaining full lineage for every source.
- **Conditional Logic via CASE Statements:** Support for complex business rules and data categorization using standard CASE WHEN syntax to create derived columns based on multiple logical conditions.
- **Nested Subqueries:** Support for correlated and non-correlated subqueries within SELECT, FROM, or WHERE clauses, enabling granular filtering and complex lookups that don't require separate nodes.
- **Common Table Expressions (CTEs)**: Support for standard `WITH` clauses to break down complex, multi-step transformation logic into readable, modular blocks. Coalesce tracks lineage through each CTE and back to the source tables.
- **Recursive CTEs**: Full support for `WITH RECURSIVE` logic, enabling the transformation of hierarchical data and the programmatic generation of data sequences within a single node.
- If a CTE is referenced in templates that may include joins, always use a **table alias** and qualify all column references with that alias. This prevents ambiguous column errors and ensures the template remains extensible as additional joins are introduced.

---

### Known Limitations

Users should be aware of the following technical constraints when using SQL-first nodes:

* **Parsable SQL Only**:  
The node only supports SQL that can be fully parsed by the platform's engine. Non-standard SQL or vendor-specific "semantic views" that bypass standard parsing will not work.

* **SELECT Statements Only**:  
This node only supports data retrieval and transformation logic. DML or DDL commands such as `CREATE`, `MERGE`, `DELETE`, `UPDATE`, or `TRUNCATE` are not supported and will cause execution failures.

* **Support for `UNION`, and `UNION ALL`**:  
`UNION` and `UNION ALL` are fully supported when used within **Common Table Expressions (CTEs)**. While these keywords can also be used in standard `SELECT` statements without generating an error, they may not be parsed correctly by the platform. As a result, subsequent clauses (such as `JOIN`s) may be interpreted as part of a standard join structure, causing the generated SQL to differ from the intended query and potentially leading to inconsistent data loads. To ensure the SQL is parsed and executed as expected, always implement these operations inside a CTE.

* **Other Keywords**:  
**GROUP BY, ORDER BY and HAVING** clauses can be included as part of the join query and will be parsed and processed accordingly.

* **Reserved Keywords as Annotation Names**:  
Avoid naming custom annotations after words that are reserved keywords in the platform's SQL grammar — e.g. `UNIQUE`, `AS`, `PRIMARY`. The parser may fail to parse such annotations and throw a validation error.

* **Switching Between YAML and SQL Node Types**:  
Converting an existing YAML (`.yml`) node to a SQL (`.sql`) node, or vice versa, is not supported.

* **Column Name Case**:  
BigQuery column names keep the case they were created with, but are **case-insensitive**: backticks only quote an identifier (for reserved words or special characters) — they do not make it case-sensitive, unlike double quotes in Snowflake. So `n_Name` and `N_NAME` are the same column: a table cannot hold both ("Duplicate column name"), and any casing in a query reads the same column. As a result:
  * a **case-only column rename** (e.g. `N_NAME` → `n_Name`) currently fails the alter with *"Column already exists"* — BigQuery rejects `RENAME COLUMN N_NAME TO n_Name` and `ADD COLUMN n_Name` because the name already exists ignoring case. The failure happens on the internal copy, so the live table is untouched; to apply the new case, rename through a temporary name in two deployments, or recreate the table;
  * a **case-only change in a partition or cluster column** drops and recreates the table (losing its data), although BigQuery treats it as the same column;
  * BigQuery stores the clustering with the column's own case (`CLUSTER BY n_name` on a column `N_NAME` is stored as `CLUSTER BY N_NAME`).

* **Partition, Cluster Key or Dataset Changes Recreate the Table**:  
BigQuery cannot alter a table's partitioning or clustering, or move a table between datasets, so these redeploys drop the table and create it again. **The existing data is lost** — reload it with a run.

* **Partition Expiration on a Dimension**:  
`@partitionExpirationDays` makes BigQuery delete each whole partition once its partition date (or ingestion date) is older than the given number of days — it does not look at the rows. A Dimension keeps rows that are still valid long after they were loaded: a current row that hasn't changed for that many days sits in an old partition and is deleted, and under SCD Type 2 the active version of a key can be deleted, leaving the key with no current row (and, if an older version survives in a newer partition, the wrong row looking current). Don't combine `@partitionExpirationDays` with a Dimension unless every row is reloaded or rewritten within the window; use `@tableExpiration` or a `@postSQL` clean-up for retention instead.

* **NOT NULL on an Existing Table**:  
BigQuery cannot set NOT NULL on an existing column or add a REQUIRED column to an existing table. A redeploy that adds `@notNull` raises the non-failing **Warning: NOT NULL Not Applied**; the column stays NULLABLE until the table is recreated.

* **Defaults Cannot Reference Columns**:  
A BigQuery column DEFAULT can only use constants and functions such as `GENERATE_UUID()` or `CURRENT_TIMESTAMP()` — a default built from other columns (for example a hash of the business key) fails at create. This is why the Dimension surrogate key uses `GENERATE_UUID()`.

* **Tags and Table Expiration After an Alter**:  
An alter rebuilds the table with `CREATE OR REPLACE TABLE … COPY` (**Clone Table**, then **Replace Table**). A table replaced by a copy loses its **tags** and its **table expiration** (the description, labels, rounding mode and partition expiration are kept), so every alter ends with an extra **Edit Table Options** stage that re-attaches them:
  * a **fixed** expiration (`@tableExpiration("2026-12-31")`) is set to the same timestamp again, so it does not change;
  * an **expression** expiration (`@tableExpiration("TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)")`) is evaluated again at the time of the alter — the table now expires 30 days after the alter (the swap), not 30 days after it was first created;
  * a table rename goes through the same copy, so the renamed table gets its tags and expiration back the same way.

* **Changing `@nodeType` on a Deployed Node**:  
The switch deploys as a metadata update — the existing table is kept, not rebuilt for the new type. Drop and redeploy the table when changing a node's type.

* **`truncateInsert` with SCD Type 2**:  
`@writeMode("truncateInsert")` empties the table before every load, so an SCD Type 2 dimension loses all its history on each run — every row is reloaded as version 1. Use the default `append` for versioned dimensions.

* **Keys Deleted from the Source**:  
A business key that disappears from the source is left as it is in the target — under SCD Type 2 its current row stays current, and under SCD Type 1 the row is kept unchanged. Deletes are never detected; handle them separately (e.g. with `@postSQL`) if the dimension needs to reflect removed keys.

* **System Columns Added to a Loaded Table**:  
Adding `@isSystemCreateDate` / `@isSystemUpdateDate` to a table that already holds rows adds the columns with NULL in every existing row. Backfill them once (e.g. with `@postSQL`) or reload with `@writeMode("truncateInsert")` if they need values.

* **Duplicate or NULL Business Keys**:  
Every strategy merges on the business key, so the SELECT/CTE must return exactly one row per key, with no NULL key. Otherwise a duplicated key fails the merge with "UPDATE/MERGE must match at most one source row for each target row", and a NULL key never matches, so that row is re-inserted on every run. De-duplicate upstream (e.g. `QUALIFY ROW_NUMBER() OVER (PARTITION BY <business key> ORDER BY <timestamp> DESC) = 1`). To check it before each load, add a `Before` node-level test — see [Duplicate or NULL Business Key Check](#duplicate-or-null-business-key-check).

---

### Usage Examples

Common ways to use the SQL nodes. The SQL patterns under Work Examples (CTEs, window functions, DISTINCT) work the same way in a Dimension or Fact node, and the BigQuery table annotations (`@partitionBy`, `@clusterKey`, `@primaryKey`, `@tag`, expirations) work the same on every node type.

**Work Examples**
* [Sample Node with Annotations](#sample-node-with-annotations)
* [Sample Node with DISTINCT](#sample-node-with-distinct)
* [Basic Transformation and Cleaning](#basic-transformation-and-cleaning)
* [Aggregate Functions inside a CTE](#aggregate-functions-inside-a-cte)
* [Using CTEs](#using-ctes)
* [Multi-CTE Transformation with Window Functions](#multi-cte-transformation-with-window-functions)
* [Recursive CTE](#recursive-cte)
* [Recursive CTE Date Series](#recursive-cte-date-series)
* [CTE for Multi-Source Combine](#cte-for-multi-source-combine)

**Data Quality Test Examples**
* [Column Tests by Datatype](#column-tests-by-datatype)
* [Node-Level Tests](#node-level-tests)

**Dimension Examples**
* [Change Tracking SCD1](#change-tracking-scd1)
* [Change Tracking SCD2](#change-tracking-scd2)
* [Last Modified SCD1](#last-modified-scd1)
* [Last Modified SCD2](#last-modified-scd2)
* [Upsert](#upsert)
* [Zero Key Record](#zero-key-record)
* [Dimension as a View](#dimension-as-a-view)
* [Duplicate or NULL Business Key Check](#duplicate-or-null-business-key-check)
* [Upsert with Custom SCD Logic](#upsert-with-custom-scd-logic)

**Fact Examples**
* [Fact Plain Insert](#fact-plain-insert)
* [Fact Change Tracking SCD1](#fact-change-tracking-scd1)
* [Fact Last Modified SCD1](#fact-last-modified-scd1)
* [Fact Upsert](#fact-upsert)
* [Fact All Column Match](#fact-all-column-match)

**BigQuery Table Options**
* [Partition, Cluster Key, Primary Key, Tags and Expiration](#partition-cluster-key-primary-key-tags-and-expiration)

#### Work Examples

##### Sample Node with Annotations

```sql
@writeMode("append")
@tests("SELECT 1 FROM {{ this }} GROUP BY N_NATIONKEY HAVING COUNT(*) > 1")  -- runs After the load (default), continueOnFailure=true (default)
@tests("SELECT 1 FROM {{ this }} WHERE N_REGIONKEY IS NULL", true, "Before")  -- runs Before the load, continueOnFailure=true
@description("Table description")
@preSQL("DELETE FROM {{ this }} WHERE N_LOAD_DATE < DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)")
@postSQL("INSERT INTO {{ ref('AUDIT', 'LOAD_LOG') }} (TABLE_NAME, LOAD_TS) VALUES ('WRK_NATION', CURRENT_TIMESTAMP())")
@tableExpiration("2999-12-31")
@tag("env", "dev")
SELECT
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @not_null @uniqueness @min_value(0) @max_value(100) @accepted_values("1, 2, 3") @inHash("GH_COL1", 2) @clusterKey(1),
    `N_NAME`                                 AS `N_NAME`              @not_null @empty @accepted_values("'ALGERIA', 'ARGENTINA'") @inHash("GH_COL1", 1),
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @min_max(0, 4) @notNull @defaultValue("20"),
    `N_COMMENT`                              AS `N_COMMENT`           @rejected_values("'NA'"),
    `LAST_MODIFIED`                          AS `L_M_1`               @freshness(7, "DAY") @relative_time("<", "L_M_2") @description("timestamp column"),
    `LAST_MODIFIED`                          AS `L_M_2`,
    CAST(`LAST_MODIFIED` AS DATE)            AS `N_LOAD_DATE`         @partitionBy,
    CAST({{ get_hash('GH_COL1') }} AS STRING)                AS `GH_COL1`             @description("Hash Column")
FROM {{ ref('SOURCE_DATA', 'NATION') }} `NATION`
```

##### Sample Node with DISTINCT

```sql
@writeMode("append")
@description("Table description")
SELECT DISTINCT
    `N_NATIONKEY`                            AS `N_NATIONKEY`,
    `N_NAME`                                 AS `N_NAME`,
    `N_REGIONKEY`                            AS `N_REGIONKEY`,
    `N_COMMENT`                              AS `N_COMMENT`,
    `LAST_MODIFIED`                          AS `L_M`                 @freshness(7, "DAY")
FROM {{ ref('SOURCE_DATA', 'NATION') }} `NATION`
```

##### Basic Transformation and Cleaning

Standard pattern for renaming columns and handling nulls.

```sql
SELECT
    `O_ORDERKEY`                             AS `O_ORDERKEY`,
    `O_CUSTKEY`                              AS `O_CUSTKEY`,
    CAST(UPPER(`O_ORDERSTATUS`) AS STRING)   AS `O_ORDERSTATUS`,
    CAST(COALESCE(`O_TOTALPRICE`, 0) AS NUMERIC) AS `O_TOTALPRICE`,
    `O_ORDERDATE`                            AS `O_ORDERDATE`
FROM {{ ref('SRC', 'ORDERS') }} `ORDERS`
WHERE `O_ORDERSTATUS` != 'F'
```

##### Aggregate Functions inside a CTE

```sql
WITH ORDER_COUNTS AS (
    SELECT
        MOD(`ORDER_ID`, 25) AS `NATION_KEY`,
        COUNT(*) AS `ORDER_COUNT`
    FROM {{ ref('SRC', 'ORDERS_TEST') }}
    GROUP BY MOD(`ORDER_ID`, 25)
)
SELECT
    `OC`.`NATION_KEY`                        AS `NATION_KEY`,
    `OC`.`ORDER_COUNT`                       AS `ORDER_COUNT`
FROM ORDER_COUNTS `OC`
```

##### Using CTEs

For more complex, multi-step logic.

```sql
WITH PRIORITY_COUNTS AS (
    SELECT
        `O_ORDERPRIORITY` AS `O_ORDERPRIORITY`,
        COUNT(*) AS `ORDER_COUNT`
    FROM {{ ref('SRC', 'ORDERS') }}
    GROUP BY 1
)
SELECT
    `PC`.`O_ORDERPRIORITY`                   AS `O_ORDERPRIORITY`,
    `PC`.`ORDER_COUNT`                       AS `ORDER_COUNT`
FROM PRIORITY_COUNTS `PC`
```

##### Multi-CTE Transformation with Window Functions

Complex transformations that would otherwise require multiple nodes can be written as a single SQL statement. Coalesce tracks lineage through each CTE and down to the source tables.

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
F.FIRST_PURCHASE_DATE @partitionBy,
F.FIRST_ORDER_VALUE,
F.O_ORDERSTATUS @notNull,
CURRENT_TIMESTAMP() AS REFRESHED_AT,
CAST('Initial Customer Purchase' AS STRING) AS RECORD_TYPE
FROM FIRST_ORDERS F
```

##### Recursive CTE

```sql
@description("Gap-free daily order calendar per nation, built from a recursive date spine bounded by the orders date range.")
WITH RECURSIVE DATE_BOUNDS AS (
    SELECT
        MIN(O_ORDERDATE) AS MIN_DATE,
        MAX(O_ORDERDATE) AS MAX_DATE
    FROM {{ ref('SRC', 'ORDERS') }}
),
DATE_SPINE AS (
    SELECT MIN_DATE AS ORDER_DATE, MAX_DATE
    FROM DATE_BOUNDS

    UNION ALL

    SELECT DATE_ADD(ORDER_DATE, INTERVAL 1 DAY), MAX_DATE
    FROM DATE_SPINE
    WHERE ORDER_DATE < MAX_DATE
),
DAILY_ORDERS AS (
    SELECT
        O_ORDERDATE,
        COUNT(*) AS ORDER_COUNT,
        SUM(O_TOTALPRICE) AS ORDER_TOTAL_VALUE
    FROM {{ ref('SRC', 'ORDERS') }}
    GROUP BY O_ORDERDATE
)
SELECT
    `ds`.`ORDER_DATE` AS `ORDER_DATE` @notNull @description("Calendar day in the orders date range"),
    `n`.`N_NATIONKEY` AS `N_NATIONKEY` @notNull @description("Nation key"),
    `n`.`N_NAME` AS `N_NAME` @description("Nation name"),
    COALESCE(`do`.`ORDER_COUNT`, 0) AS `ORDER_COUNT` @description("Orders placed on this day, across all nations"),
    CAST(COALESCE(`do`.`ORDER_TOTAL_VALUE`, 0) AS FLOAT64) AS `ORDER_TOTAL_VALUE` @description("Total order value on this day, across all nations")
FROM DATE_SPINE `ds`
CROSS JOIN {{ ref('SRC', 'NATION') }} `n`
LEFT JOIN DAILY_ORDERS `do` ON `do`.`O_ORDERDATE` = `ds`.`ORDER_DATE`
```

##### Recursive CTE Date Series

```sql
WITH RECURSIVE RCTE_FNL AS (
    SELECT CAST('2025-01-01' AS DATE) AS `date_s`
    UNION ALL
    SELECT DATE_ADD(`date_s`, INTERVAL 1 DAY) AS `date_s`
    FROM RCTE_FNL
    WHERE `date_s` < CAST('2025-01-10' AS DATE)
  )
SELECT `R`.`date_s` AS `date_s` @partitionBy
FROM RCTE_FNL `R`
```

##### CTE for Multi-Source Combine

```sql
WITH ALL_NATIONS AS (
    SELECT *
    FROM {{ ref('SOURCE_DATA', 'NATION_COPY1') }}
    UNION DISTINCT
    SELECT *
    FROM {{ ref('SOURCE_DATA', 'NATION_COPY2') }}
)
SELECT
    `AN`.`N_NATIONKEY`                       AS `N_NATIONKEY`,
    `AN`.`N_NAME`                            AS `N_NAME`,
    `AN`.`N_REGIONKEY`                       AS `N_REGIONKEY`
FROM ALL_NATIONS `AN`
```
* BigQuery needs `UNION DISTINCT` or `UNION ALL` — a bare `UNION` is not valid.
* `SELECT *` works inside the CTE; the outer SELECT lists its columns.

#### Data Quality Test Examples

##### Column Tests by Datatype

Each column test runs **After** the load, continues the run on failure, and lets NULL values pass (except `@not_null`). Values are pasted into the SQL as written, so quote them to match the column's datatype.

```sql
SELECT
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @not_null @uniqueness @min_value("1"),
    `NAME`                                   AS `NAME`                @not_null @empty,
    `SEGMENT`                                AS `SEGMENT`             @accepted_values("'RETAIL', 'CORPORATE'") @accepted_values("'SMB'"),
    `STATUS`                                 AS `STATUS`              @rejected_values("'DELETED', 'TEST'"),
    `BALANCE`                                AS `BALANCE`             @min_max("-1000", "100000"),
    `DISCOUNT`                               AS `DISCOUNT`            @min_value("0") @max_value("0.5"),
    `IS_ACTIVE`                              AS `IS_ACTIVE`           @accepted_values(true),
    `SIGNUP_DATE`                            AS `SIGNUP_DATE`         @min_max("DATE '2000-01-01'", "CURRENT_DATE()"),
    `CREATED_AT`                             AS `CREATED_AT`          @max_value("CURRENT_TIMESTAMP()"),
    `UPDATED_AT`                             AS `UPDATED_AT`          @freshness(1, "DAY") @relative_time(">=", "CREATED_AT"),
    `OPEN_TIME`                              AS `OPEN_TIME`           @min_max("TIME '08:00:00'", "TIME '18:00:00'")
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```
* **Number** — `@min_value("1")`, a negative bound in double quotes `"-1000"`, a decimal `"0.5"`.
* **String** — single quotes inside double quotes; `@accepted_values` can repeat and the lists are merged.
* **Boolean** — `true`/`false`. **Date/time** — a literal or expression, e.g. `"DATE '2000-01-01'"`, `"CURRENT_TIMESTAMP()"`, `"TIME '08:00:00'"`.
* `@relative_time` compares two columns of the same datatype (`CREATED_AT` and `UPDATED_AT` are both TIMESTAMP).
* The same annotations work on a Dimension or Fact node — add an `@id("<value>")` to each column there.

##### Node-Level Tests

A node-level test fails when its query returns any rows. `Before` tests usually read the source; `After` tests read the loaded target through `{{ this }}`.

```sql
@tests("SELECT CUSTOMER_ID FROM {{ ref('SRC', 'CUSTOMER') }} GROUP BY CUSTOMER_ID HAVING COUNT(*) > 1", false, "Before")  -- runs Before the load, continueOnFailure=false
@tests("SELECT COUNT(*) AS `N` FROM {{ ref('SRC', 'CUSTOMER') }} HAVING COUNT(*) = 0", true, "Before")  -- runs Before the load, continueOnFailure=true
@tests("SELECT 1 FROM {{ this }} WHERE BALANCE < 0 AND STATUS = 'ACTIVE'")  -- runs After the load (default), continueOnFailure=true (default)
@tests("SELECT COUNT(*) AS `N` FROM {{ this }} HAVING COUNT(*) <> (SELECT COUNT(*) FROM {{ ref('SRC', 'CUSTOMER') }})", true, "After")  -- runs After the load, continueOnFailure=true
SELECT
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`,
    `BALANCE`                                AS `BALANCE`,
    `STATUS`                                 AS `STATUS`
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```
* Line 1 — duplicate keys in the source, before the load. Line 2 — an empty source. Line 3 — a business rule on the loaded rows (`After` by default). Line 4 — the target row count matches the source.
* A `HAVING` without `GROUP BY` must have an aggregate in the SELECT list — BigQuery rejects `SELECT 1 FROM … HAVING COUNT(*) = 0` ("The HAVING clause only allows aggregation if GROUP BY or SELECT list aggregation is present"), so lines 2 and 4 select `COUNT(*)`.
* `continueOnFailure` is the second argument.
* `@disableTests` on the node skips every node-level and column-level test.

#### Dimension Examples

##### Change Tracking SCD1

The default strategy. Any change in a non-key column overwrites the row. The table is clustered on the business key.

```sql
SELECT
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @id("a10001") @isBusinessKey @clusterKey(1),
    `NAME`                                   AS `NAME`                @id("a10002"),
    `CITY`                                   AS `CITY`                @id("a10003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("a10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("a10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```

##### Change Tracking SCD2

A change in a column marked `@isChangeTracking` keeps the old row and adds a new version. Other columns are updated in place. The surrogate key is filled by BigQuery from its `GENERATE_UUID()` default — a new key for every version. The table is partitioned by month of the row's create date.

```sql
@mergeStrategy("changeTracking")
@partitionBy("TIMESTAMP_TRUNC(SYSTEM_CREATE_DATE, MONTH)")
SELECT
    CAST("0" AS STRING)                      AS `DIM_CUSTOMER_KEY`    @id("b10000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @id("b10001") @isBusinessKey @clusterKey(1),
    `NAME`                                   AS `NAME`                @id("b10002"),
    `CITY`                                   AS `CITY`                @id("b10003") @isChangeTracking,
    1                                        AS `SYSTEM_VERSION`      @id("b10005") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("b10006") @isSystemCurrentFlag,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("b10007") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("b10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("b10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```

##### Last Modified SCD1

A row is overwritten only when its `@lastModifiedTracking` value is newer than the stored one. The table is partitioned by day of `UPDATED_AT` (column-level `@partitionBy` on a TIMESTAMP column).

```sql
@mergeStrategy("lastModified")
SELECT
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @id("c10001") @isBusinessKey,
    `NAME`                                   AS `NAME`                @id("c10002"),
    `UPDATED_AT`                             AS `UPDATED_AT`          @id("c10003") @lastModifiedTracking(1) @partitionBy,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("c10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("c10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```

##### Last Modified SCD2

Same as above, but a newer value keeps the old row and adds a new version.

```sql
@mergeStrategy("lastModified")
SELECT
    CAST("0" AS STRING)                      AS `DIM_CUSTOMER_KEY`    @id("d10000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @id("d10001") @isBusinessKey,
    `NAME`                                   AS `NAME`                @id("d10002"),
    `UPDATED_AT`                             AS `UPDATED_AT`          @id("d10003") @lastModifiedTracking(2),
    1                                        AS `SYSTEM_VERSION`      @id("d10005") @isSystemVersion,
    CAST('Y' AS STRING)                      AS `SYSTEM_CURRENT_FLAG` @id("d10006") @isSystemCurrentFlag,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE`     @id("d10007") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("d10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("d10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```

##### Upsert

No change detection: existing keys are updated, new keys inserted. System columns are optional.

```sql
@mergeStrategy("upsert")
SELECT
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @id("e10001") @isBusinessKey @primaryKey(1),
    `NAME`                                   AS `NAME`                @id("e10002"),
    `CITY`                                   AS `CITY`                @id("e10003")
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```

##### Zero Key Record

Adds a placeholder row for unmatched lookups. Needs a surrogate key column.

```sql
@zeroKey("'-1'")
SELECT
    CAST("0" AS STRING)                      AS `DIM_CUSTOMER_KEY`    @id("f10000") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @id("f10001") @isBusinessKey,
    `NAME`                                   AS `NAME`                @id("f10002") @zeroKey("'NA'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("f10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("f10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```

* The surrogate key is a STRING filled with `GENERATE_UUID()`, so the zero value is quoted (`'-1'`); every real row gets its own UUID. With an INT64 key use an unquoted number, e.g. `@zeroKey("-1")`.

##### Dimension as a View

No business key or system columns needed; nothing is merged. The view carries a tag and an expiration.

```sql
@materializationType("view")
@tag("env", "dev")
@tableExpiration("2999-12-31")
SELECT
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @id("0a0001") @description("Customer id"),
    `NAME`                                   AS `NAME`                @id("0a0002")
FROM {{ ref('SRC', 'CUSTOMER') }} `CUSTOMER`
```

##### Duplicate or NULL Business Key Check

Every merge strategy matches rows on the business key, so the source must return exactly one row per key, with no NULL key. A `Before` test runs ahead of the load and fails if the source returns a duplicated or NULL key.

```sql
@mergeStrategy("changeTracking")
@tests("SELECT N_NATIONKEY, N_NAME FROM {{ ref('SOURCE_DATA', 'NATION') }} GROUP BY N_NATIONKEY, N_NAME HAVING COUNT(*) > 1 OR N_NATIONKEY IS NULL OR N_NAME IS NULL", false, "Before")  -- runs Before the load, continueOnFailure=false
SELECT
    CAST("0" AS STRING)                      AS `DIM_NATION_KEY`      @id("a1b2c3") @isSurrogateKey @defaultValue("GENERATE_UUID()"),
    `N_NATIONKEY`                            AS `N_NATIONKEY`         @id("b2c3d4") @isBusinessKey,
    `N_NAME`                                 AS `N_NAME`              @id("c3d4e5") @isBusinessKey,
    `N_REGIONKEY`                            AS `N_REGIONKEY`         @id("d4e5f6"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("e5f6a7") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("f6a7b8") @isSystemUpdateDate
FROM {{ ref('SOURCE_DATA', 'NATION') }} `NATION`
```
* The test query must read the same source, CTE and filters as the node's SELECT, so it checks the rows that are actually loaded. List every `@isBusinessKey` column in the `GROUP BY` and the `IS NULL` checks.

##### Upsert with Custom SCD Logic

`upsert` writes each row exactly as the SELECT computes it, so the SELECT can implement its own change logic. This example keeps the previous `CITY` (SCD3 style): the SELECT joins the source to the node's own table, and when the city changes, the old value moves to `CITY_PREV`.

```sql
@mergeStrategy("upsert")
WITH EXISTING AS (
    -- Current rows already in this dimension
    SELECT `CUSTOMER_ID`, `CITY`, `CITY_PREV`, `CITY_CHANGED_DATE`
    FROM {{ ref('TARGET', 'DIM_CUSTOMER') }}
)
SELECT
    `SRC`.`CUSTOMER_ID`                      AS `CUSTOMER_ID`         @id("0b0001") @isBusinessKey,
    `SRC`.`NAME`                             AS `NAME`                @id("0b0002"),
    `SRC`.`CITY`                             AS `CITY`                @id("0b0003"),
    CASE WHEN `SRC`.`CITY` IS DISTINCT FROM `EX`.`CITY` AND `EX`.`CUSTOMER_ID` IS NOT NULL
         THEN `EX`.`CITY`
         ELSE `EX`.`CITY_PREV` END           AS `CITY_PREV`           @id("0b0004"),
    CASE WHEN `SRC`.`CITY` IS DISTINCT FROM `EX`.`CITY` AND `EX`.`CUSTOMER_ID` IS NOT NULL
         THEN CURRENT_TIMESTAMP()
         ELSE `EX`.`CITY_CHANGED_DATE` END   AS `CITY_CHANGED_DATE`   @id("0b0005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("0b0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("0b0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'CUSTOMER') }} `SRC`
LEFT JOIN EXISTING `EX` ON `SRC`.`CUSTOMER_ID` = `EX`.`CUSTOMER_ID`
```
* New customer — no match in `EXISTING`, so `CITY_PREV` and `CITY_CHANGED_DATE` are NULL.
* City changed — the old city moves to `CITY_PREV` and `CITY_CHANGED_DATE` is stamped.
* City unchanged — the stored `CITY_PREV` and `CITY_CHANGED_DATE` are kept.
* `@isSystemCreateDate` keeps its first-insert value on update; every other column is overwritten from the SELECT.

#### Fact Examples

##### Fact Plain Insert

No `@mergeStrategy` and no `@isBusinessKey` column, so every source row is inserted with no matching. The table is partitioned by order date and old partitions expire after a year.

```sql
@partitionExpirationDays("365")
SELECT
    `ORDER_ID`                               AS `ORDER_ID`            @id("1a0001") @clusterKey(1),
    `CUSTOMER_ID`                            AS `CUSTOMER_ID`         @id("1a0002"),
    `AMOUNT`                                 AS `AMOUNT`              @id("1a0003"),
    `ORDER_DATE`                             AS `ORDER_DATE`          @id("1a0004") @partitionBy,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("1a0008") @isSystemCreateDate
FROM {{ ref('SRC', 'ORDERS') }} `ORDERS`
```

##### Fact Change Tracking SCD1

The default strategy with a business key. Any change in a non-key column overwrites the row; new keys are inserted.

```sql
@defaultRoundingMode("ROUND_HALF_EVEN")
SELECT
    `ORDER_ID`                               AS `ORDER_ID`            @id("1b0001") @isBusinessKey @primaryKey(1),
    `STATUS`                                 AS `STATUS`              @id("1b0002"),
    CAST(`AMOUNT` AS NUMERIC)                AS `AMOUNT`              @id("1b0003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("1b0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("1b0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'ORDERS') }} `ORDERS`
```

##### Fact Last Modified SCD1

A row is overwritten only when its `@lastModifiedTracking` value is newer than the stored one.

```sql
@mergeStrategy("lastModified")
SELECT
    `ORDER_ID`                               AS `ORDER_ID`            @id("1c0001") @isBusinessKey,
    `STATUS`                                 AS `STATUS`              @id("1c0002"),
    `UPDATED_AT`                             AS `UPDATED_AT`          @id("1c0003") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("1c0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("1c0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'ORDERS') }} `ORDERS`
```

##### Fact Upsert

No change detection: existing keys are updated, new keys inserted. System columns are optional.

```sql
@mergeStrategy("upsert")
SELECT
    `ORDER_ID`                               AS `ORDER_ID`            @id("1d0001") @isBusinessKey,
    `STATUS`                                 AS `STATUS`              @id("1d0002"),
    `AMOUNT`                                 AS `AMOUNT`              @id("1d0003")
FROM {{ ref('SRC', 'ORDERS') }} `ORDERS`
```

##### Fact All Column Match

Every non-system column is compared; a row is inserted only if an identical row doesn't already exist. Nothing is ever updated, and no `@isBusinessKey` is needed.

`allColumnMatch` is how you build a **factless fact table** — a table with no measures, where the existence of a row is the fact itself. Typical uses:

* **Event tracking** — records that something happened, e.g. a student attended a class or a customer visited a page on a date.
* **Coverage / relationship tracking** — records which combinations are valid or in effect, e.g. which products are on promotion in which stores, so you can also find what *didn't* happen (promoted products that didn't sell).

```sql
@mergeStrategy("allColumnMatch")
SELECT
    `ORDER_ID`                               AS `ORDER_ID`            @id("1e0001"),
    `PRODUCT_ID`                             AS `PRODUCT_ID`          @id("1e0002"),
    `QUANTITY`                               AS `QUANTITY`            @id("1e0003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("1e0008") @isSystemCreateDate
FROM {{ ref('SRC', 'ORDER_LINES') }} `ORDER_LINES`
```
* `SYSTEM_CREATE_DATE` is left out of the comparison, so re-running the load doesn't insert the same row again.
* Matching uses plain equality — a row with a NULL in any compared column never matches and is inserted on every run.
* Two identical source rows that aren't in the target yet are both inserted — add `DISTINCT` to the SELECT if that's not wanted.

#### BigQuery Table Options

##### Partition, Cluster Key, Primary Key, Tags and Expiration

Every BigQuery table option in one node — they work the same on Work, Dimension and Fact tables (on a view only `@tag`, `@tableExpiration` and the description apply). The tags must already exist in GCP.

```sql
@materializationType("table")
@description("Nation table with every table option")
@partitionExpirationDays("365")
@tableExpiration("2999-12-31")
@defaultRoundingMode("ROUND_HALF_EVEN")
@tag("env", "dev")
@tag("cost_center", "finance")
SELECT
    `n_NationKey`                              AS `N_NATIONKEY`       @notNull @primaryKey(1) @clusterKey(1) @description("Nation key"),
    `n_Name`                                   AS `N_NAME`            @notNull @clusterKey(2) @description("Nation name"),
    CAST(COALESCE(`n_RegionKey`, -1) AS INT64) AS `N_REGIONKEY`       @notNull @primaryKey(2) @clusterKey(3) @description("Region key"),
    `n_Comment`                                AS `N_COMMENT`         @defaultValue("'NA'") @description("Free-text comment, defaults to NA"),
    CAST(`n_NationKey` / 7 AS NUMERIC)         AS `N_NATIONKEY_RATIO` @description("Rounded with the table default_rounding_mode"),
    CAST(DATE(`last_Modified`) AS DATE)        AS `LOAD_DATE`         @partitionBy @notNull @description("Partition column")
FROM {{ ref('SRC', 'Nation_Test_CamelCase') }} `Nation_Test_CamelCase`
```

On the first deployment this creates (`<PROJECT>.<DATASET>` is the node's own location):

```sql
CREATE OR REPLACE TABLE `<PROJECT>`.`<DATASET>`.`WRK_NATION` (
    `N_NATIONKEY` INT64 NOT NULL OPTIONS(description = 'Nation key'),
    `N_NAME` STRING NOT NULL OPTIONS(description = 'Nation name'),
    `N_REGIONKEY` INT64 NOT NULL OPTIONS(description = 'Region key'),
    `N_COMMENT` STRING DEFAULT 'NA' OPTIONS(description = 'Free-text comment, defaults to NA'),
    `N_NATIONKEY_RATIO` NUMERIC OPTIONS(description = 'Rounded with the table default_rounding_mode'),
    `LOAD_DATE` DATE NOT NULL OPTIONS(description = 'Partition column'),
    PRIMARY KEY (`N_NATIONKEY`, `N_REGIONKEY`) NOT ENFORCED
)
PARTITION BY `LOAD_DATE`
CLUSTER BY `N_NATIONKEY`, `N_NAME`, `N_REGIONKEY`
OPTIONS(
    partition_expiration_days = 365,
    expiration_timestamp = TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY),
    default_rounding_mode = 'ROUND_HALF_EVEN',
    tags = [('<PROJECT>/env', 'dev'), ('<PROJECT>/cost_center', 'finance')],
    description = 'Nation table with every table option'
)
```

* `LOAD_DATE` carries the column-level `@partitionBy` — a DATE column is used as-is. The partition could equally be set on the node, e.g. `@partitionBy("LOAD_DATE")` — but not both.
* The tag names have no `/`, so they are qualified with the project of the node's location.
* A NOT NULL column whose source can hold NULLs fails the load ("Required field … cannot be null") — `COALESCE` it, as `N_REGIONKEY` does here.
* On a later deployment, a tag, expiration or description change runs only **Edit Table Options**; a partition or cluster key change recreates the table — see [Altering the Work Tables](#altering-the-work-tables).

---

### Code

#### Work

* [Node definition](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Work-SQLWork/definition.yml)
* [Create Template](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Work-SQLWork/create.sql.j2)
* [Run Template](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Work-SQLWork/run.sql.j2)

#### Dimension

* [Node definition](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Dimension-SQLDimension/definition.yml)
* [Create Template](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Dimension-SQLDimension/create.sql.j2)
* [Run Template](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Dimension-SQLDimension/run.sql.j2)

#### Fact

* [Node definition](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Fact-SQLFact/definition.yml)
* [Create Template](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Fact-SQLFact/create.sql.j2)
* [Run Template](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/nodeTypes/Fact-SQLFact/run.sql.j2)

#### Macro

* [Macro](https://github.com/coalesceio/big-query-base-node-types-sql/blob/main/macros/macro-1.yml)
