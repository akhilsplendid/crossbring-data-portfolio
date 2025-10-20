param(
  [string]$KafkaDir = "02-streaming-kafka/infra",
  [string]$ApiDir = "03-api-java"
)

Write-Host "Starting Kafka..." -ForegroundColor Cyan
Push-Location $KafkaDir
docker compose up -d
Pop-Location

Write-Host "Starting API..." -ForegroundColor Cyan
Push-Location $ApiDir
mvn -q -DskipTests spring-boot:run
Pop-Location

