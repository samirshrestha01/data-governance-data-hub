with payments as (
    select *
    from {{ ref('stg_order_payments') }}
),

orders as (
    select
        order_id,
        order_purchase_at
    from {{ ref('stg_orders') }}
)

select
    p.order_id,
    p.payment_record_number,
    p.payment_type,
    p.installment_count,
    p.payment_amount,
    o.order_purchase_at
from payments p
left join orders o
    on p.order_id = o.order_id