--Hands-on task: Write a BQ script that declares a target_date variable, checks if data exists for that date in orders_partitioned, prints the row count if data exists,
 -- and prints a warning message if it doesn't.

 DECLARE target_date DATE DEFAULT '2024-06-01';
DECLARE row_count INT64;

SET row_count = (
  SELECT COUNT(*)
  FROM `raw_layer.orders_partitioned`
  WHERE order_date = target_date
);

IF row_count = 0 THEN
  SELECT CONCAT('WARNING: No data found for ',
                CAST(target_date AS STRING)) AS message;
ELSE
  SELECT CONCAT('Data exists for ',
                CAST(target_date AS STRING),
                ' — row count: ',
                CAST(row_count AS STRING)) AS message;
END IF;


