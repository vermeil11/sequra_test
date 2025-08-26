
  create or replace   view SEQURA_DEV.dbt_maximerosa_intermediate.int_orders_with_defaults
  
  
  
  
  as (
    

with orders_enriched as (
    select
        -- Order information
        o.order_id,
        o.order_date,
        o.order_month,
        o.month_year_order,
        
        -- Product and merchant
        o.product_id,
        o.product,
        o.merchant_id,
        m.merchant_name as merchant,
        
        -- Shopper information
        o.shopper_id,
        s.shopper_age,
        
        -- Financial metrics
        o.is_in_default,
        o.days_unbalanced,
        o.current_order_value,
        o.overdue_principal,
        o.overdue_fees,
        o.total_overdue,
        
        -- Calculated delayed period (for filtering, not cumulative)
        case
            when o.days_unbalanced > 90 then '90'
            when o.days_unbalanced > 60 then '60'
            when o.days_unbalanced > 30 then '30'
            when o.days_unbalanced > 17 then '17'
            else null
        end as max_delayed_period
        
    from SEQURA_DEV.dbt_maximerosa_staging.stg_orders_financial o
    left join SEQURA_DEV.dbt_maximerosa_staging.stg_dim_shoppers s
        on o.shopper_id = s.shopper_id
    left join SEQURA_DEV.dbt_maximerosa_staging.stg_merchants m
        on o.merchant_id = m.merchant_id
)

select * from orders_enriched
  );

