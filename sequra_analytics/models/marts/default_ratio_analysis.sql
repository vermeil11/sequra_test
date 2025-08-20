{{
    config(
        materialized='table'
    )
}}

-- This model would calculate the default ratio as requested in Part 2
-- Default Ratio = Loans in Arrears / Total Loans Granted

with default_metrics as (
    select
        shopper_age,
        month_year as month_year_order,
        product,
        merchant_name as merchant,
        delayed_period as default_type,
        delayed_period,
        sum(case when is_in_default then current_order_value else 0 end) as debt_amount,
        sum(current_order_value) as total_order_value,
        count(case when is_in_default then 1 end) as orders_in_default,
        count(*) as total_orders
    from {{ ref('int_orders_with_defaults') }}
    where current_order_value is not null  -- Would filter when real data is available
    group by 1, 2, 3, 4, 5, 6
)

select
    shopper_age,
    month_year_order,
    product,
    merchant,
    default_type,
    delayed_period,
    debt_amount,
    total_order_value,
    orders_in_default,
    total_orders,
    round(
        case 
            when total_order_value > 0 
            then (debt_amount / total_order_value) * 100
            else 0 
        end, 2
    ) as default_ratio_percentage
from default_metrics
order by month_year_order, merchant, delayed_period