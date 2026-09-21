select
    order_id,
    payment_record_number,
    payment_type,
    installment_count,
    payment_amount,
     order_purchase_at

from {{ ref('int_order_payments') }}