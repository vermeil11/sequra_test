
  create or replace   view SEQURA_DEV.dbt_maximerosa_staging.stg_dim_shoppers
  
  
  
  
  as (
    

select
    shopper_id,
    age as shopper_age
from SEQURA_DEV.dbt_maximerosa_raw_data.dim_shoppers
  );

