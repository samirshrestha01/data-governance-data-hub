select
    order_id,
    order_purchase_at,
    order_delivered_customer_at,
    delivery_days
from {{ ref('fact_orders') }}
where delivery_days < 0