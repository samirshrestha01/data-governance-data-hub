with order_items_enriched as (

    select * from {{ ref('int_order_items') }}

),

fact_orders as (

    select
        order_id,
        customer_id,
        order_status,
        order_purchase_at,
        order_approved_at,
        order_delivered_carrier_at,
        order_delivered_customer_at,
        order_estimated_delivery_at,

        count(*) as item_count,
        sum(price) as total_price,
        sum(freight_value) as total_freight_value,
        sum(price + freight_value) as total_order_value,

         -- Delivery time in days
        extract(
            epoch from (
                order_delivered_customer_at - order_purchase_at
            )
        ) / 86400.0 as delivery_days,

        -- Difference between actual and estimated delivery
        extract(
            epoch from (
                order_delivered_customer_at - order_estimated_delivery_at
            )
        ) / 86400.0 as delivery_delay_days,

        -- 1 = late, 0 = on time
        case
            when order_delivered_customer_at > order_estimated_delivery_at
                then 1
            else 0
        end as is_late

    from order_items_enriched

    group by
        order_id,
        customer_id,
        order_status,
        order_purchase_at,
        order_approved_at,
        order_delivered_carrier_at,
        order_delivered_customer_at,
        order_estimated_delivery_at

)

select * from fact_orders