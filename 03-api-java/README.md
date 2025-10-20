Crossbring Java REST API (Spring Boot)

Purpose
- Provide a clean REST interface and publish POSTed events to Kafka, modeling a common API-to-stream pattern and data contract.

Run
- Ensure Kafka is running (see 02-streaming-kafka/infra)
- `mvn -q -DskipTests spring-boot:run`
- GET:  `curl http://localhost:8080/payments`
- POST: `curl -X POST http://localhost:8080/payments -H "Content-Type: application/json" -d '{"paymentId":7001,"accountId":2001,"amount":12.34,"status":"SETTLED","method":"CARD"}'`
- POST order: `curl -X POST http://localhost:8080/orders -H "Content-Type: application/json" -d '{"orderId":9001,"customerId":1001,"amount":49.99,"status":"PLACED","channel":"WEB"}'`
