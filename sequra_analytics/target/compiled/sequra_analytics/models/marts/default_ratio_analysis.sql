

-- Now we properly use the intermediate model!
with base_data as (
    select * from SEQURA_DEV.dbt_maximerosa_intermediate.int_orders_with_defaults
    where is_in_default = true  -- Only defaults for this analysis
),

-- Generate records for each applicable delayed period using UNION ALL
-- This implements the cumulative logic: 35 days appears in both 17 and 30
expanded_periods as (
    -- Period 17: All orders with days_unbalanced > 17
    select
        shopper_age,
        month_year_order,
        product,
        merchant,
        'in_default' as default_type,
        '17' as delayed_period
    from base_data
    where days_unbalanced > 17
    
    union all
    
    -- Period 30: All orders with days_unbalanced > 30
    select
        shopper_age,
        month_year_order,
        product,
        merchant,
        'in_default' as default_type,
        '30' as delayed_period
    from base_data
    where days_unbalanced > 30
    
    union all
    
    -- Period 60: All orders with days_unbalanced > 60
    select
        shopper_age,
        month_year_order,
        product,
        merchant,
        'in_default' as default_type,
        '60' as delayed_period
    from base_data
    where days_unbalanced > 60
    
    union all
    
    -- Period 90: All orders with days_unbalanced > 90
    select
        shopper_age,
        month_year_order,
        product,
        merchant,
        'in_default' as default_type,
        '90' as delayed_period
    from base_data
    where days_unbalanced > 90
)

-- Final output with exact columns requested
select distinct
    shopper_age,
    month_year_order,
    product,
    merchant,
    default_type,
    delayed_period
from expanded_periods
where merchant is not null  -- Exclude records without merchant mapping
order by 
    month_year_order,
    merchant,
    cast(delayed_period as integer)