with sessions as (
    select
        customer_id,
        min(started_at) as first_seen_at,
        arg_min(app_source, started_at) as first_app_source,
        count(*) as sessions
    from {{ ref('int_sessions') }}
    where customer_id is not null
    group by customer_id
),

orders as (
    select
        customer_id,
        count(*) as orders,
        sum(total_cents) as lifetime_value_cents,
        min(ordered_at) as first_order_at,
        max(ordered_at) as last_order_at
    from {{ ref('fct_orders') }}
    group by customer_id
)

select
    sessions.customer_id,
    sessions.first_seen_at,
    sessions.first_app_source,
    sessions.sessions,
    coalesce(orders.orders, 0) as orders,
    coalesce(orders.lifetime_value_cents, 0) as lifetime_value_cents,
    orders.first_order_at,
    orders.last_order_at
from sessions
left join orders using (customer_id)
