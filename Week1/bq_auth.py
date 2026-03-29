from google.cloud import bigquery

client = bigquery.Client(project="project-1fba95d4-2f97-44d1-b3c")

# Query 1 -- basic select with partition filter
query_1 = """
    SELECT
        order_id,
        customer_id,
        order_date,
        total_amount,
        status,
        region
    FROM `raw_layer.orders_partitioned`
    WHERE order_date = '2024-01-15'
    LIMIT 10
"""

print("=== Query 1: Orders on 2024-01-15 ===")
results = client.query(query_1).result()
for row in results:
    print(dict(row))

# Query 2 -- aggregation via Python
query_2 = """
    SELECT
        region,
        COUNT(order_id) AS total_orders,
        ROUND(SUM(total_amount), 2) AS total_revenue
    FROM `raw_layer.orders_partitioned`
    WHERE order_date >= '2024-01-01'
    GROUP BY region
    ORDER BY total_revenue DESC
"""

print("\n=== Query 2: Revenue by region ===")
results = client.query(query_2).result()
for row in results:
    print(f"Region: {row['region']} | Orders: {row['total_orders']} | Revenue: {row['total_revenue']}")

print("\nDone. ADC auth working correctly.")