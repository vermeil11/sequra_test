
    
    

select
    merchant_id as unique_field,
    count(*) as n_records

from SEQURA_DEV.dbt_maximerosa_staging.stg_merchants
where merchant_id is not null
group by merchant_id
having count(*) > 1


