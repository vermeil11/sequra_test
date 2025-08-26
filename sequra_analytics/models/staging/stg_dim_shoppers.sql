{{
    config(
        materialized='view'
    )
}}

select
    shopper_id,
    age as shopper_age
from {{ ref('dim_shoppers') }}