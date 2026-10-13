USE OlismDB;

;WITH Monthly_sales AS(
SELECT YEAR(order_purchase_timestamp) year, MONTH(order_purchase_timestamp) month,ROUND(SUM(payment_value),2) current_month_sales,
LAG(ROUND(SUM(payment_value),2)) OVER(ORDER BY YEAR(order_purchase_timestamp),MONTH(order_purchase_timestamp)) previous_month_sales
FROM sales.Orders O
JOIN sales.Order_payment P ON O.order_id = P.order_id
WHERE order_status = 'delivered'
GROUP BY YEAR(order_purchase_timestamp),MONTH(order_purchase_timestamp)
 )
SELECT *,ROUND(100 * (current_month_sales-previous_month_sales)/previous_month_sales,2) precentage_growth  FROM Monthly_sales;




WITH Customer_state_and_Best_category_sales AS (
SELECT DENSE_RANK() OVER(PARTITION BY customer_state ORDER BY SUM(price) DESC) Rank,
customer_state,product_category_English_name, ROUND(SUM(price),2) total_sales
FROM sales.Order_customer c
LEFT JOIN sales.Orders o ON o.customer_id = c.customer_id
LEFT JOIN sales.Order_item i ON i.order_id =o.order_id 
LEFT JOIN production.Products p ON p.product_id = i.product_id
LEFT JOIN production.product_category_name n ON n.product_category_name = p.product_category_name
WHERE order_status = 'delivered'
GROUP BY customer_state, product_category_English_name	)
SELECT * FROM Customer_state_and_Best_category_sales
WHERE RANK <= 3;

SELECT customer_state,AVG(DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date)) AVG_Actual_Delivery_Days,
AVG(DATEDIFF(DAY,order_purchase_timestamp,order_estimated_delivery_date)) AVG_Estimated_Delivery_Days,
SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) late_deliveries,
100*SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) /COUNT(DISTINCT O.order_id) rate_late,
ROUND(AVG(freight_value),2) avg_Freight_Cost,
ROUND(100 * SUM(freight_value)/SUM(price),2) freight_to_price_ratio
FROM sales.Order_item i
JOIN sales.Orders O ON O.order_id = i.order_id
JOIN sales.Order_customer c ON O.customer_id = c.customer_id 
WHERE  order_status = 'delivered'
GROUP BY customer_state;

SELECT CASE WHEN product_weight_g < 1000 THEN 'Light' WHEN product_weight_g BETWEEN 1000 AND 5000 THEN 'Medium' ELSE 'Heavy' END,
COUNT(DISTINCT O.order_id) total_orders,
ROUND(AVG(freight_value),2) avg_freight_cost,
ROUND(AVG(DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date)),2) avg_delivery_days
FROM production.Products P
JOIN sales.Order_item I ON P.product_id = I.product_id 
JOIN sales.Orders O ON O.order_id = I.order_id
WHERE  order_status = 'delivered' AND product_weight_g IS NOT NULL
GROUP BY CASE WHEN product_weight_g < 1000 THEN 'Light' WHEN product_weight_g BETWEEN 1000 AND 5000 THEN 'Medium' ELSE 'Heavy' END;

SELECT review_score, COUNT(DISTINCT o.order_id) total_order,
AVG(DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date)) AVG_Actual_Delivery_Days,
ROUND(AVG(freight_value),2) avg_freight_cost
FROM sales.Order_reviews r
JOIN sales.Orders o ON o.order_id = r.order_id
JOIN sales.Order_item i ON o.order_id = i.order_id
GROUP BY review_score;

;WITH review_service AS (
SELECT O.order_id,DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date) Actual_Delivery_Days,
DATEDIFF(DAY,order_estimated_delivery_date,order_delivered_customer_date) delay_days,SUM(ROUND(payment_value,2)) cost,AVG(review_score) review_score  FROM sales.Order_reviews R
JOIN sales.Orders O  ON R.order_id = O.order_id
JOIN sales.Order_payment P ON P.order_id = O.order_id
WHERE order_status = 'delivered'
GROUP BY O.order_id,order_purchase_timestamp,order_delivered_customer_date,order_estimated_delivery_date)
SELECT * FROM review_service;

;WITH DDD AS(SELECT customer_unique_id,
FORMAT(MIN(order_purchase_timestamp) OVER( PARTITION BY customer_unique_id) ,'yyyy-MM') cohort_month
,order_purchase_timestamp, 
DATEDIFF(MONTH,MIN(order_purchase_timestamp) OVER( PARTITION BY customer_unique_id),order_purchase_timestamp) + 1 CohortIndex
FROM sales.Order_customer c
JOIN sales.Orders o ON c.customer_id = o.customer_id
WHERE order_status = 'delivered')
SELECT cohort_month,CohortIndex,COUNT(DISTINCT customer_unique_id) AS total_customers
FROM DDD
GROUP BY cohort_month, CohortIndex
ORDER BY cohort_month, CohortIndex;