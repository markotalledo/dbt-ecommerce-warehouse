{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key=['session_date', 'app_source'],
    )
}}

-- Late events can complete a session days later, so every run recounts the last
-- funnel_lookback_days days instead of only appending today.
with sessions as (
    select * from {{ ref('int_sessions') }}
    {% if is_incremental() %}
    where session_date >= (select max(session_date) from {{ this }}) - interval {{ var('funnel_lookback_days') }} day
    {% endif %}
)

select
    session_date,
    app_source,
    count(*) as sessions,
    count(*) filter (where product_views > 0) as sessions_with_view,
    count(*) filter (where cart_adds > 0) as sessions_with_cart,
    count(*) filter (where reached_checkout) as sessions_with_checkout,
    count(*) filter (where placed_order) as sessions_with_order,
    round(count(*) filter (where placed_order) / count(*), 4) as conversion_rate
from sessions
group by session_date, app_source
