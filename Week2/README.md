# Week 2 — Advanced BigQuery SQL for Data Engineers

## What I built
- Deduplication pipeline using ROW_NUMBER + CREATE TABLE AS SELECT
- Customer Gold layer table with ARRAY_AGG + STRUCT nested data
- UNNEST queries to read back nested arrays
- Three incremental load patterns: append-only, MERGE, partition overwrite
- BQ scripting with variables, IF/ELSE, WHILE loop for backfill
- Scheduled daily summary query at 3am IST
- Execution plan analysis on complex window function query

## Key learnings
- ARRAY_AGG + STRUCT creates nested Gold layer tables — no joins needed downstream
- UNNEST explodes arrays back to rows — reverse of ARRAY_AGG
- Partition overwrite is simpler and more idempotent than MERGE for daily batch loads
- BQ scripting handles simple pipeline logic without Python
- Slots are BQ's compute unit — bytes scanned = storage cost, slots = compute cost
- QUALIFY filters on window function results — cleaner than subquery wrapping

## Files
- `advanced_bq_sql.sql` — window functions, ARRAY_AGG, QUALIFY pipeline patterns
- `unnest_queries.sql` — UNNEST to read nested data, array filtering
- `incremental_patterns.sql` — append-only, MERGE, partition overwrite
- `bq_scripting.sql` — BQ procedural SQL with variables and loops
- `bq_execution_notes.md` — execution plan observations

## Open questions
