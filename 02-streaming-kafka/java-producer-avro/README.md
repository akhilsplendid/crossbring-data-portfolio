Crossbring Kafka Avro Producer (optional)

Notes
- Requires Confluent Schema Registry and dependencies.
- Uses GenericRecord with Avro schemas in `src/main/avro/`.

Run
- Set `SCHEMA_REGISTRY_URL` and `KAFKA_BOOTSTRAP`
- `mvn -q -DskipTests package && java -jar target/java-producer-avro-1.0.0.jar`

