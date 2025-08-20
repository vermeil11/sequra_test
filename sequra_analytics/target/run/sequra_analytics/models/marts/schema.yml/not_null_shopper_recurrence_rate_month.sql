
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select month
from SEQURA_DEV.dbt_maximerosa_marts.shopper_recurrence_rate
where month is null



  
  
      
    ) dbt_internal_test