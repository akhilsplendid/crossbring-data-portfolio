package com.example.stream.avro;

import io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig;
import io.confluent.kafka.serializers.KafkaAvroSerializer;
import org.apache.avro.Schema;
import org.apache.avro.generic.GenericData;
import org.apache.avro.generic.GenericRecord;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.serialization.StringSerializer;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.Instant;
import java.util.Properties;
import java.util.Random;

public class PaymentAvroProducer {
    public static void main(String[] args) throws Exception {
        String bootstrap = System.getenv().getOrDefault("KAFKA_BOOTSTRAP", "localhost:9092");
        String topic = System.getenv().getOrDefault("KAFKA_TOPIC", "payments-avro");
        String registry = System.getenv().getOrDefault("SCHEMA_REGISTRY_URL", "http://localhost:8081");

        String schemaStr = Files.readString(Paths.get("src/main/avro/payment.avsc"));
        Schema schema = new Schema.Parser().parse(schemaStr);

        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrap);
        props.put("key.serializer", StringSerializer.class.getName());
        props.put("value.serializer", KafkaAvroSerializer.class.getName());
        props.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, registry);

        Random rnd = new Random();
        try (KafkaProducer<String, Object> producer = new KafkaProducer<>(props)) {
            for (int i = 0; i < 10; i++) {
                GenericRecord rec = new GenericData.Record(schema);
                long id = 9000 + i;
                rec.put("payment_id", id);
                rec.put("account_id", 2000 + (i % 3) + 1);
                rec.put("amount", Math.round((50 + rnd.nextDouble() * 1500) * 100.0) / 100.0);
                rec.put("status", (i % 7 == 0) ? "FAILED" : ((i % 3 == 0) ? "PENDING" : "SETTLED"));
                rec.put("method", (i % 2 == 0) ? "CARD" : "TRANSFER");
                rec.put("ts", Instant.now().toString());
                RecordMetadata meta = producer.send(new ProducerRecord<>(topic, String.valueOf(id), rec)).get();
                System.out.printf("Produced AVRO %s to %s-%d@%d%n", id, meta.topic(), meta.partition(), meta.offset());
            }
        }
    }
}

