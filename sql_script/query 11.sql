WITH 
category_logistic AS
(
SELECT 
	a.*,
	d.product_category_name_english
FROM olist_orders a
LEFT JOIN olist_order_items b ON a.order_id = b.order_id
LEFT JOIN olist_products c ON b.product_id = c.product_id
LEFT JOIN product_category_name_translation d ON c.product_category_name = d.product_category_name
WHERE a.order_status = 'delivered' AND YEAR(a.order_approved_at) IS NOT NULL
)

SELECT
	REPLACE(a.product_category_name_english,'_'," ") AS product_category,
	COUNT(a.order_id) AS total_orders_delivered,
    ROUND(AVG(DATEDIFF(a.order_delivered_customer_date, a.order_purchase_timestamp))) AS avg_day_to_deliver,
	CONCAT(ROUND(AVG(IF(a.order_delivered_customer_date <= a.order_estimated_delivery_date,1,0)) * 100,2),"%") AS on_time_delivery_rate,
    ROUND(AVG(IF(a.order_delivered_customer_date <= a.order_estimated_delivery_date, DATEDIFF(a.order_estimated_delivery_date,a.order_delivered_customer_date), NULL))) AS avg_days_before_estimate,
	CONCAT(ROUND(AVG(IF(a.order_delivered_customer_date > a.order_estimated_delivery_date,1,0)) * 100,2),'%') AS late_delivery_rate,
    ROUND(AVG(IF(a.order_delivered_customer_date > a.order_estimated_delivery_date, DATEDIFF(a.order_delivered_customer_date, a.order_estimated_delivery_date), NULL))) AS avg_days_past_estimate
FROM category_logistic a
GROUP BY product_category
ORDER BY total_orders_delivered DESC;