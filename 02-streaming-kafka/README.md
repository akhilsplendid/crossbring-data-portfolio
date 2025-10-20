Crossbring Kafka Streaming (Java)

Run locally
1) Start Kafka: `cd infra && docker compose up -d`
2) Payment Producer: `cd ../java-producer && mvn -q -DskipTests package && java -jar target/java-producer-1.0.0.jar`
   - Order Producer: `java -cp target/java-producer-1.0.0.jar com.example.stream.OrderProducer`
3) Consumer: `cd ../java-consumer && mvn -q -DskipTests package && java -jar target/java-consumer-1.0.0.jar`

Connector reference
- See `connect/snowflake-kafka-connector.properties` for Snowflake sink configuration placeholders (maps `payments` → `PAYMENTS_RAW`, `orders` → `ORDERS_RAW`).
