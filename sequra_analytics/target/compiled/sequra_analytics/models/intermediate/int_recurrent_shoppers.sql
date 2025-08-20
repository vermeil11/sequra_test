

with order_history as (
    select
        o1.order_month as current_month,
        o1.month_year as current_month_year,
        o1.merchant_id,
        o1.shopper_id,
        count(distinct o2.order_month) as months_with_purchases
    from SEQURA_DEV.dbt_maximerosa_staging.stg_orders o1
    left join SEQURA_DEV.dbt_maximerosa_staging.stg_orders o2
        on o1.merchant_id = o2.merchant_id
        and o1.shopper_id = o2.shopper_id
        and o2.order_date between dateadd(month, -11, o1.order_month) and last_day(o1.order_month)
        and o2.order_month <= o1.order_month
    group by 1, 2, 3, 4
)

select
    current_month,
    current_month_year,
    merchant_id,
    shopper_id,
    months_with_purchases,
    -- A shopper is recurrent if they have made purchases in at least 2 different months
    -- within the 12-month window including the current month
    case 
        when months_with_purchases >= 2 then 1 
        else 0 
    end as is_recurrent
from order_history