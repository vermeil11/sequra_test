
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select recurrence_rate
from SEQURA_DEV.dbt_maximerosa_marts.shopper_recurrence_rate
where recurrence_rate is null



  
  
      
    ) dbt_internal_test