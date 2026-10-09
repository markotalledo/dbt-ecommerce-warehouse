-- Each funnel step can only lose sessions, never gain them.
select *
from {{ ref('fct_daily_funnel') }}
where not (
    sessions >= sessions_with_view
    and sessions_with_view >= sessions_with_cart
    and sessions_with_cart >= sessions_with_checkout
    and sessions_with_checkout >= sessions_with_order
)
