WITH 
state_logistic AS
(
SELECT 
	a.*,
    b.customer_city,
    b.customer_state
FROM olist_orders a
LEFT JOIN olist_customers b ON a.customer_id = b.customer_id
WHERE a.order_status = 'delivered' AND YEAR(a.order_approved_at) IS NOT NULL
)
SELECT
	a.customer_city AS city, a.customer_state AS state,
	COUNT(a.order_id) AS total_orders_delivered,
    ROUND(AVG(DATEDIFF(a.order_delivered_customer_date, a.order_purchase_timestamp))) AS avg_day_to_deliver,
	CONCAT(ROUND(AVG(IF(a.order_delivered_customer_date <= a.order_estimated_delivery_date,1,0)) * 100,2),"%") AS on_time_delivery_rate,
    ROUND(AVG(IF(a.order_delivered_customer_date <= a.order_estimated_delivery_date, DATEDIFF(a.order_estimated_delivery_date,a.order_delivered_customer_date), NULL))) AS avg_days_before_estimate,
	CONCAT(ROUND(AVG(IF(a.order_delivered_customer_date > a.order_estimated_delivery_date,1,0)) * 100,2),'%') AS late_delivery_rate,
    ROUND(AVG(IF(a.order_delivered_customer_date > a.order_estimated_delivery_date, DATEDIFF(a.order_delivered_customer_date, a.order_estimated_delivery_date), NULL))) AS avg_days_past_estimate
FROM state_logistic a
GROUP BY city, state
ORDER BY total_orders_delivered DESC;