-- Debezium SQL Server CDC normalized example (after unwrap)
-- Assumes raw.ORDERS_CDC with VARIANT column v and optional metadata

{% set src = source('raw', 'ORDERS_CDC') %}

with src as (
  select * from {{ src }}
), json_rows as (
  select coalesce(try_parse_json(RECORD_CONTENT)::variant, $1::variant) as v from src
), normalized as (
  select
    v:order_id::number as order_id,
    v:customer_id::number as customer_id,
    v:amount::number(18,2) as amount,
    to_timestamp_ntz(v:ts::string) as ts,
    upper(v:status::string) as status,
    upper(v:channel::string) as channel,
    current_timestamp() as processed_at
  from json_rows
)
select * from normalized

