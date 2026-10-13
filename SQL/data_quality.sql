USE OlismDB;

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS missing_order_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS missing_purchase_date
FROM sales.Orders;

SELECT
    order_id,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,order_delivered_customer_date
FROM sales.Orders
WHERE
       (order_approved_at IS NOT NULL
        AND order_approved_at < order_purchase_timestamp)

    OR (order_delivered_carrier_date IS NOT NULL
        AND order_approved_at IS NOT NULL
        AND order_delivered_carrier_date < order_approved_at)

    OR (order_delivered_customer_date IS NOT NULL
        AND order_delivered_carrier_date IS NOT NULL
        AND order_delivered_customer_date < order_delivered_carrier_date);

SELECT order_id,order_status,order_delivered_carrier_date,order_delivered_customer_date
FROM sales.Orders
WHERE order_status = 'delivered'
AND (
       order_delivered_carrier_date IS NULL
    OR order_delivered_customer_date IS NULL
);

SELECT order_id,order_purchase_timestamp,order_estimated_delivery_date
FROM sales.Orders
WHERE order_estimated_delivery_date
      < CAST(order_purchase_timestamp AS date);

SELECT  order_status,COUNT(*) AS order_count
FROM sales.Orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS missing_seller_id,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS missing_price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS missing_freight
FROM sales.Order_item;

SELECT order_id,product_id,price
FROM sales.Order_item
WHERE price <= 0

SELECT order_id,product_id,freight_value
FROM sales.Order_item
WHERE freight_value < 0

SELECT o.order_id,o.customer_id
FROM sales.Orders o
LEFT JOIN sales.Order_customer c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT
    oi.order_id
FROM sales.Order_item oi
LEFT JOIN sales.Orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

SELECT
    oi.order_id,
    oi.product_id
FROM sales.Order_item oi
LEFT JOIN production.Products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT
    oi.order_id,
    oi.seller_id
FROM sales.Order_item oi
LEFT JOIN production.Sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS missing_unique_id,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS missing_zip,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS missing_state
FROM sales.Order_customer;

SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS missing_weight,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS missing_length,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS missing_height,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS missing_width
FROM production.Products;

SELECT
    SUM(CASE WHEN product_weight_g < 0 THEN 1 ELSE 0 END) AS negative_weight,
    SUM(CASE WHEN product_length_cm < 0 THEN 1 ELSE 0 END) AS negative_length,
    SUM(CASE WHEN product_height_cm < 0 THEN 1 ELSE 0 END) AS negative_height,
    SUM(CASE WHEN product_width_cm < 0 THEN 1 ELSE 0 END) AS negative_width
FROM production.Products;

SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS missing_seller_id,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS missing_zip,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS missing_state
FROM production.Sellers;

SELECT
    'Orders - Missing Customer ID' AS check_name,
    COUNT(*) AS issue_count
FROM sales.Orders
WHERE customer_id IS NULL

UNION ALL

SELECT
    'Orders - Invalid Date Sequence',
    COUNT(*)
FROM sales.Orders
WHERE
       (order_approved_at IS NOT NULL
        AND order_approved_at < order_purchase_timestamp)
    OR (order_delivered_carrier_date IS NOT NULL
        AND order_approved_at IS NOT NULL
        AND order_delivered_carrier_date < order_approved_at)
    OR (order_delivered_customer_date IS NOT NULL
        AND order_delivered_carrier_date IS NOT NULL
        AND order_delivered_customer_date < order_delivered_carrier_date)

UNION ALL

SELECT
    'Orders - Missing Delivery Dates',
    COUNT(*)
FROM sales.Orders
WHERE order_status = 'delivered'
AND (
       order_delivered_carrier_date IS NULL
    OR order_delivered_customer_date IS NULL
)

UNION ALL

SELECT
    'Order Items - Invalid Price',
    COUNT(*)
FROM sales.Order_item
WHERE price <= 0

UNION ALL

SELECT
    'Order Items - Negative Freight',
    COUNT(*)
FROM sales.Order_item
WHERE freight_value < 0

UNION ALL

SELECT
    'Orders - Missing Customer Relationship',
    COUNT(*)
FROM sales.Orders o
LEFT JOIN sales.Order_customer c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'Order Items - Missing Order Relationship',
    COUNT(*)
FROM sales.Order_item oi
LEFT JOIN sales.Orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'Order Items - Missing Product Relationship',
    COUNT(*)
FROM sales.Order_item oi
LEFT JOIN production.Products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT
    'Order Items - Missing Seller Relationship',
    COUNT(*)
FROM sales.Order_item oi
LEFT JOIN production.Sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL