{{
    config(
        materialized='view'
    )
}}

with source_data as (
    select
        order_id,
        shopper_id,
        merchant_id,
        order_date as order_date_raw,
        -- Parse the date format (d/m/yy or dd/mm/yy) -> handles both "9/9/22" and "09/09/22" formats
        case 
            when split_part(order_date, '/', 3) = '22' then '2022'
            when split_part(order_date, '/', 3) = '23' then '2023'
            else '20' || split_part(order_date, '/', 3)
        end || '-' ||
        lpad(split_part(order_date, '/', 2), 2, '0') || '-' ||
        lpad(split_part(order_date, '/', 1), 2, '0') as order_date_formatted
    from {{ ref('orders_merchant') }}
)

select
    order_id,
    shopper_id,
    merchant_id,
    order_date_raw,
    to_date(order_date_formatted, 'YYYY-MM-DD') as order_date,
    date_trunc('month', to_date(order_date_formatted, 'YYYY-MM-DD')) as order_month,
    to_char(to_date(order_date_formatted, 'YYYY-MM-DD'), 'YYYY-MM') as month_year
from source_data
where order_date_raw is not null