with customers as (

    select * 
    from {{ ref('stg_customers') }}

),

ranked_customers as (

    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,

        row_number() over (
            partition by customer_unique_id
            order by customer_id
        ) as row_num

    from customers

),

dim_customers as (

    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state

    from ranked_customers
    where row_num = 1

)

select * 
from dim_customers