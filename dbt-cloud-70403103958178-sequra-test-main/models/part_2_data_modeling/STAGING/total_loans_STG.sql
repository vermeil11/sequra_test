{{ config(materialized='ephemeral') }}
-- We are using ephemeral models so it doesn't use storage cost
with loans as (
    select
        o.order_id,
        a.shopper_age,
        merchant_id,
        product_id,
        -- Here we convert order_date to the desired format
        to_char(order_date, 'YYYY-MM') as month_year_order,
        current_order_value,
    case
        when days_unbalanced between 1 and 17 or days_unbalanced = 35 then '17'
        when days_unbalanced between 18 and 30 or days_unbalanced = 35 then '30'
        -- I didn't find the way to make this calculation great without making duplicates or using seeds but I'd be curious how you did it
        when days_unbalanced between 31 and 60 and days_unbalanced != 35 then '60'
        when days_unbalanced between 61 and 90 then '90'
        else null
    end as delayed_period
    from {{ ref('orders') }} o
    left join {{ ref('dim_shoppers') }} a on o.shopper_id = a.shopper_id
)
select
    shopper_age,
    month_year_order,
    product,
    merchant,
    delayed_period,
    sum(current_order_value) as total_loans
from loans
group by shopper_age, month_year_order, product_id, merchant_id, delayed_period;
