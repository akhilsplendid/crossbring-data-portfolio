package com.example.api.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.networknt.schema.JsonSchema;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.SpecVersion;
import com.networknt.schema.ValidationMessage;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.Set;

@Component
public class JsonValidationService {
    private final ObjectMapper mapper = new ObjectMapper();
    private final JsonSchema paymentSchema;
    private final JsonSchema orderSchema;

    public JsonValidationService() {
        try {
            JsonSchemaFactory factory = JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012);
            try (InputStream in = new ClassPathResource("schemas/payment.schema.json").getInputStream()) {
                paymentSchema = factory.getSchema(in);
            }
            try (InputStream in = new ClassPathResource("schemas/order.schema.json").getInputStream()) {
                orderSchema = factory.getSchema(in);
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to load JSON schemas", e);
        }
    }

    public void validatePayment(JsonNode node) {
        Set<ValidationMessage> errors = paymentSchema.validate(node);
        if (!errors.isEmpty()) {
            throw new IllegalArgumentException("Invalid payment payload: " + errors);
        }
    }

    public void validateOrder(JsonNode node) {
        Set<ValidationMessage> errors = orderSchema.validate(node);
        if (!errors.isEmpty()) {
            throw new IllegalArgumentException("Invalid order payload: " + errors);
        }
    }
}

