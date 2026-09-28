select
    order_id,
    order_item_id,
    price,
    freight_value,
    item_revenue
from {{ ref('int_order_items') }}
where item_revenue != price + freight_value