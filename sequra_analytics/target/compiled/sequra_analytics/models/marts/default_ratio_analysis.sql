

-- This model calculates the default ratio as requested in Part 2

with orders_with_defaults as (
    -- This would come from the actual orders table with financial data
    select
        o.*,
        m.merchant_name as merchant,
        -- These fields would come from the actual source data:
        null::integer as shopper_age,
        null::varchar as product,
        null::boolean as is_in_default,
        null::integer as days_unbalanced,
        null::decimal(15,2) as current_order_value,
        null::decimal(15,2) as overdue_amount
    from SEQURA_DEV.dbt_maximerosa_staging.stg_orders o
    left join SEQURA_DEV.dbt_maximerosa_staging.stg_merchants m
        on o.merchant_id = m.merchant_id
),

-- Calculate delayed periods based on days_unbalanced
-- An order with 35 days unbalanced is included in both 17 and 30 day calculations
delayed_period_17 as (
    select
        shopper_age,
        month_year as month_year_order,
        product,
        merchant,
        'in_default' as default_type,
        '17' as delayed_period
    from orders_with_defaults
    where days_unbalanced > 17
        and is_in_default = true
),

delayed_period_30 as (
    select
        shopper_age,
        month_year as month_year_order,
        product,
        merchant,
        'in_default' as default_type,
        '30' as delayed_period
    from orders_with_defaults
    where days_unbalanced > 30
        and is_in_default = true
),

delayed_period_60 as (
    select
        shopper_age,
        month_year as month_year_order,
        product,
        merchant,
        'in_default' as default_type,
        '60' as delayed_period
    from orders_with_defaults
    where days_unbalanced > 60
        and is_in_default = true
),

delayed_period_90 as (
    select
        shopper_age,
        month_year as month_year_order,
        product,
        merchant,
        'in_default' as default_type,
        '90' as delayed_period
    from orders_with_defaults
    where days_unbalanced > 90
        and is_in_default = true
),

-- Union all delayed periods
all_defaults as (
    select * from delayed_period_17
    union all
    select * from delayed_period_30
    union all
    select * from delayed_period_60
    union all
    select * from delayed_period_90
)

-- Final output with the exact columns requested
select
    shopper_age,
    month_year_order,
    product,
    merchant,
    default_type,
    delayed_period
from all_defaults
order by 
    month_year_order,
    merchant,
    delayed_period::integer