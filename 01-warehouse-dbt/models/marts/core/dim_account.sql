select account_id, customer_id, iban, currency from {{ ref('stg_accounts') }}

