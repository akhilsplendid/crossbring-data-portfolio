import json
from pathlib import Path
from snowflake.snowpark.session import Session
from snowflake.snowpark import functions as F


def get_session():
    cfg_path = Path(__file__).parent / "config.json"
    if not cfg_path.exists():
        raise RuntimeError("Missing config.json. Copy from config.example.json and fill in.")
    with open(cfg_path) as f:
        cfg = json.load(f)
    return Session.builder.configs(cfg).create()


def run():
    session = get_session()
    table = "PAYMENTS_ENRICHED"

    data = [
        {"payment_id": 4001, "account_id": 2001, "amount": 250.25, "status": "SETTLED", "method": "CARD"},
        {"payment_id": 4002, "account_id": 2002, "amount": 999.99, "status": "PENDING", "method": "TRANSFER"},
        {"payment_id": 4003, "account_id": 2003, "amount": 10.0, "status": "FAILED", "method": "CARD"},
    ]
    df = session.create_dataframe(data)

    df2 = (
        df.with_column(
            "amount_bucket",
            F.when(F.col("amount") < 100, F.lit("LOW")).when(F.col("amount") < 1000, F.lit("MEDIUM")).otherwise(F.lit("HIGH")),
        ).with_column("is_risky", (F.col("status") == F.lit("FAILED")).cast("boolean"))
    )

    df2.write.mode("append").save_as_table(table)

    total = session.table(table).count()
    failed = session.table(table).filter(F.col("status") == F.lit("FAILED")).count()
    pct_failed = 0 if total == 0 else round(failed * 100.0 / total, 2)
    print({"rows": total, "%failed": pct_failed})
    session.close()


if __name__ == "__main__":
    run()

