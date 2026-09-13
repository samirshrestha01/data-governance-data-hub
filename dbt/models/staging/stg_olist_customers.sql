SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    _airbyte_extracted_at
FROM {{ source('olist', 'olist_customers') }}