#!/usr/bin/env bash
set -euo pipefail

echo "[1/6] Starting Kafka"
(cd 02-streaming-kafka/infra && docker compose up -d)

echo "[2/6] Building Java modules"
(cd 02-streaming-kafka/java-producer && mvn -q -DskipTests package)
(cd 02-streaming-kafka/java-consumer && mvn -q -DskipTests package)
(cd 03-api-java && mvn -q -DskipTests package)

echo "[3/6] Starting API"
(cd 03-api-java && nohup mvn -q -DskipTests spring-boot:run >/tmp/api.log 2>&1 &)

echo "[4/6] Producing sample events"
java -jar 02-streaming-kafka/java-producer/target/java-producer-1.0.0.jar
java -cp 02-streaming-kafka/java-producer/target/java-producer-1.0.0.jar com.example.stream.OrderProducer

echo "[5/6] Running dbt pipeline"
(cd 01-warehouse-dbt && dbt deps && dbt seed --full-refresh && dbt run && dbt test)

echo "[6/6] Snowpark KPIs"
(cd 04-processing-snowpark && pip install -r requirements.txt && python app/transform.py)

echo "Done."

