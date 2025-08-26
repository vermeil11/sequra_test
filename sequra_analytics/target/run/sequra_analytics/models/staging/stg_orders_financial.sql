
  create or replace   view SEQURA_DEV.dbt_maximerosa_staging.stg_orders_financial
  
  
  
  
  as (
    

select
    order_id,
    shopper_id,
    to_date(order_date) as order_date,
    date_trunc('month', to_date(order_date)) as order_month,
    to_char(to_date(order_date), 'YYYY-MM') as month_year_order,
    product_id,
    case product_id
        when 1 then 'FlexPay'
        when 2 then 'PayLater'
        when 3 then 'DirectPay'
        else 'Product_' || product_id::varchar
    end as product,
    merchant_id,
    is_in_default,
    days_unbalanced,
    current_order_value,
    overdue_principal,
    overdue_fees,
    overdue_principal + overdue_fees as total_overdue
from SEQURA_DEV.dbt_maximerosa_raw_data.orders_financial
  );

