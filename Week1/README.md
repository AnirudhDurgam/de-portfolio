# Week 1 — GCP Core + BigQuery Foundation

## What I built
- GCS bucket `de-portfolio-anirudh-raw` in asia-south1
- BQ dataset `raw_layer` with two tables:
  - `orders_raw` — loaded from GCS via auto detect
  - `orders_partitioned` — partitioned by order_date, clustered by region
- Proved 800x bytes reduction: 4MB → 5KB using partition filter
- ADC authentication via Python (google-cloud-bigquery client)

## Key learnings
- Partitioning splits table into storage blocks by date column
- Clustering sorts rows within each partition — both together minimise bytes scanned
- MERGE handles upserts — updates existing rows, inserts new ones atomically
- QUALIFY is BQ-specific — filters on window function results without a subquery
- ADC is the correct modern auth method for local development
- JSON keys are now disabled by default on new GCP projects (Secure by Default)

## Files
- `bq_auth.py` — Python script authenticating to BQ via ADC, runs two queries
- `advanced_sql.sql` — MERGE, ARRAY_AGG, window functions (ROW_NUMBER, RANK, LAG, QUALIFY)
- `optimised_queries.sql` — cost optimisation queries with before/after bytes comparison

## Open questions
- None this week