Write-Host "[1/6] Starting Kafka" -ForegroundColor Cyan
pushd 02-streaming-kafka/infra
docker compose up -d
popd

Write-Host "[2/6] Building Java modules" -ForegroundColor Cyan
pushd 02-streaming-kafka/java-producer; mvn -q -DskipTests package; popd
pushd 02-streaming-kafka/java-consumer; mvn -q -DskipTests package; popd
pushd 03-api-java; mvn -q -DskipTests package; popd

Write-Host "[3/6] Starting API" -ForegroundColor Cyan
pushd 03-api-java
start "api" cmd /c "mvn -q -DskipTests spring-boot:run"
popd

Write-Host "[4/6] Producing sample events" -ForegroundColor Cyan
java -jar 02-streaming-kafka/java-producer/target/java-producer-1.0.0.jar
java -cp 02-streaming-kafka/java-producer/target/java-producer-1.0.0.jar com.example.stream.OrderProducer

Write-Host "[5/6] Running dbt pipeline" -ForegroundColor Cyan
pushd 01-warehouse-dbt
dbt deps; dbt seed --full-refresh; dbt run; dbt test
popd

Write-Host "[6/6] Snowpark KPIs" -ForegroundColor Cyan
pushd 04-processing-snowpark
pip install -r requirements.txt
python app/transform.py
popd

Write-Host "Done."

