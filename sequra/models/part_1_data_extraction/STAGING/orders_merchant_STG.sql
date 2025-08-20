{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('public_hub', 'orders_merchant') }}
)

select *
from source