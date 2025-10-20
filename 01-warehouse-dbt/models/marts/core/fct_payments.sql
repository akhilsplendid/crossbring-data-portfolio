select
  p.payment_id,
  p.account_id,
  a.customer_id,
  p.amount,
  p.ts,
  p.status,
  p.method
from {{ ref('stg_payments') }} p
join {{ ref('stg_accounts') }} a on p.account_id = a.account_id

