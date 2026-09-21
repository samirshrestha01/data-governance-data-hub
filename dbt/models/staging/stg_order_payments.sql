with source as (
    select * from {{source('raw', 'olist_order_payments')}}
),

renamed as (
    select order_id, payment_sequential as payment_record_number, 
    payment_type, 
    payment_installments as installment_count,
    payment_value as payment_amount
    from source
)

select * from renamed