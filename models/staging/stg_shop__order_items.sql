select
    order_id,
    line_number,
    customer_id,
    ordered_at,
    cast(event_date as date) as order_date,
    product_id,
    {% if var('inject_bug') -%}
    -- Deliberate bug for the demo: double the quantity of every first line.
    quantity * case when line_number = 1 then 2 else 1 end as quantity,
    {%- else -%}
    quantity,
    {%- endif %}
    unit_price_cents
from {{ source('shop', 'order_items') }}
