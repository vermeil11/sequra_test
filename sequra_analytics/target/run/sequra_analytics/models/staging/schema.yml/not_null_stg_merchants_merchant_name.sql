
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select merchant_name
from SEQURA_DEV.dbt_maximerosa_staging.stg_merchants
where merchant_name is null



  
  
      
    ) dbt_internal_test