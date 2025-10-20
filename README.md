Crossbring Data Platform Portfolio

Purpose & Approach
- Build a reusable, tech-focused portfolio demonstrating streaming, ELT, APIs, processing, and lakehouse patterns. Each module stands alone and can be combined for end-to-end flows.
- Productize core capabilities as building blocks; start with reference flows and scale by domain (payments, orders, telemetry, risk, marketing).

Modules
- 01-warehouse-dbt: Snowflake dbt ELT (models, tests, docs)
- 02-streaming-kafka: Kafka producer/consumer (Java) + local Kafka stack
- 03-api-java: Spring Boot API publishing POSTed events to Kafka
- 04-processing-snowpark: Snowpark Python transforms and DQ KPIs
- 05-batch-snowpipe: Snowpipe DDL for S3 → Snowflake ingestion
- 06-lakehouse-iceberg: Snowflake + Apache Iceberg templates
- 07-infra-aws-iac: Terraform S3 + IAM role scaffolding
- scenarios/: Real-world scenario guides (payments; add orders/telemetry later)

Quick Start
1) Kafka: `cd 02-streaming-kafka/infra && docker compose up -d`
2) API → Kafka: `cd 03-api-java && mvn -q -DskipTests spring-boot:run`
   - POST events to `/payments` to publish to Kafka topic `payments`
   - POST events to `/orders` to publish to Kafka topic `orders`
3) dbt: `cd 01-warehouse-dbt && dbt deps && dbt seed && dbt run && dbt test`
4) Snowpark: `cd 04-processing-snowpark && pip install -r requirements.txt && python app/transform.py`
5) Snowpipe: review `05-batch-snowpipe/ddl/snowpipe_setup.sql` and fill placeholders
6) Iceberg: review `06-lakehouse-iceberg/ddl/*.sql` templates

CI & Docs
- GitHub Actions workflow `./.github/workflows/dbt-ci.yml` (Snowflake secrets required) runs seed/run/test and generates docs.
- Docs publish workflow `./.github/workflows/dbt-docs-publish.yml` pushes generated docs to gh-pages (dbt-target in `dbt-docs/`).

Bootstrap
- On Windows PowerShell: `./bootstrap.ps1` to start Kafka and the API quickly.

Scenarios
- See `scenarios/real-time-payments.md` for an end-to-end payments monitoring and reporting flow (API → Kafka → Snowflake → dbt → Snowpark → Iceberg).
