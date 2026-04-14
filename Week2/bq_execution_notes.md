[//]: # (Hands-on task: Run the below query, documnet the
 Execution details, and write 3 observations about what you found in&#41;)

WITH monthly_category_stats AS (
  -- Step 1: Aggregate data by Month, Region, and Category
  SELECT
    region,
    category,
    DATE_TRUNC(order_date, MONTH) AS order_month,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue
  FROM `raw_layer.orders_partitioned`
  WHERE order_date >= '2024-01-01'
  GROUP BY 1, 2, 3
)

-- Step 2: Apply Ranking and Filtering on the aggregated set
SELECT
  *,
  ROUND(total_revenue, 2) AS revenue,
  ROUND(total_revenue / total_orders, 2) AS avg_order_value,
  RANK() OVER (
    PARTITION BY region, order_month
    ORDER BY total_revenue DESC
  ) AS category_rank_in_region
FROM monthly_category_stats
QUALIFY category_rank_in_region <= 3
ORDER BY order_month, region, category_rank_in_region


## DETAILS

### Elapsed time : 625 ms
### Slot time consumed : 22.98 sec
### Bytes shuffled : 2.7 MB
### Bytes spilled to disk : 0 B