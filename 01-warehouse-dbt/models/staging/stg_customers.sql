with src as (
  select
    cast(customer_id as number) as customer_id,
    customer_name,
    country
  from {{ ref('customers') }}
)
select * from src

