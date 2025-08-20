
  
    

create or replace transient table SEQURA_DEV.dbt_maximerosa_marts.shopper_recurrence_rate
    
    
    
    as (

with monthly_metrics as (
    select
        ms.order_month,
        ms.month_year,
        ms.merchant_id,
        m.merchant_name,
        count(distinct ms.shopper_id) as total_shoppers,
        sum(rs.is_recurrent) as recurrent_shoppers
    from SEQURA_DEV.dbt_maximerosa_intermediate.int_monthly_shoppers ms
    left join SEQURA_DEV.dbt_maximerosa_intermediate.int_recurrent_shoppers rs
        on ms.order_month = rs.current_month
        and ms.merchant_id = rs.merchant_id
        and ms.shopper_id = rs.shopper_id
    left join SEQURA_DEV.dbt_maximerosa_staging.stg_merchants m
        on ms.merchant_id = m.merchant_id
    group by 1, 2, 3, 4
)

select
    merchant_name,
    month_year as month,
    round(
        case 
            when total_shoppers > 0 
            then (recurrent_shoppers::decimal / total_shoppers) * 100
            else 0 
        end, 2
    ) as recurrence_rate
from monthly_metrics
order by merchant_name, month
    )
;


  