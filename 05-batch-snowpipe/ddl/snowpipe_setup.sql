-- Replace placeholders <> with your values
use role <ACCOUNTADMIN_OR_ROLE_WITH_PRIVS>;
use database <DATABASE>;

create schema if not exists raw;

create or replace file format json_ff type = json;

create or replace stage s3_events
  storage_integration = s3_int
  url = 's3://<your-bucket>/events/payments/'
  file_format = json_ff;

create or replace table raw.PAYMENTS_RAW (
  v variant,
  ingest_ts timestamp_ntz default current_timestamp()
);

create or replace pipe raw.payments_pipe
  auto_ingest = true
  as
copy into raw.PAYMENTS_RAW(v, ingest_ts)
  from (select $1, current_timestamp() from @s3_events)
  file_format = (format_name = json_ff);

-- ORDERS
create or replace stage s3_orders
  storage_integration = s3_int
  url = 's3://<your-bucket>/events/orders/'
  file_format = json_ff;

create or replace table raw.ORDERS_RAW (
  v variant,
  ingest_ts timestamp_ntz default current_timestamp()
);

create or replace pipe raw.orders_pipe
  auto_ingest = true
  as
copy into raw.ORDERS_RAW(v, ingest_ts)
  from (select $1, current_timestamp() from @s3_orders)
  file_format = (format_name = json_ff);
