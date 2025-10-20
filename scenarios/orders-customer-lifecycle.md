Crossbring Scenario: Orders Customer Lifecycle KPIs

Problem
- Track order lifecycle health (placed→shipped→delivered/cancelled), conversion, and channel performance. Identify bottlenecks and quality issues across regions.

Flow
1) API/Producers publish orders to Kafka `orders`
2) Ingest to Snowflake via Kafka Connect (ORDERS_RAW) or Snowpipe from S3
3) dbt: `stg_orders` / `stg_orders_streamed` → `fct_orders` with tests/docs
4) Snowpark: compute KPIs (conversion rate, cancellation rate, time-in-stage buckets)
5) Optional Iceberg for long-term storage

KPIs
- Placement → Shipment conversion rate; cancellation rate
- Median/95p time from placed to shipped
- Volume and AOV by channel (WEB/APP)
- Freshness SLO for ORDERS_RAW ingestion

Demo
- Produce orders via API or OrderProducer
- Run dbt (seed/run/test) and inspect `fct_orders`
- Extend Snowpark script to compute lifecycle KPIs

