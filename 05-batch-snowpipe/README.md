Crossbring Snowflake Snowpipe (JSON ingestion)

Usage
- Fill placeholders in `ddl/snowpipe_setup.sql`
- Land NDJSON files to the S3 prefix
- Snowpipe loads into `raw.PAYMENTS_RAW`; use dbt to normalize

