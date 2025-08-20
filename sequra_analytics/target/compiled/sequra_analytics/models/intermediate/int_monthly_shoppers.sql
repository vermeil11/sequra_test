

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
    shopper_id,
    -- Flag if this shopper made a purchase with this merchant in the current month
    1 as made_purchase_current_month
from monthly_orders