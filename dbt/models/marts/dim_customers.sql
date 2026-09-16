with customers as (

    select * 
    from {{ ref('stg_customers') }}

),

dim_customers as (

    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state

    from customers

)

select * 
from dim_customers