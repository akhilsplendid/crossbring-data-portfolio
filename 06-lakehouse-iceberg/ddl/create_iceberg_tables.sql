use database DATA_PRODUCTS;
use schema ICEBERG_DEMO;

create or replace iceberg table payments_iceberg
  external_volume = ev_iceberg
  catalog = 'SNOWFLAKE'
  as
select 1::number as payment_id, 2001::number as account_id, 100.50::number(18,2) as amount, 'SETTLED'::string as status;

select * from payments_iceberg;

