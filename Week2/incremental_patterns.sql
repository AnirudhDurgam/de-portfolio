--Hands-on task:
--Implement the partition overwrite pattern on your orders_final table for order_date = '2024-06-01'. Verify row count before and after

-- Step 1: Count before
SELECT COUNT(*) AS rows_before
FROM `raw_layer.orders_final`
WHERE order_date = '2024-06-01';

-- Step 2: Delete the partition
DELETE FROM `raw_layer.orders_final`
WHERE order_date = '2024-06-01';

-- Step 3: Reinsert from source
INSERT INTO `raw_layer.orders_final`
SELECT *
FROM `raw_layer.orders_partitioned`
WHERE order_date = '2024-06-01'


-- Step 4: Count after to verify
SELECT COUNT(*) AS rows_after
FROM `raw_layer.orders_final`
WHERE order_date = '2024-06-01';

