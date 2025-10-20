package com.example.api.controller;

import com.example.api.model.Payment;
import com.example.api.service.KafkaPublisher;
import com.example.api.service.JsonValidationService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.example.api.model.Order;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
public class PaymentController {
    private final KafkaPublisher publisher;
    private final JsonValidationService validator;
    private final ObjectMapper mapper = new ObjectMapper();

    public PaymentController(KafkaPublisher publisher, JsonValidationService validator) {
        this.publisher = publisher;
        this.validator = validator;
    }

    @GetMapping("/payments")
    public List<Payment> list() {
        return List.of(
                new Payment(5001, 2001, 100.5, "SETTLED", "CARD"),
                new Payment(5002, 2002, 75.0, "PENDING", "TRANSFER")
        );
    }

    @PostMapping("/payments")
    public Payment publish(@RequestBody Payment payment) {
        JsonNode node = mapper.valueToTree(payment);
        validator.validatePayment(node);
        publisher.publish(payment);
        return payment;
    }

    @PostMapping("/orders")
    public Order publishOrder(@RequestBody Order order) {
        JsonNode node = mapper.valueToTree(order);
        validator.validateOrder(node);
        publisher.publishToTopic("orders", order, String.valueOf(order.orderId()));
        return order;
    }
}
