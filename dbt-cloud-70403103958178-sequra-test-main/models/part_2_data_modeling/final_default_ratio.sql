{{ config(materialized='table') }}

with default_ratio_calc as (
    select
        d.shopper_age,
        d.month_year_order,
        d.product_id,
        d.merchant_id,
        d.default_type,
        d.delayed_period,
        --d.debt,
        --t.total_loans,
        -- The default ratio is not asked in the exercise but I put it anyway here
        coalesce(d.debt, 0) / coalesce(t.total_loans, 1) as default_ratio
    from {{ ref('default_debt_STG') }} d

    left join {{ ref('total_loans_STG') }} t

    on d.shopper_age = t.shopper_age
        and d.month_year_order = t.month_year_order
        and d.product_id = t.product_id
        and d.merchant_id = t.merchant_id
        and d.delayed_period = t.delayed_period
)

select * from default_ratio_calc;