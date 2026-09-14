with order_items as (

    select *
    from {{ ref('stg_order_items') }}

),

orders as (

    select *
    from {{ ref('stg_orders') }}

),

joined as (

    select
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,

        o.customer_id,
        o.order_status,
        o.order_purchase_at,
        o.order_approved_at,
        o.order_delivered_carrier_at,
        o.order_delivered_customer_at,
        o.order_estimated_delivery_at,

        oi.price,
        oi.freight_value

    from order_items oi

    left join orders o
        on oi.order_id = o.order_id

)

select *
from joined