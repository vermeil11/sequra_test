

-- Placeholder for Part 2 of the challenge
-- This would contain the logic for calculating default ratios
-- when the additional data tables are available

with orders_base as (
    select
        o.*,
        m.merchant_name,
        -- Placeholder fields for default calculation
        -- These would come from the actual orders table with financial data
        null::boolean as is_in_default,
        null::integer as days_unbalanced,
        null::decimal(15,2) as current_order_value,
        null::decimal(15,2) as overdue_amount,
        null::varchar as product,
        null::integer as shopper_age
    from SEQURA_DEV.dbt_maximerosa_staging.stg_orders o
    left join SEQURA_DEV.dbt_maximerosa_staging.stg_merchants m
        on o.merchant_id = m.merchant_id
)

select
    *,
    case
        when days_unbalanced > 90 then '90+'
        when days_unbalanced > 60 then '60'
        when days_unbalanced > 30 then '30'
        when days_unbalanced > 17 then '17'
        else null
    end as delayed_period
from orders_base