Crossbring CDC: MSSQL → Kafka → Snowflake

What this includes
- T-SQL to enable database/table CDC
- Debezium SQL Server connector config (JSON)
- Snowflake Kafka connector mapping for CDC topics
- dbt staging model template for Debezium envelope

Flow
SQL Server (CDC enabled) → Debezium connector → Kafka topic → Snowflake Kafka Connector → raw CDC table → dbt normalize

Notes
- Replace placeholders for servers, creds, and Snowflake account.
- Use Azure SQL or self-hosted MSSQL; ensure SQL Agent is enabled for CDC.

