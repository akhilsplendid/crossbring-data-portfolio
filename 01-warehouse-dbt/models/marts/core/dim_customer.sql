select customer_id, customer_name, country from {{ ref('stg_customers') }}

