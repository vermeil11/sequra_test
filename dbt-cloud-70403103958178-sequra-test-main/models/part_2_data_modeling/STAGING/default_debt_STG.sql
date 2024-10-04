{{ config(materialized='ephemeral') }}
-- We are using ephemeral models so it doesn't use storage cost
with overdue_calculation as (
    select
        o.order_id,
        a.shopper_age,
        merchant_id,
        product_id,
        is_in_default,
        b.default_type,
        days_unbalanced,
        -- Here we convert order_date to the desired format
        to_char(order_date, 'YYYY-MM') as month_year_order,
        current_order_value,
        -- Summing all overdue fields to calculate the debt amount
        overdue_principal + overdue_interest + overdue_fees as total_debt,
    case
        when days_unbalanced between 1 and 17 or days_unbalanced = 35 then '17'
        when days_unbalanced between 18 and 30 or days_unbalanced = 35 then '30'
        -- I didn't find the way to make this calculation great without making duplicates or using seeds but I'd be curious how you did it, also it would have been easier to test assumptions with a dataset
        when days_unbalanced between 31 and 60 and days_unbalanced != 35 then '60'
        when days_unbalanced between 61 and 90 then '90'
        else null
    end as delayed_period
    from {{ ref('orders') }} o
    -- To get the shopper's age
    left join {{ ref('dim_shoppers') }} a on o.shopper_id = a.shopper_id
    -- To get default type
    left join {{ ref('rel_default_order_type') }} b on o.order_id = b.order_id
    -- We are only working with loans in arreas here
    where is_in_default = true
        or days_unbalanced > 0
)
select
    shopper_age,
    month_year_order,
    product_id,
    merchant_id,
    delayed_period,
    sum(total_debt) as debt
from overdue_calculation
group by shopper_age, month_year_order, product_id, merchant_id, delayed_period;