select
    items.order_id,
    items.line_number,
    items.customer_id,
    items.order_date,
    items.product_id,
    products.category,
    items.quantity,
    items.unit_price_cents,
    items.quantity * items.unit_price_cents as line_total_cents,
    items.unit_price_cents - products.list_price_cents as price_vs_list_cents
from {{ ref('stg_shop__order_items') }} as items
left join {{ ref('stg_shop__products') }} as products using (product_id)
