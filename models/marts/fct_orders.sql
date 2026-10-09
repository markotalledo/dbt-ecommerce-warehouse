-- One row per order, reconciled three ways: the order event, its lines, and the payment.
with orders as (
    select
        order_id,
        customer_id,
        session_id,
        app_source,
        occurred_at as ordered_at,
        event_date as order_date,
        total_cents,
        currency
    from {{ ref('stg_shop__events') }}
    where event_name = 'order_completed'
),

payments as (
    select
        order_id,
        amount_cents as paid_cents,
        payment_method,
        occurred_at as paid_at
    from {{ ref('stg_shop__events') }}
    where event_name = 'payment_captured'
),

lines as (
    select
        order_id,
        count(*) as line_count,
        sum(quantity) as units,
        sum(quantity * unit_price_cents) as lines_total_cents
    from {{ ref('stg_shop__order_items') }}
    group by order_id
)

select
    orders.*,
    lines.line_count,
    lines.units,
    lines.lines_total_cents,
    payments.paid_cents,
    payments.payment_method,
    payments.paid_at,
    case
        when payments.order_id is null then 'unpaid'
        when payments.paid_cents = orders.total_cents then 'matched'
        else 'amount_mismatch'
    end as reconciliation_status
from orders
left join lines using (order_id)
left join payments using (order_id)
