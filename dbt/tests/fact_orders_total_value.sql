select order_id, total_price, total_freight_value, total_order_value
from {{ref('fact_orders')}}
where total_order_value!= total_price + total_freight_value