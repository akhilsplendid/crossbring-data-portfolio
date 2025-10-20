-- Example freshness checks using ingest_ts
-- Warn if last payment older than 15 minutes; error if > 60 minutes

with latest as (
  select max(ingest_ts) as max_ts from raw.PAYMENTS_RAW
)
select
  case when datediff('minute', max_ts, current_timestamp()) > 60 then 'ERROR'
       when datediff('minute', max_ts, current_timestamp()) > 15 then 'WARN'
       else 'OK' end as status,
  datediff('minute', max_ts, current_timestamp()) as minutes_since_last,
  max_ts
from latest;

-- Orders
with latest as (
  select max(ingest_ts) as max_ts from raw.ORDERS_RAW
)
select
  case when datediff('minute', max_ts, current_timestamp()) > 60 then 'ERROR'
       when datediff('minute', max_ts, current_timestamp()) > 15 then 'WARN'
       else 'OK' end as status,
  datediff('minute', max_ts, current_timestamp()) as minutes_since_last,
  max_ts
from latest;

