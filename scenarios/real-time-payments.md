Crossbring Scenario: Real-Time Payments Monitoring & Reporting

Problem
- Need live visibility into instant payments with SLA tracking, failure spike alerts, and daily reporting. Data arrives as streaming events and batch files.

Flow
1) API publishes POSTed events to Kafka (03-api-java)
2) Ingest to Snowflake (either): Kafka Connect sink OR Snowpipe from S3 (05-batch-snowpipe)
3) ELT with dbt (01-warehouse-dbt): normalize, test, document, and build dims/facts
4) Processing with Snowpark (04-processing-snowpark): enrich + compute DQ KPIs
5) (Optional) Iceberg (06-lakehouse-iceberg): external, cost-efficient history

KPIs & SLAs
- Failure rate, latency buckets, volume by method/currency, DQ completeness.

Demo Steps
- Start Kafka → POST events → ingest (Connect or Snowpipe) → dbt seed/run/test/docs → Snowpark KPIs.

Extensions
- Add schema registry; freshness checks with alerting; BI dashboard wiring; CDC pipelines.

