-- Every order must have a captured payment for exactly its total.
select order_id, total_cents, paid_cents, reconciliation_status
from {{ ref('fct_orders') }}
where reconciliation_status <> 'matched'
