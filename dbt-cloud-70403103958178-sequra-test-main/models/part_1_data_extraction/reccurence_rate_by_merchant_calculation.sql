{{ config(materialized='table') }}

with monthly_shoppers as (
-- Here we calculate the total amount of unique shoppers by merchant and by month
    select
        o.merchant_id,
        m.merchant_name,
        DATE_TRUNC('month', o.order_date) as month,
        count(distinct o.shopper_id) as total_shoppers
    from {{ ref('orders_merchant_STG') }} o
    join {{ ref('merchant_name_STG') }} m ON o.merchant_id = m.merchant_id
    group by o.merchant_id, m.merchant_name, month
    order by month, merchant_name asc
),

recurring_shoppers as (
-- Here we calculate the amount of reccuring shoppers by merchant and by month
select
    o1.merchant_id,
    m.merchant_name,
    DATE_TRUNC('month', o1.order_date) as month,
    count(distinct o1.shopper_id) as recurring_shoppers
from {{ ref('orders_merchant_STG') }} o1
-- Self join to compare with previous data and isolate the shoppers that already made a purchase with the same shop or made several purchases in the same month and with the same merchant
join {{ ref('orders_merchant_STG') }} o2 
    on o1.shopper_id = o2.shopper_id
    and o1.merchant_id = o2.merchant_id
    and o1.order_date >= o2.order_date
    and o2.order_date BETWEEN o1.order_date - interval '12 months' and o1.order_date - interval '1 day'
join {{ ref('merchant_name_STG') }} m on o1.merchant_id = m.merchant_id
group by o1.merchant_id, m.merchant_name, month
)

-- Calculation of the reccurence rate, using COALESCE to apply 0 if a merchant have no reccuring shoppers instead of null
select
    ms.merchant_name,
    ms.month,
    coalesce(rs.recurring_shoppers, 0) * 100.0 / nullif(ms.total_shoppers, 0) as recurrence_rate
from monthly_shoppers ms
left join recurring_shoppers rs
    on ms.merchant_id = rs.merchant_id AND ms.month = rs.month
order by month, merchant_name