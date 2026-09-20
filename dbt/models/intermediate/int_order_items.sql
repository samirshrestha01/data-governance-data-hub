with order_items as (

    select *
    from {{ ref('stg_order_items') }}

),

orders as (

    select *
    from {{ ref('stg_orders') }}

),

products as (
    select * from {{ref('stg_products') }}
),

product_categories as (
    select * from {{ref('stg_product_categories') }}
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

        p.product_category_name,
        pc.product_category_name_english,

        oi.price,
        oi.freight_value,
        oi.price + oi.freight_value as item_revenue

    from order_items oi

    left join orders o
        on oi.order_id = o.order_id

    left join products p
        on oi.product_id = p.product_id

    left join product_categories pc
        on p.product_category_name = pc.product_category_name

)

select *
from joined