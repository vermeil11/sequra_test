{{
    config(
        materialized='view'
    )
}}

with monthly_orders as (
    select distinct
        order_month,
        month_year,
        merchant_id,
        shopper_id
    from {{ ref('stg_orders') }}
)

select
    order_month,
    month_year,
    merchant_id,
    shopper_id
from monthly_orders