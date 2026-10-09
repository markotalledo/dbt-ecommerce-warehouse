-- Every order total must equal the sum of its lines.
select order_id, total_cents, lines_total_cents
from {{ ref('fct_orders') }}
where lines_total_cents is distinct from total_cents
