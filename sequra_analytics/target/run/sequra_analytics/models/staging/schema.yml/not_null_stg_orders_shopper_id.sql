
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select shopper_id
from SEQURA_DEV.dbt_maximerosa_staging.stg_orders
where shopper_id is null



  
  
      
    ) dbt_internal_test