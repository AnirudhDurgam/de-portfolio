--Actual Query without CTE
SELECT
  customer_id,
  total_amount
FROM `raw_layer.orders_partitioned`
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM `raw_layer.orders_partitioned`
    WHERE order_date >= '2024-01-01'
)
AND order_date >= '2024-01-01'
ORDER BY total_amount DESC
LIMIT 20

-- Query With CTEs
WITH avg_amount AS (
    SELECT AVG(total_amount) AS avg_val
    FROM `raw_layer.orders_partitioned`
    WHERE order_date >= '2024-01-01'
)
SELECT
  o.customer_id,
  o.total_amount
FROM `raw_layer.orders_partitioned` o
CROSS JOIN avg_amount
WHERE o.total_amount > avg_amount.avg_val
AND o.order_date >= '2024-01-01'
ORDER BY total_amount DESC
LIMIT 20
