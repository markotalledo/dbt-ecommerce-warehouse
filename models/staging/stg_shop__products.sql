select
    product_id,
    category,
    list_price_cents
from {{ ref('products') }}
