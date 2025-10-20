Crossbring Snowflake dbt ELT

Purpose
- Robust ELT modeling on Snowflake with dbt, including tests and docs that fit CI workflows.

Setup
1) Install dbt-core and dbt-snowflake
2) Configure `profiles.yml` with a `crossbring` profile
3) Run: `dbt deps && dbt seed && dbt run && dbt test`

Structure
- seeds/: small CSVs for example data
- models/staging/: staging and normalization, including streamed JSON
- models/marts/core/: dims/facts
- models/sources/: raw source definition for streamed ingestion

