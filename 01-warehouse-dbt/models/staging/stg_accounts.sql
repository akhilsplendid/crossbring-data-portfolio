with src as (
  select
    cast(account_id as number) as account_id,
    cast(customer_id as number) as customer_id,
    iban,
    currency
  from {{ ref('accounts') }}
)
select * from src

