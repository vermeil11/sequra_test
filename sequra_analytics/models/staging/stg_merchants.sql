{{
    config(
        materialized='view'
    )
}}

select
    merchant_id,
    merchant_name
from {{ ref('merchants') }}