
  create or replace   view SEQURA_DEV.dbt_maximerosa_staging.stg_merchants
  
  
  
  
  as (
    

select
    merchant_id,
    merchant_name
from SEQURA_DEV.dbt_maximerosa.merchants
  );

