package com.example.api.service;

import com.example.api.model.Payment;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import java.util.Properties;

@Component
public class KafkaPublisher {
    @Value("${kafka.bootstrap:localhost:9092}")
    private String bootstrap;

    @Value("${kafka.topic:payments}")
    private String topic;

    private final ObjectMapper mapper = new ObjectMapper();
    private KafkaProducer<String, String> producer;

    @PostConstruct
    public void init() {
        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrap);
        props.put("key.serializer", StringSerializer.class.getName());
        props.put("value.serializer", StringSerializer.class.getName());
        producer = new KafkaProducer<>(props);
    }

    @PreDestroy
    public void shutdown() {
        if (producer != null) {
            producer.close();
        }
    }

    public void publish(Payment payment) {
        try {
            String key = String.valueOf(payment.paymentId());
            String value = mapper.writeValueAsString(payment);
            producer.send(new ProducerRecord<>(topic, key, value));
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to serialize payment", e);
        }
    }

    public void publishToTopic(String targetTopic, Object payload, String key) {
        try {
            String value = mapper.writeValueAsString(payload);
            producer.send(new ProducerRecord<>(targetTopic, key, value));
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to serialize payload", e);
        }
    }
}
