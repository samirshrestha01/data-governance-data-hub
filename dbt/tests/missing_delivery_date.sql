-- dbt singular test: should return 0 rows to pass

select order_id

from {{ ref('stg_orders') }}

where order_status = 'delivered'

  and order_delivered_customer_at is null

