{% set src = source('raw', 'PAYMENTS_RAW') %}

with src as (
  select * from {{ src }}
), json_rows as (
  select coalesce(try_parse_json(RECORD_CONTENT)::variant, $1::variant) as v from src
), normalized as (
  select
    v:payment_id::number as payment_id,
    v:account_id::number as account_id,
    v:amount::number(18,2) as amount,
    to_timestamp_ntz(v:ts::string) as ts,
    upper(v:status::string) as status,
    upper(v:method::string) as method,
    current_timestamp() as processed_at,
    datediff('second', to_timestamp_ntz(v:ts::string), current_timestamp()) as event_age_sec
  from json_rows
)
select * from normalized
