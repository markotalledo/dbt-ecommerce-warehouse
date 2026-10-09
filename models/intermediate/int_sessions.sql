-- One row per session. An anonymous session that logs in at checkout carries the
-- customer_id only on its last events; max() resolves it for the whole session.
with events as (
    select * from {{ ref('stg_shop__events') }}
)

select
    session_id,
    any_value(anonymous_id) as anonymous_id,
    max(customer_id) as customer_id,
    bool_or(customer_id is null) and max(customer_id) is not null as identified_at_checkout,
    any_value(app_source) as app_source,
    min(occurred_at) as started_at,
    max(occurred_at) as ended_at,
    cast(min(occurred_at) as date) as session_date,
    count(*) as events,
    count(*) filter (where event_name = 'product_viewed') as product_views,
    count(*) filter (where event_name = 'product_added_to_cart') as cart_adds,
    bool_or(event_name = 'checkout_started') as reached_checkout,
    bool_or(event_name = 'order_completed') as placed_order,
    max(arrival_lag_hours) as max_arrival_lag_hours
from events
group by session_id
