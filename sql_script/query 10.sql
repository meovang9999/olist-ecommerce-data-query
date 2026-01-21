SELECT 
	YEAR(a.order_approved_at) year,
	COUNT(a.order_id) AS total_orders_delivered,
    ROUND(AVG(DATEDIFF(a.order_delivered_customer_date, a.order_purchase_timestamp))) AS avg_day_to_deliver,
	CONCAT(ROUND(AVG(IF(a.order_delivered_customer_date <= a.order_estimated_delivery_date,1,0)) * 100,2),"%") AS on_time_delivery_rate,
    ROUND(AVG(IF(a.order_delivered_customer_date <= a.order_estimated_delivery_date, DATEDIFF(a.order_estimated_delivery_date,a.order_delivered_customer_date), NULL))) AS avg_days_before_estimate,
	CONCAT(ROUND(AVG(IF(a.order_delivered_customer_date > a.order_estimated_delivery_date,1,0)) * 100,2),'%') AS late_delivery_rate,
    ROUND(AVG(IF(a.order_delivered_customer_date > a.order_estimated_delivery_date, DATEDIFF(a.order_delivered_customer_date, a.order_estimated_delivery_date), NULL))) AS avg_days_past_estimate
    
FROM olist_orders a
WHERE a.order_status = 'delivered' AND YEAR(a.order_approved_at) IS NOT NULL
GROUP BY year
ORDER BY year ASC
	