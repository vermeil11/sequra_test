{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('public_hub', 'merchant_name') }}
)

select *
from source