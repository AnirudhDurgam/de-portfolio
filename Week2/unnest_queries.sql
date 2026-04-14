--Hands-on task:
--Write a query that finds customers who have 'delivered' status in any of their recent_orders. Use UNNEST and filter on order_item.status = 'delivered'.


-- Check what statuses actually exist in your recent_orders arrays
SELECT DISTINCT order_item.status
FROM `raw_layer.customer_profiles` cp,
UNNEST(cp.recent_orders) AS order_item

-- Query
SELECT DISTINCT
  cp.customer_id,
  cp.lifetime_value,
  order_item.order_id,
  order_item.order_date,
  order_item.status
FROM `raw_layer.customer_profiles` cp,
UNNEST(cp.recent_orders) AS order_item
WHERE order_item.status = 'Delivered'
ORDER BY cp.lifetime_value DESC;


