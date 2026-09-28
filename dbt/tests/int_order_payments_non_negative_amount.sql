select order_id, payment_record_number, payment_type, payment_amount
from {{ref('int_order_payments')}}
where payment_amount < 0 