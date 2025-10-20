package com.example.api.model;

public record Order(long orderId, long customerId, double amount, String status, String channel) {}

