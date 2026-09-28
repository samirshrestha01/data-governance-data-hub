select
    order_id,
    order_delivered_customer_at,
    order_estimated_delivery_at,
    is_late
from {{ ref('fact_orders') }}
where
    (
        order_delivered_customer_at > order_estimated_delivery_at
        and is_late != 1
    )
    or
    (
        order_delivered_customer_at <= order_estimated_delivery_at
        and is_late != 0
    )