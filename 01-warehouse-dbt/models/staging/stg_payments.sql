with src as (
  select
    cast(payment_id as number) as payment_id,
    cast(account_id as number) as account_id,
    cast(amount as number(18,2)) as amount,
    to_timestamp_ntz(ts) as ts,
    status,
    method
  from {{ ref('payments') }}
)
select * from src

