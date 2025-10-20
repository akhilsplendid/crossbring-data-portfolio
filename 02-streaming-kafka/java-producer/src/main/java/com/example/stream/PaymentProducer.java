package com.example.stream;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.serialization.StringSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Properties;
import java.util.Random;
import java.time.Instant;

public class PaymentProducer {
    static class PaymentEvent {
        public long payment_id;
        public long account_id;
        public double amount;
        public String status;
        public String method;
        public String ts;
    }

    public static void main(String[] args) throws Exception {
        String bootstrap = System.getenv().getOrDefault("KAFKA_BOOTSTRAP", "localhost:9092");
        String topic = System.getenv().getOrDefault("KAFKA_TOPIC", "payments");
        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrap);
        props.put("key.serializer", StringSerializer.class.getName());
        props.put("value.serializer", StringSerializer.class.getName());
        ObjectMapper mapper = new ObjectMapper();
        Random rnd = new Random();
        try (KafkaProducer<String, String> producer = new KafkaProducer<>(props)) {
            for (int i = 0; i < 25; i++) {
                PaymentEvent ev = new PaymentEvent();
                ev.payment_id = 3000 + i;
                ev.account_id = 2000 + (i % 3) + 1;
                ev.amount = Math.round((50 + rnd.nextDouble() * 1500) * 100.0) / 100.0;
                ev.status = (i % 7 == 0) ? "FAILED" : ((i % 3 == 0) ? "PENDING" : "SETTLED");
                ev.method = (i % 2 == 0) ? "CARD" : "TRANSFER";
                ev.ts = Instant.now().toString();
                String key = String.valueOf(ev.payment_id);
                String value = mapper.writeValueAsString(ev);
                ProducerRecord<String, String> record = new ProducerRecord<>(topic, key, value);
                RecordMetadata meta = producer.send(record).get();
                System.out.printf("Produced %s to %s-%d@%d%n", key, meta.topic(), meta.partition(), meta.offset());
                Thread.sleep(200);
            }
        }
    }
}

