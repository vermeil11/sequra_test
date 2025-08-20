
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select merchant_id
from SEQURA_DEV.dbt_maximerosa_staging.stg_orders
where merchant_id is null



  
  
      
    ) dbt_internal_test