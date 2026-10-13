USE OlismDB;

SELECT ROUND(SUM(payment_value),2) Total_sales,COUNT(DISTINCT p.order_id) Num_orders,ROUND(SUM(payment_value)/COUNT(DISTINCT p.order_id),2) AOV FROM sales.Order_payment p
JOIN sales.Orders o ON o.order_id = p.order_id
WHERE order_status = 'delivered';

SELECT order_status, ROUND(SUM(payment_value),2) total_sales, COUNT(DISTINCT o.order_id) num_order, ROUND(SUM(payment_value)/COUNT(DISTINCT o.order_id),2) avg_amount_order   FROM sales.Order_payment p
JOIN sales.Orders o ON o.order_id = p.order_id
GROUP BY order_status;

SELECT  YEAR(order_purchase_timestamp) year , ROUND(SUM(payment_value),2) year_sales FROM sales.Orders O
JOIN sales.Order_payment Op ON O.order_id = Op.order_id
WHERE order_status = 'delivered'
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp) ASC;

SELECT  FORMAT(order_purchase_timestamp,'yyyy-MM') month_date, ROUND(SUM(payment_value),2) month_sales FROM sales.Orders O
JOIN sales.Order_payment Op ON O.order_id = Op.order_id
WHERE order_status = 'delivered'
GROUP BY FORMAT(order_purchase_timestamp,'yyyy-MM')
ORDER BY FORMAT(order_purchase_timestamp,'yyyy-MM') ASC;

SELECT TOP 10 product_id,ROUND(SUM(price),2) Best_selling_products   FROM sales.Order_item
GROUP BY product_id
ORDER BY SUM(price) DESC;

SELECT TOP 10 product_category_English_name category,ROUND(SUM(price),2) Best_selling_category   FROM sales.Order_item i
JOIN production.Products p ON p.product_id = i.product_id
JOIN production.product_category_name c ON c.product_category_name =p.product_category_name
GROUP BY product_category_English_name
ORDER BY SUM(price) DESC;


SELECT customer_unique_id,ROUND(SUM(payment_value),2) customer_spending
,COUNT(DISTINCT o.order_id) num_customer_orders,
ROUND(SUM(payment_value),2)/COUNT(DISTINCT o.order_id) avg_customer_order,
DATEDIFF(DAY,MAX(order_purchase_timestamp),(SELECT DATEADD(DAY,1,MAX(order_purchase_timestamp) ) FROM sales.Orders WHERE order_status = 'delivered')) diff_days_to_last_purchase FROM sales.Order_payment p
JOIN sales.Orders o ON o.order_id = p.order_id
JOIN sales.Order_customer c ON o.customer_id = c.customer_id
WHERE order_status = 'delivered'
GROUP BY customer_unique_id
ORDER BY SUM(payment_value) DESC;

SELECT customer_state ,ROUND(SUM(payment_value),2) sales_state, COUNT(DISTINCT o.order_id) num_order_state, ROUND(SUM(payment_value)/COUNT(DISTINCT o.order_id),2) avg_order_state    FROM sales.Order_customer c
JOIN sales.Orders o ON c.customer_id = o.customer_id
JOIN sales.Order_payment p ON o.order_id = p.order_id
WHERE order_status = 'delivered'
GROUP BY customer_state
ORDER BY SUM(payment_value) DESC;

SELECT TOP(10) seller_id,ROUND(SUM(price+freight_value),2) total_sales,COUNT(DISTINCT o.order_id) num_orders,ROUND(SUM(price+freight_value)/COUNT(DISTINCT o.order_id),2) avg_order_seller FROM sales.Order_item i
JOIN sales.Orders o ON o.order_id =i.order_id
WHERE order_status = 'delivered'
GROUP BY seller_id
ORDER BY SUM(price+freight_value) DESC;

