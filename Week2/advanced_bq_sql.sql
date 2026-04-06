-- ============================================
-- Week 2: Advanced BQ SQL -- DE Pipeline Patterns
-- Anirudh Durgam | de-portfolio
-- ============================================

-- Pattern 1a: Deduplication -- keep latest record per order_id
-- Used in: Raw → Bronze transformation step

-- Check for duplicate records
-- First let's see if duplicates exist in your raw table
SELECT
  order_id,
  COUNT(*) AS occurrences
FROM `raw_layer.orders_raw`
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 10
-- Cleaning duplicate records

-- DE deduplication pattern -- keep latest record per order_id
CREATE OR REPLACE TABLE `raw_layer.orders_deduped` AS
SELECT * EXCEPT(row_num)
FROM (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY order_id
      ORDER BY order_date DESC
    ) AS row_num
  FROM `raw_layer.orders_raw`
)
WHERE row_num = 1

-- Pattern 1b: Change detection using LAG
-- Used in: CDC pipeline, slowly changing dimensions

-- Detect orders where status changed from previous order for same customer
SELECT
  customer_id,
  order_id,
  order_date,
  status,
  LAG(status) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
  ) AS previous_status,
  CASE
    WHEN status != LAG(status) OVER (
      PARTITION BY customer_id
      ORDER BY order_date
    ) THEN 'CHANGED'
    ELSE 'SAME'
  END AS status_change_flag
FROM `raw_layer.orders_partitioned`
WHERE order_date >= '2024-01-01'
ORDER BY customer_id, order_date
LIMIT 20

-- Pattern 2: Gold layer customer profiles with nested ARRAY_AGG
-- Used in: Silver → Gold aggregation step

-- Build a customer profile table for the Gold layer
CREATE OR REPLACE TABLE `raw_layer.customer_profiles` AS
SELECT
  customer_id,
  COUNT(DISTINCT order_id)                    AS total_orders,
  ROUND(SUM(total_amount), 2)                 AS lifetime_value,
  ROUND(AVG(total_amount), 2)                 AS avg_order_value,
  MIN(order_date)                             AS first_order_date,
  MAX(order_date)                             AS last_order_date,
  DATE_DIFF(MAX(order_date),
            MIN(order_date), DAY)             AS customer_tenure_days,

  -- Nest the top 3 most recent orders inside each customer row
  ARRAY_AGG(
    STRUCT(
      order_id,
      order_date,
      product,
      category,
      total_amount,
      status
    )
    ORDER BY order_date DESC
    LIMIT 3
  ) AS recent_orders,

  -- Count orders by category as a nested struct
  ARRAY_AGG(
    DISTINCT category
  ) AS purchased_categories

FROM `raw_layer.orders_partitioned`
WHERE order_date >= '2024-01-01'
GROUP BY customer_id
ORDER BY lifetime_value DESC

-- Pattern 3: QUALIFY for latest record per dimension combination
-- Used in: Gold layer dimension tables

-- Get latest order per customer per category -- clean QUALIFY pattern
SELECT
  customer_id,
  category,
  order_id,
  order_date,
  total_amount,
  status
FROM `raw_layer.orders_partitioned`
WHERE order_date >= '2024-01-01'
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY customer_id, category
  ORDER BY order_date DESC, total_amount DESC
) = 1
ORDER BY customer_id, category