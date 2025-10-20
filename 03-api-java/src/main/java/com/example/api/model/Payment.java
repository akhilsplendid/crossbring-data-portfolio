package com.example.api.model;

public record Payment(long paymentId, long accountId, double amount, String status, String method) {}
