select
  o.order_id,
  o.customer_id,
  o.amount,
  o.ts,
  o.status,
  o.channel
from {{ ref('stg_orders') }} o

