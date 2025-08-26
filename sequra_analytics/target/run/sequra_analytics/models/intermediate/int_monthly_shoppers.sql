
  create or replace   view SEQURA_DEV.dbt_maximerosa_intermediate.int_monthly_shoppers
  
  
  
  
  as (
    

with monthly_orders as (
    select distinct
        order_month,
        month_year,
        merchant_id,
        shopper_id
    from SEQURA_DEV.dbt_maximerosa_staging.stg_orders
)

select
    order_month,
    month_year,
    merchant_id,
    shopper_id
from monthly_orders
  );

