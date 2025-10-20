with src as (
  select
    cast(order_id as number) as order_id,
    cast(customer_id as number) as customer_id,
    cast(amount as number(18,2)) as amount,
    to_timestamp_ntz(ts) as ts,
    status,
    channel
  from {{ ref('orders') }}
)
select * from src

