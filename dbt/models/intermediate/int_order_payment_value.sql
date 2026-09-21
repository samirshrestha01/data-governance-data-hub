with payments as (

    select
        order_id,
        payment_type
    from {{ ref('int_order_payments') }}
    group by
        order_id,
        payment_type

),

orders as (

    select
        order_id,
        total_order_value
    from {{ ref('fact_orders') }}

)

select
    p.order_id,
    p.payment_type,
    o.total_order_value

from payments p

inner join orders o
    on p.order_id = o.order_id